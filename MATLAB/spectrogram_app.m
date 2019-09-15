% Ch??ng tr�nh MATLAB v? t�n hi?u v� ph? trong th?i gian th?c
% Gi?i thu?t ???c tr�nh b�y ? d�ng 80 c?a script.
% Sinh vi�n th?c hi?n: Nguy?n Th�i S?n - 1512847
%                      Nguy?n Minh H�ng - 1511355
% H? Ch� Minh - 09/2019

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
%% Khai b�o c�c bi?n to�n c?c c�c bi?n n�y c� th? ???c d�ng trong nhi?u function kh�c nhau.
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
    global audio_windowed;
    global window;
    global audio_first_part;
    global audio_second_part;
    %% Thi?t ??t c�c gi� tr? ??u
    audio_windowed = zeros(sample_per_frame,1);
    audio_first_part = zeros(window,1);
    audio_second_part = zeros(sample_per_frame-window,1);
    mark = 1;
    sample_rate = 44100;
    sample_per_frame = 1024;
    window = 30;
    micReader = audioDeviceReader(sample_rate,sample_per_frame);
    frame_stack = 50;
    i = 1;
    f = (0:(sample_per_frame-1))*sample_rate/sample_per_frame;
    stack = zeros(frame_stack,(sample_per_frame/2));
    X = zeros(frame_stack,(sample_per_frame/2));
    Y = zeros(frame_stack,(sample_per_frame/2));
    for m = 1:frame_stack
        for n = 1:(sample_per_frame/2)
            X(m,n) = f(n);
            Y(m,n) = m*(sample_per_frame - window)/44100;
        end
    end
    axes(handles.axes1);
    % Process frame-by-frame in a loop
    k = 1;
    %% V�ng l?p v� h?n th?c hi?n gi?i thu?t
    while(mark)
        audio = micReader();% l?y d? li?u thu ???c t? mic g�n v�o m?ng 'audio'
            %----------------------------------------------------------------------
            % Gi?i thu?t d�ng ?? t?o c?a s? tr??t
            % Bi?n d? li?u 'audio_windowed' s? g?m n+m gi� tr? v?i n l� s? c�c d? li?u l?y
            % t? m?ng 'audio' th? i-1 v� m l� s? c�c d? li?u l?y t? m?ng
            % 'audio' th? i.
            % n = window v� m = sample_per_frame-window
            % M?ng 'audio_first_part' s? gi? ph?n ??u c?a d? li?u m?i
            % M?ng 'audio_second_part' s? gi?a ph?n sau c?a d? li?u m?i
            % audio_windowed = [audio_first_part,audio_second_part]
            if(k == 1)
                audio_windowed = audio;
                for r = 1:window
                    audio_first_part(r) = audio(sample_per_frame-window+r);
                end
                k = 2;
            else
                for j = 1:sample_per_frame-window
                    audio_second_part(j) = audio(j);
                end
                for l = 1:window
                    audio_windowed(l) = audio_first_part(l);
                    audio_first_part(l) = audio(sample_per_frame-window+l);
                end
                for t = 1:sample_per_frame-window
                    audio_windowed(t+window) = audio_second_part(t);
                end
            end
         %-----------------------------------------------------------------
         % V? d?ng c?a t�n hi?u
         % T�nh fft c?a t�n hi?u
         % Do t�n hi?u l� k?t qu? c?a c?a s? tr??t n�n khi t�nh fft
         % c?a t�n hi?u n�y th� t??ng ?ng v?i vi?c d�ng h�m stft.
         freq = fft(audio_windowed);
         freq_abs = abs(freq);
         freq_db = 20*log10(freq_abs);
         
         %-----------------------------------------------------------------
         % Ma tr?n frame_stack l� ma tr?n nxm v?i n = stack v� 
         % m = sample_per frame.
         % V?i m?i l?n t�nh fft c?a m?ng gi� tr? thu ???c th� k?t qu? s?
         % ???c ??y v�o stack. Sau khi stack ??y th� frame ??u s? b? lo?i
         % b?, c�c frame c�n l?i s? d?ch l�i 1 v? tr� v� frame cu?i s? ???c
         % c?p nh?t l?i gi� tr? m?i.
         % frame_stack s? ???c d�ng ?? v? ?? th? 3d theo th?i gian c?a ph?
         % c?a t�n hi?u. 
         % Th?i gian gi?a m?i frame s? b?ng (sample_per_frame-window)/44100
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
            
        %------------------------------------------------------------------
        % D�ng h�m surf ?? v? t�n hi?u
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
