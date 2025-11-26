import cv2
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import FastICA
from sklearn.preprocessing import StandardScaler
from scipy.signal import butter, filtfilt
from tqdm import tqdm

face_cascade = cv2.CascadeClassifier(
    cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
)

video_paths = [
    "OV5640VideoCapture/15sJonatan1.mp4",
    "OV5640VideoCapture/15sJonatan2.mp4",
    "OV5640VideoCapture/15sJonatan3.mp4",
    "OV5640VideoCapture/15sSydney1.mp4", 
    "OV5640VideoCapture/15sSydney2.mp4",
    "OV5640VideoCapture/15sSydney3.mp4"
]

video_data = {}
first_frames = {}

# ---- SETTINGS ----
DOWNSCALE = 0.25     # resize factor for face detection
FRAME_SKIP = 2       # reduces 60 FPS → 30 FPS
MIN_FACE_SIZE = (40, 40)

# ---- PHASE 1: Extract RGB per frame with FAST face detection ----

for idx, path in enumerate(video_paths, start=1):

    cap = cv2.VideoCapture(path)
    if not cap.isOpened():
        print(f"Could not open {path}")
        continue

    reds, greens, blues = [], [], []
    last_face = None
    first_face_frame = None
    frame_idx = 0

    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

    print(f"\nProcessing {path} ({total_frames} frames)...")

    for _ in tqdm(range(total_frames), desc=f"Video {idx}"):
        ret, frame = cap.read()
        if not ret:
            break

        # ---- Skip frames to reduce to ~30 FPS ----
        frame_idx += 1
        if frame_idx % FRAME_SKIP != 0:
            continue

        # ---- Downsample for fast face detect ----
        small = cv2.resize(frame, (0, 0), fx=DOWNSCALE, fy=DOWNSCALE)
        gray_small = cv2.cvtColor(small, cv2.COLOR_BGR2GRAY)

        faces = face_cascade.detectMultiScale(
            gray_small,
            scaleFactor=1.1,
            minNeighbors=4,
            minSize=MIN_FACE_SIZE
        )

        if len(faces) > 0:
            x, y, w, h = max(faces, key=lambda f: f[2] * f[3])
            # Scale back to original coords
            x, y, w, h = [int(v / DOWNSCALE) for v in (x, y, w, h)]
            last_face = (x, y, w, h)

            if first_face_frame is None:
                ff = frame.copy()
                cv2.rectangle(ff, (x, y), (x+w, y+h), (0,255,0), 2)
                first_face_frame = ff

        elif last_face is None:
            continue  # no face yet

        x, y, w, h = last_face
        roi = frame[y:y+h, x:x+w]

        rgb = cv2.cvtColor(roi, cv2.COLOR_BGR2RGB)
        reds.append(np.mean(rgb[:,:,0]))
        greens.append(np.mean(rgb[:,:,1]))
        blues.append(np.mean(rgb[:,:,2]))

    cap.release()

    name = f"video{idx}"
    video_data[name] = {"R": reds, "G": greens, "B": blues}

    if first_face_frame is not None:
        first_frames[name] = first_face_frame

# ---- PHASE 2: Show first frames ----
for name, frame in first_frames.items():
    plt.figure(figsize=(5,4))
    plt.imshow(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
    plt.title(name)
    plt.axis("off")
plt.show()

# ---- PHASE 3: Prepare combined RGB for ICA ----

combined = np.concatenate([
    np.vstack([v["R"], v["G"], v["B"]]).T
    for v in video_data.values()
], axis=0)

# Normalize before ICA
scaler = StandardScaler()
combined_norm = scaler.fit_transform(combined)

# ---- PHASE 4: ICA ----
print("\nFitting ICA model...")
ica = FastICA(n_components=3, random_state=0, max_iter=500)
S_all = ica.fit_transform(combined_norm)

A = ica.mixing_
W = ica.components_
print("\nMixing Matrix:\n", A)
print("\nUnmixing Matrix:\n", W)

# ---- PHASE 5: Apply ICA to each video ----
ica_results = {}
for name, dat in video_data.items():
    X = np.vstack([dat["R"], dat["G"], dat["B"]]).T
    Xn = scaler.transform(X)
    S = ica.transform(Xn)
    ica_results[name] = S

# ---- BANDPASS + FFT FUNC ----
def butter_bandpass(low, high, fs):
    b, a = butter(4, [low/(fs/2), high/(fs/2)], btype='band')
    return b, a

def bandpass(sig, fs):
    b, a = butter_bandpass(0.8, 3.5, fs)
    return filtfilt(b, a, sig)

# ---- PHASE 6: Plot ICA1 + FFT (small plots, non-blocking) ----

fig, axes = plt.subplots(2, 3, figsize=(14,8))
axes = axes.flatten()

for i, (name, S) in enumerate(ica_results.items()):
    sig = S[:,0]
    sig = (sig - np.mean(sig)) / np.std(sig)

    sig_f = bandpass(sig, fs=30)
    fft = np.abs(np.fft.rfft(sig_f))
    freq = np.fft.rfftfreq(len(sig_f), 1/30)

    bpm = freq[np.argmax(fft[1:])] * 60

    ax = axes[i]
    ax.plot(sig, lw=1)
    ax2 = ax.twinx()
    ax2.plot(freq, fft, lw=1, alpha=0.7)
    ax.set_title(f"{name} — {bpm:.1f} BPM")

plt.tight_layout()
plt.show()
