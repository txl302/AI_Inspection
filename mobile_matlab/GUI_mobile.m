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

% Last Modified by GUIDE v2.5 28-Nov-2017 18:51:53

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

axes(handles.axes1);
imshow(imread('resource\black.bmp'));
axes(handles.axes2);
imshow(imread('resource\logo.png'));
axes(handles.axes3);
imshow(imread('resource\ok.bmp'));

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Bn_detection.
function Bn_detection_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fwrite(u3, 12)

fd_back = fread(u3, 10)

DS = fread(u3, 10)

if fd_back == 12
    
    set(handles.edit1,'string',num2str(DS));
    
end

fclose(u3)


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

fclose(u3)


% --- Executes on button press in Bn_training.
function Bn_training_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fwrite(u3, 13)

fd_back = fread(u3, 10)

if fd_back == 13
    
    set(handles.edit1,'string','Training done!');
    
end

fclose(u3)


% --- Executes on button press in Bn_setting.
function Bn_setting_Callback(hObject, eventdata, handles)
% hObject    handle to Bn_setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global u3

fwrite(u3, 102)

n_parts = str2double(get(handles.Input_parts,'String'))

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
