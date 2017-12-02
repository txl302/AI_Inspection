function varargout = GUI_mobile(varargin)
% GUI_MOBILE MATLAB code for GUI_mobile.fig
%      GUI_MOBILE, by itself, creates a new GUI_MOBILE or raises the existing
%      singleton*.
%
%      H = GUI_MOBILE returns the handle to a new GUI_MOBILE or the handle to
%      the existing singleton*.
%
%      GUI_MOBILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MOBILE.M with the given input arguments.
%
%      GUI_MOBILE('Property','Value',...) creates a new GUI_MOBILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_mobile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_mobile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_mobile

% Last Modified by GUIDE v2.5 01-Dec-2017 17:21:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_mobile_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_mobile_OutputFcn, ...
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


% --- Executes just before GUI_mobile is made visible.
function GUI_mobile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_mobile (see VARARGIN)

% Choose default command line output for GUI_mobile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global u3
u3 = udp('127.0.0.1', 'RemotePort', 8013, 'LocalPort', 4013);

u3.timeout = 1000;

u3.OutputBufferSize=8192;
u3.InputBufferSize=8192;

global part_n
part_n = 0;

axes(handles.axes2);
imshow(imread('resource\logo.png'));
axes(handles.axes3);
imshow(imread('resource\ok.bmp'));

axes(handles.axes1);
imshow(imread('resource\black.bmp'));

% UIWAIT makes GUI_mobile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_mobile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Bn_connect.
function Bn_connect_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global u3
fopen(u3)

fwrite(u3, 10)

fd_back = fread(u3, 10)

if fd_back == 10

    set(handles.edit1,'string','Initialization done!');
    
end




% --- Executes on button press in Bn_disconnect.
function Bn_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global u3

fwrite(u3, 20)

fd_back = fread(u3, 20)

if fd_back == 20
    
    set(handles.edit1,'string','Disconnected!');
    
end

fclose(u3)


% --- Executes on button press in upload_ok.
function upload_ok_Callback(hObject, eventdata, handles)
% hObject    handle to upload_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fprintf('uploading ok sample...')


% --- Executes on button press in upload_ng.
function upload_ng_Callback(hObject, eventdata, handles)
% hObject    handle to upload_ng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fprintf('uploading ng sample...')


% --- Executes on button press in Bn_detection.
function Bn_detection_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

global n_parts

fwrite(u3, 12)

fd_back = fread(u3, 10)

DS = fread(u3, 10)

result = sum(DS)

