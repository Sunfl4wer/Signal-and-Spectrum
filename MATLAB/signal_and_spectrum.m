function varargout = signal_and_spectrum(varargin)
% SIGNAL_AND_SPECTRUM MATLAB code for signal_and_spectrum.fig
%      SIGNAL_AND_SPECTRUM, by itself, creates a new SIGNAL_AND_SPECTRUM or raises the existing
%      singleton*.
%
%      H = SIGNAL_AND_SPECTRUM returns the handle to a new SIGNAL_AND_SPECTRUM or the handle to
%      the existing singleton*.
%
%      SIGNAL_AND_SPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_AND_SPECTRUM.M with the given input arguments.
%
%      SIGNAL_AND_SPECTRUM('Property','Value',...) creates a new SIGNAL_AND_SPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signal_and_spectrum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signal_and_spectrum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help signal_and_spectrum

% Last Modified by GUIDE v2.5 03-Sep-2019 18:29:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signal_and_spectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @signal_and_spectrum_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before signal_and_spectrum is made visible.
function signal_and_spectrum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signal_and_spectrum (see VARARGIN)

% Choose default command line output for signal_and_spectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes signal_and_spectrum wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = signal_and_spectrum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global f;
    global audio;
    global freq_db;
    global freq_abs;
    global freq;
    global mark;
    global fs;
    global spf;
    global micReader;
    fs = 44100;
    spf = 1024;
    micReader = audioDeviceReader(fs,spf);
    f = (0:(spf-1))*fs/spf;
    mark = 1;
    audio = zeros(spf,1);
    freq = zeros(spf,1);
    freq_abs = zeros(spf,1);
    freq_db = zeros(spf,1);
        while(mark)
            audio = micReader();
                axes(handles.axes1);
                plot((0:1/fs:(spf-1)/fs),audio);
                    ylim('manual');
                    ylim([-1.5 1.5]);  
                    ylabel('amplitude');
                    drawnow;         
                
                
                freq = fft(audio);
                freq_abs = abs(freq);
                freq_db = 20*log(freq_abs);
                
                axes(handles.axes2);
                plot(f(1:(spf/2)),freq_db(1:(spf/2)));
                    xlim('manual');
                    xlim([0 (spf/2-1)*fs/spf]);
                    ylim('manual');
                    ylim([-150 150]);
                    ylabel('dB');
                    drawnow;
        end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global audio;
    global freq_db;
    global mark;
    global f;
    global spf;
    global fs;
    mark = 0;
    axes(handles.axes1);
    plot((0:1/fs:(spf-1)/fs),audio);
        ylim('manual');
        ylim([-1.5 1.5]);
        ylabel('amplitude');
        
        
    axes(handles.axes2);
    plot(f(1:(spf/2)),freq_db(1:(spf/2)));
        xlim('manual');
        xlim([0 (spf/2-1)*fs/spf]);
        ylim('manual');
        ylim([-150 150]);
        ylabel('dB');
