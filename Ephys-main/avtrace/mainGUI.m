function varargout = mainGUI(varargin)
% mainGUI Graphical User Interface for Data Analysis
%      These functions are the auto-generated functions from GUIDE, with
%      which this file was created. Run it by calling the 
%      start_EphusAnalysis script from the console. You will then see a 
%      graphical interface, split in four parts: 
%      "Choose Datasets"
%           These controls allow you to select up to for cells (datasets)
%           and one epoch for each cell. Clicking on Show will activate
%           this selection as the current dataset.
%      "Controls"
%           These uicontrols allow you to set the path from which to load
%           .xsg files and to run the computations. You can also set the
%           output here and adjust the limits for calculating the slope.
%      "Files"
%           You can find all of the files available for the currently
%           active dataset (the one where you pressed show) in this
%           listbox. Press the remove button to remove a file from the
%           list; it will not be considered in the calculations. Press the
%           reset button to show all removed files for all datasets again.
%      "View Data"
%           The plot will always show the data you have currently selected
%           in the "Files" section. If you multiselect, multiple curves are
%           shown. Activate smooth traces for a moving average filter,
%           remove baseline to let all curves start at 0, and only consider
%           length together with the drop down menu to limit the considered
%           datasets to those where the number of datapoints is as
%           specified in the dropdown menu.
%      Written by Lennart Sobirey for Margo Anisimova
% Last Modified by GUIDE v2.5 23-Apr-2017 13:31:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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

% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)

% Choose default command line output for mainGUI
handles.output = hObject;

% Initialize fields
handles.eP = ephusParser();
handles.skipFile = containers.Map;
handles.maxlen = -1;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in showT1.
function showT1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to showT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetT1,'Value'),1};
epo = get(handles.epochT1,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetT1,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);

% Save changes
guidata(hObject,handles);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, ~)
if ~isfield(handles,'eP')
    error('No ephusParser can be found!');
end
% handles.plotFig = 
eP = handles.eP;
% If this program was started in a datafolder, we can already fill it
if size(eP.cells,1) > 1
    handles = fillDatasetsAndEpochs(handles);
    handles = fillListview(handles);
    handles = fillPlot(handles);
end
guidata(fig_handle,handles)

function handles = fillDatasetsAndEpochs(handles)
%% Fill all Datasets, and the Epochs for the Selected dataset (default
% should be 1, but better check). Then, show files for T1 and plot the
% first one. 
eP = handles.eP;
cells = eP.cells(:,1);
set(handles.datasetT1,'Value',1);
set(handles.datasetT1,'String',cells);
set(handles.epochT1,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT1,'String',tmp)
set(handles.datasetT2,'Value',1);
set(handles.datasetT2,'String',cells)
set(handles.epochT2,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT2,'String',tmp)
set(handles.datasetT3,'Value',1);
set(handles.datasetT3,'String',cells)
set(handles.epochT3,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT3,'String',tmp)
set(handles.datasetT4,'Value',1);
set(handles.datasetT4,'String',cells)
set(handles.epochT4,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT4,'String',tmp)
set(handles.datasetN1,'Value',1);
set(handles.datasetN1,'String',cells)
set(handles.epochN1,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN1,'String',tmp)
set(handles.datasetN2,'Value',1);
set(handles.datasetN2,'String',cells)
set(handles.epochN2,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN2,'String',tmp)
set(handles.datasetN3,'Value',1);
set(handles.datasetN3,'String',cells)
set(handles.epochN3,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN3,'String',tmp)
set(handles.datasetN4,'Value',1);
set(handles.datasetN4,'String',cells)
set(handles.epochN4,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN4,'String',tmp)
handles.currentCell = eP.cells{get(handles.datasetT1,'Value'),1};
epo = get(handles.epochT1,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetT1,'Value'),2}(epo);
end

function handles = fillListview(handles)
%% Fill the Listbox with the cells that fulfill all constraints like size
if ~isfield(handles, 'currentCell')
    return;
end
eP = handles.eP;
cC = handles.currentCell;
if strcmp(cC,'N/A')
    handles.dataCell = [];
    set(handles.fileListbox,'Value',1)
    set(handles.fileListbox,'String','Select a Dataset!');
    return;
end
handles = updateLengths(handles);
cE = handles.currentEpoch;
idxs = zeros(size(eP.fullFileList,1));
% fill the dataCell with all files that have the specified cell and epoch
for i=1:size(eP.fullFileList,1)
    if strcmp(eP.fullFileList{i,2}.cell,cC)
        if isnan(cE) || (eP.fullFileList{i,2}.epoch == cE)
            if ~handles.skipFile.isKey(eP.fullFileList{i,1})
                if get(handles.consider,'Value')
                    contents = cellstr(get(handles.length,'String'));
                    sel = str2double(contents{get(handles.length,'Value')}); 
                    handles.maxlen = sel;
                    if length(eP.fullFileList{i,2}.data.ephys.trace_1(:)) == sel
                        idxs(i) = 1;
                    end
                else
                    idxs(i) = 1;
                end
            end
        end
    end