current_img = dir('D:\Midea_AI_Inspection\raw\');

n = length(current_img);

img = imread(strcat(current_img(n).folder, '\', current_img(n).name));

axes(handles.axes1);
imshow(img);

if fd_back == 12
    
    if sum(DS) == n_parts
        
        set(handles.edit1,'string','The part is OK');
        
        axes(handles.axes3);
        imshow(imread('resource\ok.bmp'));
        
    else
        
        n_missing = find(DS > 1);
        
        set(handles.edit1,'string',strcat('Part', ' ', num2str(n_missing), ' missing!'));
        
        axes(handles.axes3);
        imshow(imread('resource\ng.bmp'));

    end
end



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bn_dataset_makeing.
function Bn_dataset_makeing_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_dataset_makeing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fwrite(u3, 17)

fd_back = fread(u3, 10)

if fd_back == 17
    
    set(handles.edit1,'string','Dataset created!');
    
end


% --- Executes on button press in Bn_training.
function Bn_training_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

set(handles.edit1,'string','Training......');

fwrite(u3, 13)

fd_back = fread(u3, 10)

if fd_back == 13
    
    set(handles.edit1,'string','Training done!');
    
end


% --- Executes on button press in Bn_setting_n_parts.
function Bn_setting_n_parts_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_setting_n_parts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

global n_parts

fwrite(u3, 102)

n_parts = str2double(get(handles.edit2,'String'))

fwrite(u3, n_parts)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_r_Callback(hObject, eventdata, handles)
% hObject    handle to channel_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel_r as text
%        str2double(get(hObject,'String')) returns contents of channel_r as a double


% --- Executes during object creation, after setting all properties.
function channel_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_g_Callback(hObject, eventdata, handles)
% hObject    handle to channel_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel_g as text
%        str2double(get(hObject,'String')) returns contents of channel_g as a double


% --- Executes during object creation, after setting all properties.
function channel_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_b_Callback(hObject, eventdata, handles)
% hObject    handle to channel_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel_b as text
%        str2double(get(hObject,'String')) returns contents of channel_b as a double


% --- Executes during object creation, after setting all properties.
function channel_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_d_Callback(hObject, eventdata, handles)
% hObject    handle to channel_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel_d as text
%        str2double(get(hObject,'String')) returns contents of channel_d as a double


% --- Executes during object creation, after setting all properties.
function channel_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bn_circling.
function Bn_circling_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_circling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3
global n_parts

global part_n

fwrite(u3, 101)

standard_img = dir('D:\Midea_AI_Inspection\standard\');

n = length(standard_img);

img = imread(strcat(standard_img(n).folder, '\', standard_img(n).name));

for i = 1:n_parts
    
    [BW, cn(:,i), rn(:,i)] = roipoly(img);
    
    fwrite(u3, cn(:,i), 'float')
    fwrite(u3, rn(:,i), 'float')

end

part_n = part_n + 1;

set(handles.part_n, 'enable', 'on')

set(handles.channel_r, 'enable', 'on')
set(handles.channel_g, 'enable', 'on')
set(handles.channel_b, 'enable', 'on')
set(handles.channel_d, 'enable', 'on')

set(handles.Bn_setting_weights, 'enable', 'on')

set(handles.part_n, 'string', num2str(part_n))


% --- Executes on button press in Bn_capture.
function Bn_capture_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3



fwrite(u3, 11)

fd_back = fread(u3, 100)

if fd_back == 111
    
    pause(1)
    
    a = dir('D:\Midea_AI_Inspection\raw');
    n = length(a)
    
    axes(handles.axes1);
    imshow(imread(strcat('D:\Midea_AI_Inspection\raw\', a(n).name)));
    
end









function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bn_setting_weights.
function Bn_setting_weights_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_setting_weights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%global u3

global n_parts

global part_n

%fwrite(u3, 103)

weights = [];

if (part_n < n_parts)

    channel_r = str2double(get(handles.channel_r,'String'));
    channel_g = str2double(get(handles.channel_g,'String'));
    channel_b = str2double(get(handles.channel_b,'String'));
    channel_d = str2double(get(handles.channel_d,'String'));
    
    weights = [channel_r, channel_g, channel_b, channel_d]
    
    %fwrite(u3, weights)
    
    part_n = part_n + 1
    
    set(handles.part_n,'string',num2str(part_n));
    
    set(handles.channel_r, 'string', num2str(1.0))
    set(handles.channel_g, 'string', num2str(1.0))
    set(handles.channel_b, 'string', num2str(1.0))
    set(handles.channel_d, 'string', num2str(1.0))
    
else
    
    part_n = 0
    
    set(handles.part_n, 'enable', 'off')
    
    set(handles.channel_r, 'enable', 'off')
    set(handles.channel_g, 'enable', 'off')
    set(handles.channel_b, 'enable', 'off')
    set(handles.channel_d, 'enable', 'off')
    
    set(handles.Bn_setting_weights, 'enable', 'off')
    
end


%n_parts = str2double(get(handles.edit2,'String'))

%fwrite(u3, n_parts)



function part_n_Callback(hObject, eventdata, handles)
% hObject    handle to part_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of part_n as text
%        str2double(get(hObject,'String')) returns contents of part_n as a double


% --- Executes during object creation, after setting all properties.
function part_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to part_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
