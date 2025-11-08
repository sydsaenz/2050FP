import cv2 
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import FastICA 

face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

video_paths = ["vid1.mov", "vid2.mov", "vid3.mov", "vid4.mov"]

video_data = {}
first_frames = {}

# ---- Step 1: Read videos and compute average RGB in ROI (face only) ----
for idx, path in enumerate(video_paths, start=1):
    cap = cv2.VideoCapture(path)
    if not cap.isOpened():
        print(f"Could not open {path}")
        continue

    reds, greens, blues = [], [], []
    last_face = None
    first_face_frame = None

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(60, 60))

        if len(faces) > 0:
            # Choose largest face
            x, y, w, h = max(faces, key=lambda f: f[2] * f[3])
            last_face = (x, y, w, h)

            # Save the first detected frame for visualization
            if first_face_frame is None:
                first_face_frame = frame.copy()
                cv2.rectangle(first_face_frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
        elif last_face is not None:
            x, y, w, h = last_face
        else:
            continue

        roi = frame[y:y+h, x:x+w]
        frame_rgb = cv2.cvtColor(roi, cv2.COLOR_BGR2RGB)
        reds.append(np.mean(frame_rgb[:, :, 0]))
        greens.append(np.mean(frame_rgb[:, :, 1]))
        blues.append(np.mean(frame_rgb[:, :, 2]))

    cap.release()
    video_name = f"video{idx}"
    video_data[video_name] = {"R": reds, "G": greens, "B": blues}

    # Save the first face frame for visualization
    if first_face_frame is not None:
        first_frames[video_name] = first_face_frame

# # ---- Step 2: Show first detected face frame for each video ----
# for name, frame in first_frames.items():
#     plt.figure(figsize=(5, 4))
#     plt.imshow(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
#     plt.title(f"First detected face - {name}")
#     plt.axis("off")
#     plt.show()

# ---- Step 3: Train one shared ICA model across all videos ----
# Combine all RGB signals
combined_rgb = np.concatenate([
    np.vstack([v["R"], v["G"], v["B"]]).T for v in video_data.values()
], axis=0)

ica = FastICA(n_components=3, random_state=0)
ica.fit(combined_rgb)
A_global = ica.mixing_
W_global = ica.components_

print("\nShared ICA Mixing Matrix (3x3):\n", A_global)
print("\nShared ICA Unmixing Matrix (3x3):\n", W_global)

# ---- Step 4: Apply same ICA model to each video ----
ica_results = {}
for name, data in video_data.items():
    X = np.vstack([data["R"], data["G"], data["B"]]).T
    S_ica = ica.transform(X)  # apply shared ICA model
    ica_results[name] = S_ica

# ---- Do FFT
ica_signals_list = [signals[:, 0] for signals in ica_results.values()]  # first ICA component

fig, axs = plt.subplots(2, 2, figsize=(12, 10))
fig.suptitle("First ICA Component and FFT (per video)", fontsize=16)

for i, signal in enumerate(ica_signals_list):
    n = len(signal)
    t = np.arange(n) / 30
    freq = np.fft.rfftfreq(n, d=1/30)

    # --- Detrend / normalize ---
    sig = signal - np.mean(signal)
    sig /= np.std(sig) if np.std(sig) != 0 else 1

    # --- FFT ---
    fft_mag = np.abs(np.fft.rfft(sig))
    fft_mag /= np.max(fft_mag) if np.max(fft_mag) != 0 else 1

    # --- Estimated BPM from dominant peak ---
    dominant_freq = freq[np.argmax(fft_mag[1:])]  # skip DC bin
    bpm = dominant_freq * 60

    row, col = divmod(i, 2)

    # Time-domain plot (ICA signal)
    axs[row, col].plot(t, sig, color="steelblue", alpha=0.8, label="ICA1 signal")
    axs[row, col].set_xlabel("Time (s)")
    axs[row, col].set_ylabel("Amplitude (a.u.)", color="steelblue")
    axs[row, col].set_title(f"Video {i+1} — est. {bpm:.1f} BPM")

    # Second y-axis for FFT
    ax2 = axs[row, col].twinx()
    ax2.plot(freq, fft_mag, color="purple", alpha=0.7, label="FFT magnitude")
    ax2.set_xlim(0, 5)  # focus on 0–5 Hz (~0–300 bpm)
    ax2.set_ylabel("Normalized FFT", color="purple")

    axs[row, col].grid(True)

plt.tight_layout()
plt.show()

# ---- Step 3: Plot ICA components for all videos ----
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
axes = axes.flatten()

for i, (name, S_ica) in enumerate(ica_results.items()):
    ax = axes[i]
    ax.plot(S_ica[:, 0], label='ICA 1')
    ax.plot(S_ica[:, 1], label='ICA 2')
    ax.plot(S_ica[:, 2], label='ICA 3')
    ax.set_title(f"{name} - ICA Components")
    ax.set_xlabel("Frame #")
    ax.set_ylabel("Amplitude")
    ax.legend()

plt.tight_layout()
plt.show()

# ---- Plot all 4 videos in a 2x2 grid ----
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
axes = axes.flatten()  # flatten 2x2 array into list for easy iteration

for i, (name, data) in enumerate(video_data.items()):
    ax = axes[i]
    ax.plot(data["R"], color='r', label='Red')
    ax.plot(data["G"], color='g', label='Green')
    ax.plot(data["B"], color='b', label='Blue')
    ax.set_title(f"{name}")
    ax.set_xlabel("Frame #")
    ax.set_ylabel("Avg Intensity")
    ax.legend()

# Remove any empty subplots (if <4 videos)
for j in range(i + 1, len(axes)):
    fig.delaxes(axes[j])

plt.tight_layout()
plt.show()