end
handles.dataCell = eP.fullFileList(idxs==1,:);
set(handles.fileListbox,'Value',1)
set(handles.fileListbox,'String',handles.dataCell(:,1));

function handles = fillPlot(handles)
%% Plot the currently selected cells
if ~isfield(handles,'dataCell') || isempty(handles.dataCell)
    cla(handles.plotFig);
    return;
end
selected = get(handles.fileListbox,'Value');
data = handles.dataCell;
if isempty(data)
    return;
end

%Hold off so old stuff is overwritten
hold(handles.plotFig,'off')
for i=1:numel(selected)
    yData = data{selected(i),2}.data.ephys.trace_1;
    xData = 0.1:0.1:length(yData)/10;
    [xData,yData] = prepData(handles,xData,yData);
    handles = update_plot(handles,xData(:),yData(:));
end

function handles = update_plot(handles,Xdata,Ydata)
%% Plotting helper function
fg = handles.plotFig;
plot(fg,Xdata,Ydata);
hold(fg,'on');

function [xdata,ydata] = prepData(handles,xdata,ydata)
%% Smoothen the data and subtract the baseline, if so desired
smoothF = get(handles.smooth,'Value');
if smoothF
    ydata = smooth(ydata,5);
end
baseline = get(handles.baseline,'Value');
if baseline
    % Ephus does mean, we do median - 5ms by default - 50 datapoints.
    ydata = ydata-median(ydata(1:50));
end

% --- Executes on button press in smooth.
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the smoothing status is changed, we update the plot
handles = fillPlot(handles);
guidata(hObject,handles);


% --- Executes on button press in baseline.
function baseline_Callback(hObject, eventdata, handles)
% hObject    handle to baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the baseline status is changed, we update the plot
handles = fillPlot(handles);
guidata(hObject,handles);


% --- Executes on button press in consider.
function consider_Callback(hObject, eventdata, handles)
% hObject    handle to consider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to repopulate the listbox and the plot
handles = fillListview(handles);
handles = fillPlot(handles);
guidata(hObject,handles);

function handles = updateLengths(handles)
%% Helper function to update the available data lengths
eP = handles.eP;
sizes = [];
for i=1:size(eP.fullFileList(:,1))
    if ~any(abs(sizes-length(eP.fullFileList{i,2}.data.ephys.trace_1))<1)
        sizes = [sizes length(eP.fullFileList{i,2}.data.ephys.trace_1)]; %#ok<AGROW>
    end
end
if numel(sizes) > 0
    set(handles.length,'String',num2cell(sizes));
end


