import librosa
import librosa.display
import matplotlib.pyplot as plt
import numpy as np
from sklearn.cluster import KMeans

map_output = 'maps/Sad_Scene_map.txt'
audio_path = 'assets/music/Sad_Scene.wav'
y, sr = librosa.load(audio_path)

onset_env = librosa.onset.onset_strength(y=y, sr=sr)
onsets_frames = librosa.onset.onset_detect(onset_envelope=onset_env, sr=sr)
onsets_time = librosa.frames_to_time(onsets_frames, sr=sr)

fft_size = 2048
hop_length = 512
frequencies = np.fft.rfftfreq(fft_size, d=1/sr)
onsets_frequency = []

for onset_frame in onsets_frames:
  frame = y[onset_frame*hop_length:(onset_frame+1)*hop_length]
  magnitudes = np.abs(np.fft.rfft(frame, n=fft_size))
  peak_index = np.argmax(magnitudes)
  peak_frequency = frequencies[peak_index]
  onsets_frequency.append(peak_frequency)

'''
# Uncomment to see the detected onsets
plt.figure(figsize=(10, 6))
librosa.display.waveshow(y, sr=sr, alpha=0.5)
plt.vlines(onsets_time, ymin=-1, ymax=1, color='r', linestyle='--', label='Onsets')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.title('Audio Waveform with Detected Onsets')
plt.legend()
plt.show()
'''

kmeans = KMeans(n_clusters=4)
clusters = kmeans.fit_predict(np.array(onsets_frequency).reshape(-1, 1))

data_output = '\n'.join([f'{time} {cluster}' for time, cluster in zip(onsets_time, clusters)])
data_output += '\n0 -1'
with open(map_output, 'w') as f:
  f.write(data_output)