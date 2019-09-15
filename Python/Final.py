# Ref.
# https://github.com/markjay4k/Audio-Spectrum-Analyzer-in-Python
# http://amyboyle.ninja/Pyqtgraph-live-spectrogram

# Plotting
import sys
import pyqtgraph as pg
from pyqtgraph.Qt import QtGui, QtCore

# Processing
from cmath import exp, pi  # cmath for complex number
import numpy as np
import pyaudio


# Compute DFT using FFT alogirthm
def compute_fft(x):
    # N must be a 2^n integer
    N = len(x)
    if N <= 1:
        return x
    even = compute_fft(x[0::2])
    odd = compute_fft(x[1::2])

    T = [exp(-2j * pi * k / N) * odd[k] for k in range(N // 2)]
    return np.array([even[k] + T[k] for k in range(N // 2)] + [even[k] - T[k] for k in range(N // 2)])

# Constant
CHUNK = 1024                # number of samples for each time analyze
FORMAT = pyaudio.paInt16    # 2 bytes per sample
CHANNELS = 1                # single channel (left)
RATE = 44100                # sampling rate

# Stream for taking data from microphone
voice = pyaudio.PyAudio()
stream = voice.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    output=True,
                    frames_per_buffer=CHUNK)

# Create app for plotting signal, spectrum and spectrogram
app = QtGui.QApplication.instance()
if not app:  # create QApplication if it doesnt exist
    app = QtGui.QApplication(sys.argv)

# Set False for faster performance
pg.setConfigOptions(antialias=False)

# Window for contain everything
win = pg.GraphicsWindow(title='Spectrum Analyzer')
win.setGeometry(5, 115, 800, 600)

# Objects for updaing data
waveform = win.addPlot(title='Waveform', row=0, col=1, rowspan =1, colspan=1)
spectrum = win.addPlot(title='Spectrum', row=0, col=2, rowspan =1, colspan=1)
spectrogram = win.addViewBox(name='Spectrogram', row=1, col=1, rowspan =1, colspan=2)

# Plot signal in time domain
wf = waveform.plot(pen='c', width=3)
waveform.setXRange(0, CHUNK)
waveform.setYRange(-2 ** 15, 2 ** 15)

# Plot signal in frequency domain
sp = spectrum.plot(pen='c', width=3)
spectrum.setXRange(0, RATE // 2)
spectrum.setYRange(0, 1)

# Spectrogram
img = pg.ImageItem()
img_array = np.zeros((1000, CHUNK//2+1))
# Color maping
pos = np.array([0., 1., 0.5, 0.25, 0.75])
color = np.array([[0,255,255,255], [255,255,0,255], [0,0,0,255], (0, 0, 255, 255), (255, 0, 0, 255)], dtype=np.ubyte)
cmap = pg.ColorMap(pos, color)
lut = cmap.getLookupTable(0.0, 1.0, 256)
img.setLookupTable(lut)
img.setLevels([-50,40])
# Frequencies for spectrogram - Xscale
freq = np.arange((CHUNK//2)+1)/(float(CHUNK)/RATE)
yscale = 1.0/(img_array.shape[1]/freq[-1])
img.scale((1./RATE)*CHUNK, yscale)
# Show axis of spectrogram
spectrogram.addItem(img)
yScale = pg.AxisItem(orientation='left', linkView=spectrogram)
win.addItem(yScale, 1, 0)
xScale = pg.AxisItem(orientation='bottom', linkView=spectrogram)
win.addItem(xScale, 2, 1, rowspan=1,colspan= 2)

# Create x line for plot
x_wf = np.arange(0, CHUNK)
x_sp = np.linspace(0, RATE // 2, CHUNK // 2)

# Updating plot data to the window
def update():
    global img_array
    # Reading data
    data = stream.read(CHUNK)
    data = np.frombuffer(data, dtype=np.int16)

    # Update signal in time domain
    wf.setData(x_wf, data)

    # Update signal in frequency domian
    computed_fft = compute_fft(data)
    sp_data = (2 / (CHUNK * 2 ** 14)) * np.abs(computed_fft[0:int(CHUNK / 2)])
    sp.setData(x_sp, sp_data)

    # Update spectrogram
    spec = computed_fft[0:int(CHUNK / 2)+1] / CHUNK
    psd = 20 * np.log10(np.abs(spec))
        # Update at the end of the image - make it flows
    img_array = np.roll(img_array, -1, 0)
    img_array[-1:] = psd
    img.setImage(img_array, autoLevels=False)

# Set timer for running update function
timer = QtCore.QTimer()
timer.timeout.connect(update)

interval = RATE/CHUNK
timer.start(1000/interval)

if (sys.flags.interactive != 1) or not hasattr(QtCore, 'PYQT_VERSION'):
    app.exec_()
# Quit program if user click exit x 
app.quit()

# Close the stream from microphone
stream.close()
voice.terminate()


