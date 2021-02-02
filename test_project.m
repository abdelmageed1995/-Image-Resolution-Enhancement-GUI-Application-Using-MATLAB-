function varargout = test_project(varargin)
% TEST_PROJECT MATLAB code for test_project.fig
%      TEST_PROJECT, by itself, creates a new TEST_PROJECT or raises the existing
%      singleton*.
%
%      H = TEST_PROJECT returns the handle to a new TEST_PROJECT or the handle to
%      the existing singleton*.
%
%      TEST_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_PROJECT.M with the given input arguments.
%
%      TEST_PROJECT('Property','Value',...) creates a new TEST_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_project

% Last Modified by GUIDE v2.5 04-Mar-2018 08:05:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_project_OpeningFcn, ...
                   'gui_OutputFcn',  @test_project_OutputFcn, ...
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


% --- Executes just before test_project is made visible.
function test_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_project (see VARARGIN)

global imageNames;
imageNames = 0;
global imagePath;
imagePath = 0;

% Choose default command line output for test_project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% Invoke the global VideoReader 
global imageNames;
global imagePath;
global videoPath;

input = inputdlg('1 for video, 0 for folder:');
n = [input{:}];
if ~isnan(n) && ~isempty(n)
    n = str2double(n);
    if n == 1
        [name, videoPath] = uigetfile({'*.mp4'; '*.avi'; '*.mkv'});
        [imageNames, imagePath] = ReadImages(name, videoPath);
        imshow(imread(fullfile(imagePath, imageNames{1})), 'Parent', handles.axes1);
        set(handles.slider1, 'Min', 1, 'Max', length(imageNames), 'Value', 1);
        set(handles.slider1, 'SliderStep', [1/(length(imageNames)-1) , 10/(length(imageNames)-1) ]);
        text = sprintf('Frame %d of %d', 1, length(imageNames));
        set(handles.text2, 'String', text);
    elseif n == 0
        path = uigetdir();
        [imageNames, imagePath] = ReadImages(0, path);
        imshow(imread(fullfile(imagePath, imageNames{1})), 'Parent', handles.axes1);
        set(handles.slider1, 'Min', 1, 'Max', length(imageNames), 'Value', 1);
        set(handles.slider1, 'SliderStep', [1/(length(imageNames)-1) , 10/(length(imageNames)-1) ]);
        text = sprintf('Frame %d of %d', 1, length(imageNames));
        set(handles.text2, 'String', text);
    else
        errordlg('Not a valid option','Type Error');
    end
else
    errordlg('Enter a numeric value','Type Error');
end

% --- Executes on button press in removeButton.
function removeButton_Callback(hObject, eventdata, handles)
% Invoke the global VideoReader 
global imageNames;
global videoPath;
global imagePath;
% Handle the empty VideoReader case(inputVideo)
[imageNames, imagePath] = RemoveFrames(videoPath);
if ~isequal(imageNames,0)
    set(handles.slider1, 'Min', 1, 'Max', length(imageNames), 'Value', 1);
    set(handles.slider1, 'SliderStep', [1/(length(imageNames)-1) , 10/(length(imageNames)-1) ]);
    imshow(imread(fullfile(imagePath, imageNames{1})), 'Parent', handles.axes1);
    text = sprintf('Frame %d of %d', 1, length(imageNames));
    set(handles.text2, 'String', text);
else
    msgbox('There is no repeated frames','Error','error');    
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% Invoke the global VideoReader 
global imageNames;
global imagePath;

% Handle the empty VideoReader case(inputVideo)
if ~isequal(imageNames, 0)
    value = round(get(hObject,'Value'));
    % Show the 1st frame in the canvas and update the text
    imshow(fullfile(imagePath,imageNames{value}),'Parent',handles.axes1);
    text = sprintf('Frame %d of %d', value, length(imageNames));
    set(handles.text2, 'String', text);
else
    % Create error message dialog box
    msgbox('There is no vedio file','Error','error');    
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
global imageNames;
global imagePath;

str = get(hObject, 'String');
val = get(hObject, 'Value');
sliderVal = round(get(handles.slider1, 'Value'));

switch str{val}
    case 'Median'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imread(fullname);
        input = inputdlg('Filter size:');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            img = medfilt2(img, [n n]);
            imshow(img,'Parent',handles.axes2);
        else
            errordlg('Enter a numeric value','Type Error');
        end
                
    case 'Average'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imread(fullname);
        input = inputdlg('Filter size:');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            average_filter = fspecial('average', [n n]);
            img = imfilter(img, average_filter, 'replicate');
            imshow(img,'Parent',handles.axes2);
        else
            errordlg('Enter a numeric value','Type Error');
        end
                
    case 'Gaussian'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imread(fullname);
        input = inputdlg('Sigma - 0.5 for default - :');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            img = imgaussfilt(img, n);
            imshow(img,'Parent',handles.axes2);
        else
            errordlg('Enter a numeric value','Type Error');
        end
    case 'Laplacian'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imread(fullname);
        % Show that gui in process by creating the mouse loading circle
        laplacian_filter = fspecial('laplacian');
        img = imfilter(img, laplacian_filter);
        imshow(img,'Parent',handles.axes2);
        
    case 'Unsharpen'
        input = inputdlg({'Radius (1 default) :',...
            'Amount (0.8 default) :', 'Threshold (0 default) :'});
        n = str2double(input);
        if ~isnan(n)
            fullname = fullfile(imagePath,imageNames{sliderVal});
            img = imread(fullname);
            % Show that gui in process by creating the mouse loading circle
            img = imsharpen(img,'Radius',n(1),'Amount',n(2),'Threshold', n(3));
            imshow(img,'Parent',handles.axes2);
        else
            errordlg('Enter a numeric value','Type Error');
        end
        
     case 'Negative'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imcomplement(imread(fullname));
        imshow(img,'Parent',handles.axes2);
        
    case 'resize'
        fullname = fullfile(imagePath,imageNames{sliderVal});
        img = imread(fullname);
        new=imresize(img,[184 138]);
        imshow(new,'Parent',handles.axes2);
end

% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in apply2allButton.
function apply2allButton_Callback(hObject, eventdata, handles)
global imagePath;
global videoPath;

str = get(handles.popupmenu, 'String');
val = get(handles.popupmenu, 'Value');

switch str{val}
    case 'Median'
        input = inputdlg('Filter size:');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            MedianFilter(videoPath, imagePath, n);
        else
            errordlg('Enter a numeric value','Type Error');
        end
                
    case 'Average'
        input = inputdlg('Filter size:');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            AverageFilter(videoPath, imagePath, n);
        else
            errordlg('Enter a numeric value','Type Error');
        end
                
    case 'Gaussian'
        input = inputdlg('Sigma - 0.5 for default - :');
        n = str2double(input{:});
        if ~isnan(n)
            % Show that gui in process by creating the mouse loading circle
            GaussianFilter(videoPath, imagePath, n);
        else
            errordlg('Enter a numeric value','Type Error');
        end  
        
    case 'Laplacian'
        LaplacianFilter(videoPath, imagePath);
        
    case 'Unsharpen'
        input = inputdlg({'Radius (1 default) :',...
            'Amount (0.8 default) :', 'Threshold (0 default) :'});
        n = str2double(input);
        if ~isnan(n)
            UnsharpenFilter(videoPath, imagePath, n(1), n(2), n(3));
        else
            errordlg('Enter a numeric value','Type Error');            
        end
        
    case 'Negative'  
        NegativeFilter(videoPath, imagePath);  
    case 'resize'
        resize(videoPath ,imagePath);
end
   
