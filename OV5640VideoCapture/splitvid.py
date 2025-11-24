import cv2
import numpy as np

# ---- source video (1 video) ----
src_video = "OV5640VideoCapture/Jonatan1_5640.mp4"
cap = cv2.VideoCapture(src_video)

if not cap.isOpened():
    print("Could not open input video.")
    raise SystemExit

# Get video properties
fps = cap.get(cv2.CAP_PROP_FPS)
width  = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fourcc = cv2.VideoWriter_fourcc(*'mp4v')

# Read all frames first
frames = []
while True:
    ret, frame = cap.read()
    if not ret:
        break
    frames.append(frame)

cap.release()

total_frames = len(frames)
chunk_size = total_frames // 4
print(f"Total frames: {total_frames}, frames per chunk: {chunk_size}")

# ---- Write the 4 output videos ----
output_paths = [
    "OV5640VideoCapture/Jonatan1_5640_part1.mp4",
    "OV5640VideoCapture/Jonatan1_5640_part2.mp4",
    "OV5640VideoCapture/Jonatan1_5640_part3.mp4",
    "OV5640VideoCapture/Jonatan1_5640_part4.mp4"
]

for i in range(4):
    start = i * chunk_size
    end = (i+1) * chunk_size if i < 3 else total_frames  # last chunk gets leftovers
    
    out = cv2.VideoWriter(output_paths[i], fourcc, fps, (width, height))
    
    for f in range(start, end):
        out.write(frames[f])
    out.release()

print("Video successfully split into 4 parts:")
for p in output_paths:
    print("  ->", p)