% --- Executes on selection change in length.
function length_Callback(hObject, eventdata, handles)
% hObject    handle to length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to repopulate the listbox and the plot as long
% as the length selection is active
if get(handles.consider,'Value')
    handles = fillListview(handles);
    handles = fillPlot(handles);
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function length_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fileListbox.
function fileListbox_Callback(hObject, eventdata, handles)
% hObject    handle to fileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to replot the new selection if there is
% something in the listbox to plot
handles = fillPlot(handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function fileListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetT1.
function datasetT1_Callback(hObject, eventdata, handles)
% hObject    handle to datasetT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to switch the available epochs
eP = handles.eP;
set(handles.epochT1,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT1,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetT1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochT1.
function epochT1_Callback(hObject, eventdata, handles)
% hObject    handle to epochT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochT1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetT2.
function datasetT2_Callback(hObject, eventdata, handles)
% hObject    handle to datasetT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to switch the available epochs
eP = handles.eP;
set(handles.epochT2,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT2,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT2,'String',tmp);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function datasetT2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in datasetT3.
function datasetT3_Callback(hObject, eventdata, handles)
% hObject    handle to datasetT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this changes, we have to switch the available epochs
eP = handles.eP;
set(handles.epochT3,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT3,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT3,'String',tmp);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function datasetT3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochT2.
function epochT2_Callback(hObject, eventdata, handles)
% hObject    handle to epochT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochT2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochT3.
function epochT3_Callback(hObject, eventdata, handles)
% hObject    handle to epochT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochT3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showT2.
function showT2_Callback(hObject, eventdata, handles)
% hObject    handle to showT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We update the current cell and epoch and repopulate listview and plot.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetT2,'Value'),1};
epo = get(handles.epochT2,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetT2,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in showT3.
function showT3_Callback(hObject, eventdata, handles)
% hObject    handle to showT3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We update the current cell and epoch and repopulate listview and plot.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetT3,'Value'),1};
epo = get(handles.epochT3,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetT3,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in showT4.
function showT4_Callback(hObject, eventdata, handles)
% hObject    handle to showT4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We update the current cell and epoch and repopulate listview and plot.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetT4,'Value'),1};
epo = get(handles.epochT4,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetT4,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on selection change in epochT4.
function epochT4_Callback(hObject, eventdata, handles)
% hObject    handle to epochT4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochT4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochT4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetT4.
function datasetT4_Callback(hObject, eventdata, handles)
% hObject    handle to datasetT4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the available epochs
eP = handles.eP;
set(handles.epochT4,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetT4,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochT4,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetT4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetT4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in setfolder.
function setfolder_Callback(hObject, eventdata, handles)
% hObject    handle to setfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear all removed datasets. Select a new folder. Load the data. If there
% is data found, repopulate everything. 
handles.skipFile = containers.Map;
cla(handles.plotFig);
global startpath;
if isdir(startpath)
    direc = uigetdir(startpath);
else
    direc = uigetdir();
end
if direc ~= 0
    handles.eP = ephusParser(direc);
    if size(handles.eP.cells,1) > 1
        handles = fillDatasetsAndEpochs(handles);
        handles = fillListview(handles);
        handles = fillPlot(handles);
    end
end
guidata(hObject,handles);


function calc_Callback(hObject, eventdata, handles)
% hObject    handle to calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Calculation function - does the legwork
% Is there data selected? We will take this to mean some data has been
% shown. Second check below. 
if strcmp('Listbox',get(handles.fileListbox,'String'))
    disp('Select some files before running the calculation!');
    return;
end

%% Initialization and preparation
counter = 0;
cellsC = {};
epochsC = {};
eP = handles.eP;
results = {};
names = {'T1','T2','T3','T4','N1','N2','N3','N4'};
% Get Cells and Epochs
cN = [get(handles.datasetT1,'Value'),...
    get(handles.datasetT2,'Value'),...
    get(handles.datasetT3,'Value'),...
    get(handles.datasetT4,'Value'),...
    get(handles.datasetN1,'Value'),...
    get(handles.datasetN2,'Value'),...
    get(handles.datasetN3,'Value'),...
    get(handles.datasetN4,'Value')];
eN = [get(handles.epochT1,'Value'),...
    get(handles.epochT2,'Value'),...
    get(handles.epochT3,'Value'),...
    get(handles.epochT4,'Value'),...
    get(handles.epochN1,'Value'),...
    get(handles.epochN2,'Value'),...
    get(handles.epochN3,'Value'),...
    get(handles.epochN4,'Value')];    
for i=1:numel(cN)
    counter = counter + 1;
    c = eP.cells{cN(i),1};
    cellsC{counter} = c; %#ok<AGROW>
    epochsC{counter} = -1; %#ok<AGROW>
    if ~strcmp(c,'N/A')
        ep = eP.cells{cN(i),2}(eN(i));
        if isnan(ep)
            disp('You cannot select all epochs for this mode!');
            return;
        end
        epochsC{counter} = ep; %#ok<AGROW>
    end
end
% Count the cells we found
countCells = sum([epochsC{:}] ~= -1);
countTrans = sum([epochsC{1:4}] ~= -1);
countNTrans = sum([epochsC{5:8}] ~= -1);
% Do we have cells selected?
if countCells == 0
    disp('Select some cells before running calculations!');
    return;
end

%% Calculate Peaks and Slopes for all selected datasets and output plots
% Commented out to make it into individual figures (all with % %)
% % fig = figure;
% % set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% % hold on;
% % figCount = 0;
%Go over all possible cells
for i = 1:numel(cN)
    % Skip if this cell did not have a cell selected.
    if epochsC{i} == -1
        continue;
    end
% %     figCount = figCount+1;
    % Initialize some stuff
    data = {};
    countData = 0;
    dataLen = Inf;
    % Go over all files 
    for j=1:size(eP.fullFileList,1)
        % Right cell and epoch?
        if (strcmp(eP.fullFileList{j,2}.cell,cellsC{i})) && (epochsC{i} == eP.fullFileList{j,2}.epoch)
            % Not removed?
            if ~handles.skipFile.isKey(eP.fullFileList{j,1})
                skip = true;
                % Are we only considering a certain length?
                if get(handles.consider,'Value')
                    contents = cellstr(get(handles.length,'String'));
                    sel = str2double(contents{get(handles.length,'Value')}); 
                    % Is this the right length?
                    if length(eP.fullFileList{j,2}.data.ephys.trace_1(:)) == sel
                        skip = false;
                    end
                else
                    skip = false;
                end
                % Add this dataset to the list
                if ~skip
                    countData = countData + 1;
                    data{countData} = eP.fullFileList{j,2}.data.ephys.trace_1(:); %#ok<AGROW>
                    dataLen = min(dataLen,numel(data{countData}));
                end
            end
        end
    end
    % Prepare Data - datalen is the shortest dataset. Possible longer ones
    % are cropped to fit. 
    xData = 0.1:0.1:dataLen/10;
    yData = zeros(numel(data),dataLen);
    for k = 1:numel(data)
        [xData,yData(k,:)] = prepData(handles,xData(:),data{k}(1:dataLen));
    end
% %     figure(fig);
% %     figHandle = subplot(ceil(sqrt(countCells)),ceil(sqrt(countCells)),figCount);
    figHandle = figure;
    % Actual computation happens in here
    outP = computeTraces(xData,yData,figHandle,...
        str2double(get(handles.slopeStart,'String')),...
        str2double(get(handles.slopeEnd,'String')),true);
    % Overwrite title of ugly figure
    title(['Cell ' cellsC{i} ', Epoch ' num2str(epochsC{i}) ' for checking']);
    figure(figHandle);
% %     title(['Cell ' cellsC{i} ', Epoch ' num2str(epochsC{i})]);
    title(['\fontsize{14} ' eP.fullFileList{1,2}.initials...
        num2str(eP.fullFileList{1,2}.experimentNumber) ': ' ...
        'Cell ' cellsC{i} ', Epoch ' num2str(epochsC{i}) ...
       '\newline \fontsize{10} \color{red} \it Generated: ' date]);
    legend('off')
    disp(['Cell ' cellsC{i} ', Epoch ' num2str(epochsC{i}) ': '...
        'Peak: ' num2str(outP.peak) ' - Time: ' num2str(outP.time) ' - Slope: ' ...
        num2str(outP.slope) ' - Baseline: ' num2str(outP.baseline)]);
    % Store results into results cell array. Will be saved later. 
    results{end+1} = struct(); %#ok<AGROW>
    results{end}.result=outP;
    results{end}.xData=xData;
    results{end}.yData=yData;
    results{end}.name = names{i};
    results{end}.cell = cellsC{i};
    results{end}.epoch = epochsC{i};
    results{end}.experiment = [eP.fullFileList{1,2}.initials num2str(eP.fullFileList{1,2}.experimentNumber)];
end
% % figure(fig);
% % suptitle(['\fontsize{14} ' 'Summary for ' eP.fullFileList{1,2}.initials num2str(eP.fullFileList{1,2}.experimentNumber) ' ', ...
% %    '\newline \fontsize{10} \color{red} \it Generated: ' date]);
% Save results into gui handles and workspace / hard drive if selected
handles.result = results;
resultsname = ['Results_' eP.fullFileList{1,2}.initials num2str(eP.fullFileList{1,2}.experimentNumber) '_' datestr(date,'yyyymmdd')];
if get(handles.saveToDir,'Value')
    save([eP.path '/' resultsname '.mat'],'results');
end
if get(handles.saveToMatlab,'Value')
    assignin('base',resultsname,results);
end

%% Create nice output
% Only if we have both transfected and nontransfected cells given
% Individual Figures for now
if countTrans && countNTrans
    % Which area shall be plotted?
    startIndex = 6000;
    endIndex = 6500;
% %     figNice = figure;
% %     set(gcf,'PaperType','A4', ...
% %          'paperOrientation', 'landscape', ...
% %          'paperunits','CENTIMETERS', ...
% %          'PaperPosition',[.63, .63, 28.41, 19.72]);
% %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% %     hold on;
% %     cFig = subplot(2,ceil(countTrans/2)+1,1);
    % Create Plot with all nontransfected curves in it
    figure;
    hold on;
    xDataNTrans = results{1}.xData(startIndex:endIndex);
    yDataNTrans = zeros(1,length(xDataNTrans));
    colors = {'black',[0.49,0.18,0.56],[0,0.5,0],'c'};
    for i=countTrans+1:countNTrans+countTrans
        yDataNTrans = yDataNTrans + mean(results{i}.yData(:,startIndex:endIndex),1);
        plot(xDataNTrans,mean(results{i}.yData(:,startIndex:endIndex),1),'Color',colors{i-countTrans},'LineWidth',2);
    end
    set(gca,'fontsize',14);
    title(['\fontsize{12}' results{1}.experiment ': Nontransfected Cells'...
        '\newline \fontsize{9} \color{red}'...
            '\it Generated: ' date]);
    xlabel('Time [ms]');
    ylabel('Current [pA]');
    yDataNTrans = yDataNTrans / countNTrans;
    
    % Plot the average nontransfected curve
% %     cFig = subplot(2,ceil(countTrans/2)+1,2);

    % Compute Trace for Nontransfected Averaged Data
    figHandle = figure;
    outP = computeTraces(xDataNTrans,yDataNTrans,figHandle,...
        str2double(get(handles.slopeStart,'String')),...
        str2double(get(handles.slopeEnd,'String')),true);
    peakNT = outP.peak;
    slopeNT = outP.slope;
    timeNT = outP.time;
    % Overwrite title of ugly figure
    title('Average Nontransfected Response for Checking');
    close(figHandle);
    
    % Make nice nontransfected plot
    figure;
    plot(xDataNTrans,yDataNTrans,'r','LineWidth',2);
    hold on;
    set(gca,'fontsize',14);
% %     title('Averaged Nontransfected Response');
    title(['\fontsize{12}' results{1}.experiment ': Averaged Nontransfected Response'...
        '\newline \fontsize{9} \color{red}'...
            '\it Generated: ' date]);
    xlabel('Time [ms]');
    ylabel('Current [pA]');
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    stringToDisplay = {['Peak: ' num2str(peakNT) 'pA'], ...
        ['Slope: ' num2str(slopeNT) 'pA/ms'], ...
        ['Time: ' num2str(timeNT) 'ms']};
    text(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+0.2*(yl(2)-yl(1)),stringToDisplay,'fontsize',10);
    legend('off');
    
    % Plot all transfected curves
    for i = 1:countTrans
% %         cFig = subplot(2,ceil(countTrans/2)+1,2+i);
        figure;
        hold on;
        plot(results{i}.xData(startIndex:endIndex),mean(results{i}.yData(:,startIndex:endIndex),1),'blue','LineWidth',2);
        plot(xDataNTrans,yDataNTrans,'red','LineWidth',2);
        set(gca,'fontsize',14);
        title(['\fontsize{12}' results{1}.experiment ': ' results{i}.cell ' Epoch ' ...
            num2str(results{i}.epoch) '\newline \fontsize{9} \color{red}'...
            '\it Generated: ' date]);
        xlabel('Time [ms]');
        ylabel('Current [pA]');
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        stringToDisplay = {'{\bfRatios:}', ...
            ['Peak: ' num2str(results{i}.result.peak/peakNT)],...
            ['Slope: ' num2str(results{i}.result.slope/slopeNT)],...
            ['Time: ' num2str(results{i}.result.time-timeNT) 'ms']};
        text(xl(1)+0.6*(xl(2)-xl(1)),yl(1)+0.2*(yl(2)-yl(1)),...
            stringToDisplay,'fontsize',10);
    end
    
    % Make main title
% %     figure(figNice);
% %     suptitle(['\fontsize{12} ' 'Results for ' eP.fullFileList{1,2}.initials num2str(eP.fullFileList{1,2}.experimentNumber) ' ', ...
% %    '\newline \fontsize{9} \color{red} \it Generated: ' date]);


end
% Save handles object
guidata(hObject,handles);

% --- Executes on selection change in datasetN1.
function datasetN1_Callback(hObject, eventdata, handles)
% hObject    handle to datasetN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the available epochs
eP = handles.eP;
set(handles.epochN1,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetN1,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN1,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetN1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetN2.
function datasetN2_Callback(hObject, eventdata, handles)
% hObject    handle to datasetN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the available epochs
eP = handles.eP;
set(handles.epochN2,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetN2,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN2,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetN3.
function datasetN3_Callback(hObject, eventdata, handles)
% hObject    handle to datasetN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the available epochs
eP = handles.eP;
set(handles.epochN3,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetN3,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN3,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetN3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in datasetN4.
function datasetN4_Callback(hObject, eventdata, handles)
% hObject    handle to datasetN4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the available epochs
eP = handles.eP;
set(handles.epochN4,'Value',1);
tmp = num2cell(eP.cells{get(handles.datasetN4,'Value'),2});
tmp{end+1} = 'All';
set(handles.epochN4,'String',tmp);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function datasetN4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetN4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochN1.
function epochN1_Callback(hObject, eventdata, handles)
% hObject    handle to epochN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochN1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochN2.
function epochN2_Callback(hObject, eventdata, handles)
% hObject    handle to epochN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in epochN3.
function epochN3_Callback(hObject, eventdata, handles)
% hObject    handle to epochN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochN3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in epochN4.
function epochN4_Callback(hObject, eventdata, handles)
% hObject    handle to epochN4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function epochN4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochN4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showN1.
function showN1_Callback(hObject, eventdata, handles)
% hObject    handle to showN1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the current cell and epoch and repopulate
% listbox and plot accordingly.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetN1,'Value'),1};
epo = get(handles.epochN1,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetN1,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in showN2.
function showN2_Callback(hObject, eventdata, handles)
% hObject    handle to showN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the current cell and epoch and repopulate
% listbox and plot accordingly.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetN2,'Value'),1};
epo = get(handles.epochN2,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetN2,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in showN3.
function showN3_Callback(hObject, eventdata, handles)
% hObject    handle to showN3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the current cell and epoch and repopulate
% listbox and plot accordingly.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetN3,'Value'),1};
epo = get(handles.epochN3,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetN3,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in showN4.
function showN4_Callback(hObject, eventdata, handles)
% hObject    handle to showN4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When this happens, we update the current cell and epoch and repopulate
% listbox and plot accordingly.
eP = handles.eP;
handles.currentCell = eP.cells{get(handles.datasetN4,'Value'),1};
epo = get(handles.epochN4,'Value');
if isnan(epo) || epo > numel(eP.cells{get(handles.datasetT1,'Value'),2})
    handles.currentEpoch = NaN;
else
    handles.currentEpoch = eP.cells{get(handles.datasetN4,'Value'),2}(epo);
end
handles = fillListview(handles);
handles = fillPlot(handles);

set(handles.showT1,'Value',0);
set(handles.showT2,'Value',0);
set(handles.showT3,'Value',0);
set(handles.showT4,'Value',0);
set(handles.showN1,'Value',0);
set(handles.showN2,'Value',0);
set(handles.showN3,'Value',0);
set(handles.showN4,'Value',0);
set(hObject,'Value',1);
% Save changes
guidata(hObject,handles);

% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add the names of the current selection to the excluded map as keys.
% Repopulate the listbox and plot so they vanish.
eP = handles.eP;
contents = cellstr(get(handles.fileListbox,'String'));
if isempty(contents) || strcmp(contents{1},'Listbox')
    return;
end
selection = get(handles.fileListbox,'Value');
for j=1:numel(selection)
    name = contents{selection(j)};
    for i=1:size(eP.fullFileList,1)
        if strcmp(eP.fullFileList{i,1},name)
            handles.skipFile(name) = 1;
            break;
        end
    end
end
handles = fillListview(handles);
%Reset current selected to the one above
set(handles.fileListbox,'Value',max(min(selection)-1,1))
handles = fillPlot(handles);
guidata(hObject,handles);


% --- Executes on button press in restore.
function restore_Callback(hObject, eventdata, handles)
% hObject    handle to restore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear the excluded map, and if there were things in the listbox,
% repopulate listbox and plot.
handles.skipFile = containers.Map;
if ~strcmp('Listbox',get(handles.fileListbox,'String'))
    handles = fillListview(handles);
    handles = fillPlot(handles);
end
guidata(hObject,handles);

% --- Executes on button press in saveToDir.
function saveToDir_Callback(hObject, eventdata, handles)
% hObject    handle to saveToDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in saveToMatlab.
function saveToMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to saveToMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function unitgroup_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to unitgroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function slopeStart_Callback(hObject, eventdata, handles)
% hObject    handle to slopeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function slopeStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slopeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slopeEnd_Callback(hObject, eventdata, handles)
% hObject    handle to slopeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function slopeEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slopeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on fileListbox and none of its controls.
function fileListbox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to fileListbox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'delete')
    remove_Callback(handles.remove,eventdata,handles);
end


% --- Executes on key press with focus on datasetT2 and none of its controls.
function datasetT2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to datasetT2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in comboPairing.
function comboPairing_Callback(hObject, eventdata, handles)
% hObject    handle to comboPairing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comboPairing contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comboPairing


% --- Executes during object creation, after setting all properties.
function comboPairing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comboPairing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonPairing.
function buttonPairing_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPairing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This is where all the interesting stuff happens for analysing the pairing
% data. 
if ~isfield(handles,'dataCell') || isempty(handles.dataCell)
    disp('No data currently shown! Select a dataset.');
    return;
end

% First, we check all the files currently in the ListBox and try to confirm
% that we have a bunch of files with the same length and exactly one that
% is significantly longer, which is the pairing one.
data = handles.dataCell; % YData: data{index,2}.data.ephys.trace_1
for i=1:size(data,1)
    k = handles.skipFile.keys;
    for j=1:numel(k)
        if data{i,1} == k{j}
            disp('Bad! Deleted Data was found')
        end
    end
%     disp(data{i,1})
end
lens = zeros(1,size(data,1));
pairingIdx = -1;
pairingLen = -1;
sizes= [];
for i=1:size(data,1)
    lens(i) = numel(data{i,2}.data.ephys.trace_1);
    if lens(i) > pairingLen
        pairingLen = lens(i);
        pairingIdx = i;
    end
    if isempty(find(sizes==lens(i),1))
        sizes(end+1) = lens(i); %#ok<AGROW>
    end
end
if numel(sizes)>2
    disp('More than two trace lengths found in the selection. Please clean up the data and try again.')
    return;
end
if numel(sizes) == 1
    disp('No pairing trace found! Please find one and try again.');
    return;
else
    if sum(lens==pairingLen)>1
        disp('Multiple pairing traces found. Please remove additional ones and try again.');
        return;
    end
end

% Now, for easier handling, we create cell arrays with x,y and time of all
% the datapoints respectively
ydata = cell(size(data,1),1);
xdata = cell(size(data,1),1);
triggerTime = cell(size(data,1),1);
for i=1:size(data,1)
    yData = data{i,2}.data.ephys.trace_1;
    xData = 0.1:0.1:length(yData)/10;
    [xdata{i},ydata{i}] = prepData(handles,xData,yData);
    triggerTime{i} = data{i,2}.header.ephys.ephys.triggerTime;
end

% Now we create a list of indices around which we want to average. We go to
% the left from the pairing index in steps of three, and to the right in
% steps of three. 
%idXL = pairingIdx-1:-3:1;
%idXL(end+1) = 0;
%idXP = numel(idXL)+1;
%idXR = pairingIdx:3:length(lens);
 averagingStep = 1;
 idXL = pairingIdx-1:-1*averagingStep:1;
 idXL(end+1) = 0;
 idXP = numel(idXL)+1;
 idXR = pairingIdx:averagingStep:length(lens);
if idXR(end) ~= length(lens)
    idXR(end+1) = length(lens);
end
idX = zeros(1,numel(idXL)+numel(idXR));
for i=1:numel(idXL)
    idX(i)=idXL(end-i+1);
end
for i=numel(idXL)+1:numel(idXL)+numel(idXR)
    idX(i) = idXR(i-numel(idXL));
end

% Now we average the curves together. For Indexes [... 11 14 17 ...], one
% curve would be 12:14, one would be 15:17 and so forth. For each averaged
% curve, the trigger time is also averaged and stored.
ydataAv = cell(numel(idX)-1,1);
xdataAv = cell(numel(idX)-1,1);
triggerTimeA = cell(numel(idX)-1,1);
for i=2:numel(idX)
    tm = triggerTime{idX(i)};
    tmp = ydata{idX(i)};
    count = 1;
    for j=idX(i)-1:-1:idX(i-1)+1
        tmp = tmp + ydata{j};
        tm = tm + triggerTime{j};
        count = count + 1;
    end
    ydataAv{i-1} = tmp./count;
    xdataAv{i-1} = xdata{idX(i)};
    triggerTimeA{i-1} = tm./count;
end

% Now we analyse all averaged curves that are not the pairing one. We
% suppress the output from the script, since it generates ~80 figures.
results = cell(numel(ydataAv),1);
disp('Starting Analysis...')
for i=1:numel(ydataAv)
    if numel(ydataAv{i}) == pairingLen
        idXP = i;
        results{i}.slope = NaN;
        continue;
    end
    results{i} = computeTraces(xdataAv{i}',ydataAv{i}',NaN, ...
        str2double(get(handles.slopeStart,'String')),...
        str2double(get(handles.slopeEnd,'String')),false);
end
% Structure: results.peak, .time, .slope, .baseline

% We calculate the averaged trace for all traces before pairing, and the
% averaged post-paired trace for exactly as many traces, counting from the
% end of the recording. Both of them are analysed. If no slope could be fit
% for one of the curves, it is not taken into account.
xBefore = xdataAv{1};
yBefore = zeros(size(xBefore))';
yBeforeFull = zeros(size(xBefore))';
xAfter = xdataAv{end};
yAfter = zeros(size(xAfter))';
counterB = 0;
counterA = 0;
counterBF = 0;
startBefore = -5;
endBefore = 0;
startAfter = 20;
endAfter = 25;
x = zeros(1,numel(results)-1);
y = zeros(1,numel(results)-1);
baselineSimple = 0;
counterBS = 0;
afterSimple = 0;
counterAS = 0;
for i=1:numel(results)
    if isnan(results{i}.slope)
        continue;
    end
%     if i == idXP
%         continue;
%     end
    tDT = sum(triggerTimeA{i}.*[0 0 0 60 1 1/60] - ...
        triggerTimeA{idXP}.*[0 0 0 60 1 1/60]);
    if tDT < endBefore
        yBeforeFull = yBeforeFull + ydataAv{i};
        counterBF = counterBF + 1;
        if tDT > startBefore
            yBefore = yBefore + ydataAv{i};
            counterB = counterB + 1;
            baselineSimple = baselineSimple + results{i}.slope;
            counterBS = counterBS + 1;
        end
    else
        if tDT > startAfter
            if tDT < endAfter
                yAfter = yAfter + ydataAv{i};
                counterA = counterA + 1;
                afterSimple = afterSimple + results{i}.slope;
                counterAS = counterAS + 1;
            end
        end
    end
    x(i) = tDT;
    y(i) = results{i}.slope;
    if i == idXP
        y(i) = NaN;
    end
end

baselineSimple = baselineSimple ./ counterBS;
afterSimple = afterSimple ./ counterAS;

yBefore = yBefore ./ counterB;
beforeRes = computeTraces(xBefore(:),yBefore(:)',NaN, ...
    str2double(get(handles.slopeStart,'String')),...
    str2double(get(handles.slopeEnd,'String')),false);
baseline = beforeRes.slope;

% yBeforeFull = yBeforeFull / counterBF;
% beforeResFull = computeTraces(xBefore(:),yBeforeFull(:)',NaN, ...
%     str2double(get(handles.slopeStart,'String')),...
%     str2double(get(handles.slopeEnd,'String')),false);
% baselineFull = beforeResFull.slope;

yAfter = yAfter ./ counterA;
afterRes = computeTraces(xAfter(:),yAfter(:)',NaN, ...
    str2double(get(handles.slopeStart,'String')),...
    str2double(get(handles.slopeEnd,'String')),false);

% Now we prepare the x and y data for plotting. The X Axis for each
% datapoint is the time since the very first one in the dataset, zeroed
% around the pairing trace. The Y Axis is the Slope, normalized by the
% slope of the averaged traces before pairing and multiplied by 100 to make
% it to percent.
% Currently not done:
%   Remove Slopes > 0

% We remove all datapoints for the main plot which are outside the -5:30 minute range, making sure idXP stays in place
% tmpVal = x(idXP);
y=y(((x>=startBefore) .* (x<=endAfter))==1);
x=x(((x>=startBefore) .* (x<=endAfter))==1);
% idXP = find(x==tmpVal,1,'first');
y = y .* (-1)%./ baselineSimple .* 100;

% We create the main figure, where we plot the relative slope versus time.
mainFig = figure;
hold on
set(mainFig,'Units','centimeters')
set(mainFig,'Position',[5 10 18 6]);
plot(x(x<0),y(x<0),'Marker','o','LineStyle','none','MarkerSize',5,'Color',[.8 0 0],'MarkerEdgeColor',[.8 0 0], 'MarkerFaceColor',[.8 0 0]);
plot(x(x>0),y(x>0),'Marker','o','LineStyle','none','MarkerSize',5,'Color','blue','MarkerEdgeColor','blue', 'MarkerFaceColor','blue');
xlabel('Time [min]');
%ylabel('Relative Slope [%]');
ylabel('Slope [-pA/ms]');
ax = gca;
set(ax,'Box','on')
set(ax,'YLim',get(ax,'YLim').*[0 1])
line([0 0],get(ax,'YLim'),'LineStyle','--','LineWidth',2,'Color',[.7 .7 .7]);
line(get(ax,'XLim'),[100 100],'LineStyle','--','LineWidth',2,'Color',[.7 .7 .7]);
legend('off');

% We create a reasonable title string that contains the identifier, date of
% recording, date of analysis, transfected or not, and the users choice of
% causal / anticausal / control.
index = get(handles.comboPairing,'Value');
eP = handles.eP;
T = get(handles.showT1,'Value') || get(handles.showT2,'Value') || get(handles.showT3,'Value') || get(handles.showT4,'Value');
cutStr = num2str(eP.fullFileList{1,2}.experimentNumber/10000,'%0.4f');
cutStr = cutStr(3:end);
try
    titleStr{1} = '\fontsize{14}';
    titleStr{1} = [titleStr{1} eP.fullFileList{1,2}.initials];
    titleStr{1} = [titleStr{1} cutStr];
    titleStr{1} = [titleStr{1} handles.currentCell];
    titleStr{1} = [titleStr{1} ' (Taken '];
    titleStr{1} = [titleStr{1} datestr(triggerTimeA{1},1)];
    titleStr{1} = [titleStr{1} ', Analyzed '];
    titleStr{1} = [titleStr{1} date];
    titleStr{1} = [titleStr{1} ')'];
catch
    disp(['Error when putting together Title String. Current String: ' titleStr{1}]);
end
if T
    tmp = 'T: ';
else
    tmp = 'NT: ';
end
if index == 1
    titleStr{2} = [tmp 'Causal @ 5Hz for 1min'];
else
    if index == 2
        titleStr{2} = [tmp 'Anticausal @ 5Hz for 1min'];
    else
       titleStr{2} = [tmp 'Control'];
    end
end
title(ax,titleStr)

% Finally, we create the additional figure to show the comparison before
% the averaged traces before the pairing and in the end of the recording
% that we calculated earlier. Only the region of interest around 625 ms is
% shown. The ratios of peak and slope and the time difference are written
% onto the canvas.
secFig = figure;
hold on
set(secFig,'Units','centimeters')
set(secFig,'Position',[25 10 15 10]);
ax = gca;
plot(xBefore(6000:6500),yBefore(6000:6500),'Color',[.8 0 0])
plot(xAfter(6000:6500),yAfter(6000:6500),'blue')
xlabel('Time [ms]');
ylabel('Current [pA]');
set(ax,'Box','on')
legend('off');
xl = get(ax,'xlim');
yl = get(ax,'ylim');
stringToDisplay = {'{\bfRatios for Averaged Curves:}', ...
    ['Peak (Value): ' num2str(afterRes.peak/beforeRes.peak,3) ' ( ' ...
        num2str(afterRes.peak,3) ' / '  num2str(beforeRes.peak,3) ' )'],...
    ['Slope (Value): ' num2str(afterRes.slope/beforeRes.slope,3) ' (' ...
        num2str(afterRes.slope,3) ' / '  num2str(beforeRes.slope,3) ' )'],...
    ['Time: ' num2str(afterRes.time-beforeRes.time) 'ms'],...
    '{\bfSingle Curve Slope (Averaged):}', ... 
    ['Slope (Value): ' num2str(afterSimple/baselineSimple,3) ' ( ' ...
        num2str(afterSimple,3) ' / '  num2str(baselineSimple,3) ' )'],...
    };
text(xl(1)+0.5*(xl(2)-xl(1)),yl(1)+0.2*(yl(2)-yl(1)),...
    stringToDisplay,'fontsize',8);
title(ax,titleStr)
legend('Before Pairing','After Pairing','Location','East')

% Lastly, we create a struct containing x and y of the relative slope vs
% time plot and save it to the workspace and or the file system, if the
% user selected those options.
resultsObj = struct();
resultsObj.xAxisBefore = x(x<0);
resultsObj.yAxisBefore = y(x<0);
resultsObj.xAxisAfter = x(x>0);
resultsObj.yAxisAfter = y(x>0);
resultsObj.xFull = x;
resultsObj.yFull = y;
resultsObj.Title = titleStr;

resultsname = ['Results_' eP.fullFileList{1,2}.initials cutStr '_' datestr(date,'yyyymmdd')];
if get(handles.saveToDir,'Value')
    save([eP.path '/' resultsname '.mat'],'resultsObj');
end
if get(handles.saveToMatlab,'Value')
    assignin('base',resultsname,resultsObj);
end
