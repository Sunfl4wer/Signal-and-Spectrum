function varargout = spectrogram_app(varargin)
% SPECTROGRAM_APP MATLAB code for spectrogram_app.fig
%      SPECTROGRAM_APP, by itself, creates a new SPECTROGRAM_APP or raises the existing
%      singleton*.
%
%      H = SPECTROGRAM_APP returns the handle to a new SPECTROGRAM_APP or the handle to
%      the existing singleton*.
%
%      SPECTROGRAM_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTROGRAM_APP.M with the given input arguments.
%
%      SPECTROGRAM_APP('Property','Value',...) creates a new SPECTROGRAM_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrogram_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrogram_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrogram_app

% Last Modified by GUIDE v2.5 03-Sep-2019 18:59:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrogram_app_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrogram_app_OutputFcn, ...
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


% --- Executes just before spectrogram_app is made visible.
function spectrogram_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrogram_app (see VARARGIN)

% Choose default command line output for spectrogram_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spectrogram_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spectrogram_app_OutputFcn(hObject, eventdata, handles) 
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
    global sample_rate;
    global sample_per_frame;
    global frame_stack;
    global f;
    global X;
    global Y;
    global stack;
    global freq;
    global freq_abs;
    global freq_db;
    global mark;
    global i;
    global audio;
    global micReader;
    mark = 1;
    sample_rate = 44100;
    sample_per_frame = 1024;
    micReader = audioDeviceReader(sample_rate,sample_per_frame);
    frame_stack = 20;
    i = 1;
    f = (0:(sample_per_frame-1))*sample_rate/sample_per_frame;
    stack = zeros(frame_stack,(sample_per_frame/2));
    X = zeros(frame_stack,(sample_per_frame/2));
    Y = zeros(frame_stack,(sample_per_frame/2));
    for m = 1:frame_stack
        for n = 1:(sample_per_frame/2)
            X(m,n) = f(n);
            Y(m,n) = m;
        end
    end
    axes(handles.axes1);
    % Process frame-by-frame in a loop
    while(mark)
        audio = micReader();
         freq = fft(audio);
         freq_abs = abs(freq);
         freq_db = 20*log(freq_abs);
            if(i <= frame_stack)
                for j = 1:(sample_per_frame/2)
                    stack(i,j) = freq_db(j);
                end
                i = i + 1;
            else
                for t = 1:(frame_stack - 1)
                    for k = 1:(sample_per_frame/2)
                        stack(t,k) = stack(t+1,k);
                    end
                end
                for k = 1:(sample_per_frame/2)
                    stack(frame_stack,k) = freq_db(k);
                end
            end
        surf(Y,X,stack);
        zlim([-150 150])
        colorbar;
        %grid off;
        shading interp;
        drawnow;
    end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global X;
    global Y;
    global stack;
    global mark;
    mark = 0;
    axes(handles.axes1);
    surf(Y,X,stack);
    zlim([-150 150])
    colorbar;
    %grid off;
    shading interp;
    drawnow;
