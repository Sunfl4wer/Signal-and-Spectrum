% Ch??ng trình MATLAB v? tín hi?u và ph? trong th?i gian th?c
% Gi?i thu?t ???c trình bày ? dòng 80 c?a script.
% Sinh viên th?c hi?n: Nguy?n Thái S?n - 1512847
%                      Nguy?n Minh Hùng - 1511355
% H? Chí Minh - 09/2019

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


%% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Khai báo các bi?n toàn c?c các bi?n này có th? ???c dùng trong nhi?u function khác nhau.
    global f;
    global audio;
    global freq_db;
    global freq_abs;
    global freq;
    global mark;
    global fs;
    global spf;
    global micReader;
    global audio_windowed;
    global window;
    global audio_first_part;
    global audio_second_part;
  %% Thi?t ??t các giá tr? ??u
    fs = 44100; % t?n s? l?y m?u
    spf = 1024; % s? m?u m?t m?ng
    window = 30; % s? m?u s? d?ng l?i c?a c?a s? tr??t
    micReader = audioDeviceReader(fs,spf); % khai báo hàm l?y tín hi?u t? mic máy tính
    f = (0:(spf-1))*fs/spf; % t?o d?i t?n s?
    mark = 1; % bi?n xác nh?n ch?y vòng l?p khi b?m nút
    % t?o các m?ng c?n thi?t
    audio = zeros(spf,1);
    audio_windowed = zeros(spf,1);
    audio_first_part = zeros(window,1);
    audio_second_part = zeros(spf-window,1);
    freq = zeros(spf,1);
    freq_abs = zeros(spf,1);
    freq_db = zeros(spf,1);
    k = 1;
    %% Vòng l?p vô h?n th?c hi?n gi?i thu?t
        while(mark)
            audio = micReader(); % l?y d? li?u thu ???c t? mic gán vào m?ng 'audio'
            %----------------------------------------------------------------------
            % Gi?i thu?t dùng ?? t?o c?a s? tr??t
            % Bi?n d? li?u 'audio_windowed' s? g?m n+m giá tr? v?i n là s? các d? li?u l?y
            % t? m?ng 'audio' th? i-1 và m là s? các d? li?u l?y t? m?ng
            % 'audio' th? i.
            % n = window và m = sample_per_frame-window
            % M?ng 'audio_first_part' s? gi? ph?n ??u c?a d? li?u m?i
            % M?ng 'audio_second_part' s? gi?a ph?n sau c?a d? li?u m?i
            % audio_windowed = [audio_first_part,audio_second_part]
            if(k == 1)
                audio_windowed = audio;
                for i = 1:window
                    audio_first_part(i) = audio(spf-window+i);
                end
                k = 2;
            else
                for j = 1:spf-window
                    audio_second_part(j) = audio(j);
                end
                for l = 1:window
                    audio_windowed(l) = audio_first_part(l);
                    audio_first_part(l) = audio(spf-window+l);
                end
                for t = 1:spf-window
                    audio_windowed(t+window) = audio_second_part(t);
                end
            end
            %--------------------------------------------------------------
            % V? d?ng c?a tín hi?u
            % Do tín hi?u g?m 1024 m?u v?i t?c ?? l?y m?u là 44100Hz nên
            % th?i gian hi?n th? lên khung hình s? t? 0 ??n 1024/44100s
                axes(handles.axes1);
                plot((0:1/fs:(spf-1)/fs),audio);
                    ylim('manual');
                    ylim([-1.5 1.5]);  
                    ylabel('amplitude');
                    drawnow;         
                
                %----------------------------------------------------------
                % Tính fft c?a tín hi?u
                % Do tín hi?u là k?t qu? c?a c?a s? tr??t nên khi tính fft
                % c?a tín hi?u này thì t??ng ?ng v?i vi?c dùng hàm stft.
                freq = fft(audio);
                freq_abs = abs(freq);
                freq_db = 20*log10(freq_abs);
                
                %----------------------------------------------------------
                % V? d?ng c?a phân tích fourier c?a tín hi?u trên mi?n t?n
                % s?.
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
    global audio_windowed;
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
