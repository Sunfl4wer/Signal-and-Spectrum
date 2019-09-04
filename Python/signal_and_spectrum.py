import sys
import pyqtgraph as pg
from pyqtgraph.Qt import QtGui, QtCore

# Processing
from cmath import exp, pi  # cmath for complex number
import numpy as np
import pyaudio

# Performance
import time

# N muse be a 2**n integers 
def compute_fft(x):
    N = len(x)
    if N <= 1:
        return x
    even = compute_fft(x[0::2])
    odd = compute_fft(x[1::2])

    T = [exp(-2j * pi * k / N) * odd[k] for k in range(N // 2)]
    return np.array([even[k] + T[k] for k in range(N // 2)] + [even[k] - T[k] for k in range(N // 2)])

CHUNK = 1024  # number of samples for each time analyze
FORMAT = pyaudio.paInt16  # 2 bytes per sample
CHANNELS = 1  # single channel (left)
RATE = 44100  # sampling rate

# Stream a buffer of voice data from microphone
voice = pyaudio.PyAudio()
stream = voice.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    output=True,
                    frames_per_buffer=CHUNK)

app = QtGui.QApplication.instance()
if not app:  # create QApplication if it doesnt exist
    app = QtGui.QApplication(sys.argv)

pg.setConfigOptions(antialias=False)
win = pg.GraphicsWindow(title='Spectrum Analyzer')
win.setGeometry(5, 115, 1000, 500)
# Create object for updaing data
waveform = win.addPlot(title='Waveform', row=1, col=1)
spectrum = win.addPlot(title='Spectrum', row=2, col=1)
# Plot signal in time domain
wf = waveform.plot(pen='c', width=3)
waveform.setXRange(0, CHUNK)
waveform.setYRange(-2 ** 15, 2 ** 15)
# Plot signal in frequency domain
sp = spectrum.plot(pen='c', width=3)
spectrum.setXRange(0, RATE / 2)
spectrum.setYRange(0, 1)

# Create x line for plot
x_wf = np.arange(0, CHUNK)
x_sp = np.linspace(0, RATE // 2, CHUNK // 2)


def update():
    data = stream.read(CHUNK)
    data = np.frombuffer(data, dtype=np.int16)
    # Update voice data
    wf.setData(x_wf, data)

    # Update spectrum 
    sp_data = (2 / (CHUNK * 2 ** 5)) * np.abs(compute_fft(data)[0:int(CHUNK / 2)])
    sp.setData(x_sp, sp_data)


timer = QtCore.QTimer()
timer.timeout.connect(update)
timer.start(20)
if (sys.flags.interactive != 1) or not hasattr(QtCore, 'PYQT_VERSION'):
    app.exec_()
app.quit()



