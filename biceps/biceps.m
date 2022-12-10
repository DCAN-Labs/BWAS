function varargout = biceps(varargin)
% BICEPS MATLAB code for biceps.fig
%      BICEPS, by itself, creates a new BICEPS or raises the existing
%      singleton*.
%
%      H = BICEPS returns the handle to a new BICEPS or the handle to
%      the existing singleton*.
%
%      BICEPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BICEPS.M with the given input arguments.
%
%      BICEPS('Property','Value',...) creates a new BICEPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before biceps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to biceps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help biceps

% Last Modified by GUIDE v2.5 15-Feb-2021 12:03:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @biceps_OpeningFcn, ...
    'gui_OutputFcn',  @biceps_OutputFcn, ...
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


% --- Executes just before biceps is made visible.
function biceps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to biceps (see VARARGIN)

settings_make_par_env; %load defaults



set(handles.radiobutton_none,'Value',handles.read_none);
set(handles.radiobutton_FD,'Value',handles.read_FD);
set(handles.radiobutton_power_2014_FD_only,'Value',handles.read_power_2014_FD_only);
set(handles.radiobutton_power_2014_motion,'Value',handles.read_power_2014_motion);
set(handles.checkbox_detect_outliers,'Value',handles.detect_outliers);

set(handles.text_FD_th,'string',make_text_FD_th(handles));

set(handles.edit_FD_th,'string',num2str(handles.mc.FD_th,'%4.4f'));
set(handles.edit_min_time_minutes,'string',num2str(handles.mc.min_time_minutes,'%4.4f'));
set(handles.edit_skip,'string',num2str(handles.mc.skip,'%4.0f'));
set(handles.edit_n_ar,'string',num2str(handles.connectotyping_settings.n_ar,'%4.0f'));
set(handles.checkbox_std,'Value',handles.env.flag(1));
set(handles.checkbox_no_auto,'Value',handles.env.flag(2));
set(handles.checkbox_mb_all,'Value',handles.env.flag(3));
set(handles.checkboxmb_few_frames,'Value',handles.env.flag(4));

set(handles.edit_part_model,'string',num2str(handles.connectotyping_settings.partition_model,'%4.4f'));
set(handles.edit_rep_svd,'string',num2str(handles.connectotyping_settings.repetitions,'%4.0f'));

set(handles.edit_rep_model,'string',num2str(handles.connectotyping_settings.repetitions,'%4.0f'));
set(handles.edit_min_frames,'string',handles.mc.min_frames);

set(handles.uibutton_parcels,'visible','off')
set(handles.edit_min_frames,'enable','off')
set(handles.pushbutton_make_environments,'visible','off')

handles = validate_path_wb_command(handles);

handles.save_raw_timecourses_flag=1;
handles.save_raw_timecourses_flag=handles.save_raw_timecourses_flag==1;
% Choose default command line output for biceps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes biceps wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = biceps_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in read_group_file_button.
function read_group_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to read_group_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,handles.paths.group_file,FilterIndex] = uigetfile(...
    {'*.txt', 'Text file (*.txt)';...
    '*.*',  'All Files (*.*)'}, ...
    'Pick your group file');
handles.groupFile=[handles.paths.group_file FileName];

[paths, ids, visit_folder, pipeline, full_path] = read_participants_and_paths(handles.groupFile);
handles.participants.N=length(ids);
handles.participants.paths=paths;
handles.participants.ids=ids;
handles.participants.visit_folder=visit_folder;
handles.participants.pipeline=pipeline;
handles.participants.full_path=full_path;
handles.participants.unique_ids=length(unique(ids));
handles.participants.unique_pipelines=length(unique(pipeline));
handles.text_after_reading_path=text_after_reading_path(handles);
% handles=update_paths(handles);
set(handles.path_group_file_text,'string',[handles.paths.group_file FileName]);
set(handles.text_content_group_file,'visible','on')
set(handles.text_content_group_file,'string',handles.text_after_reading_path);
set(handles.radiobutton_none,'visible','on')
set(handles.radiobutton_FD,'visible','on')
set(handles.radiobutton_power_2014_FD_only,'visible','on')
% set(handles.radiobutton_power_2014_motion,'visible','on')
set(handles.pushbutton_scout_motion,'visible','on');

% check if paths exist for all subjects and reset if they do not.
n=handles.participants.N; % count the individual studies
full_path=handles.participants.full_path;
fs=filesep;
motion_masks=cell(n,1);
for i=1:n
    
    opt=cell(5,1);
    opt{1} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_motion_mask.mat'],'');
    opt{2} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_bold_mask.mat'],'');
    opt{3} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_desc-filtered_motion_mask.mat'],'');
    opt{4} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_desc-filteredwithoutliers_motion_mask.mat'],'');
    opt{5} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_acq-PrismaSingleBand_motion_mask.mat'],'');
    
    
    local_ix=find(isfile(opt));
    if isempty(local_ix)
        path_dot_mat_file=strtrim(ls([strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task*rest*mask.mat'],'')]));
        motion_masks{i}=path_dot_mat_file;
    else
        motion_masks{i}=opt{local_ix(1)};
    end
    %     motion_masks{i} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_motion_mask.mat'],'');
    %     if ~isfile(motion_masks{i})
    %         motion_masks{i} = strjoin([strtrim(full_path(i,:)) fs 'func' fs ids(i,:) '_' visit_folder(i,:) '_task-rest_bold_mask.mat'],'');
    %     end
    
    %summary_dir = [strtrim(full_path(i,:)) fs handles.paths.summary_dir];
    %file_frames = [strtrim(full_path(i,:)) fs handles.paths.frames];
    %motion_numbers = [strtrim(full_path(i,:)) fs handles.paths.append_path_motion_numbers];
    %csv_parcs = [strtrim(full_path(i,:)) fs handles.paths.append_path_csv_parcellations];
    %dtseries_var = [strtrim(full_path(i,:)) fs handles.paths.append_dtseries_variance fs ids(i,:) 'rfMRI_REST_FNL_preproc_v2_Atlas_Variance.txt'];
    %{
    if exist(summary_dir)==7 || exist(file_frames)==2 || exist(motion_numbers)==7 || exist(csv_parcs)==7
        disp('Default FNL_preproc_v2 folder structure does exist. Continuing...')
        break
    else
        disp('Default FNL_preproc_v2 folder structure DNE. Resetting to FNL_preproc')
        handles.paths.append_path_csv_parcellations=['FNL_preproc' fs 'analyses_v2' fs 'timecourses'];% subfolders after pipeline to find csv parcellations
        handles.paths.append_path_motion_numbers=['FNL_preproc' fs 'analyses_v2' fs 'motion'];% subfolders after pipeline to find motion mumbers
        handles.paths.matlab_code_with_EPI=['FNL_preproc' fs 'analyses_v2' fs 'matlab_code' fs 'FNL_preproc_analysis_v2.m'];% subfolders after pipeline to find motion mumbers
        handles.paths.frames=['summary_FNL_preproc' fs 'frames_per_scan.txt'];% subfolders after pipeline to find motion mumbers
        handles.paths.summary_dir=['summary_FNL_preproc'];
        summary_dir = [strtrim(full_path(i,:)) fs handles.paths.summary_dir];
        file_frames = [strtrim(full_path(i,:)) fs handles.paths.frames];
        motion_numbers = [strtrim(full_path(i,:)) fs handles.paths.append_path_motion_numbers];
        csv_parcs = [strtrim(full_path(i,:)) fs handles.paths.append_path_csv_parcellations];
    end
    if exist(summary_dir)==7 || exist(file_frames)==2 || exist(motion_numbers)==7 || exist(csv_parcs)==7
        disp('New FNL_preproc folder structure exists. Continuing...')
        break
    else
        disp('New FNL_preproc folder structure DNE. Resetting to macaque env')
        handles.paths.append_path_csv_parcellations=['FNL_preproc_monkey' fs 'analyses_v2' fs 'timecourses'];% subfolders after pipeline to find csv parcellations
        handles.paths.append_path_motion_numbers=['FNL_preproc_monkey' fs 'analyses_v2' fs 'motion'];% subfolders after pipeline to find motion mumbers
        handles.paths.matlab_code_with_EPI=['FNL_preproc_monkey' fs 'analyses_v2' fs 'matlab_code' fs 'FNL_preproc_analysis_v2.m'];% subfolders after pipeline to find motion mumbers
        handles.paths.frames=['summary_FNL_preproc_monkey' fs 'frames_per_scan.txt'];% subfolders after pipeline to find motion mumbers
        handles.paths.summary_dir=['summary_FNL_preproc_monkey'];
        summary_dir = [strtrim(full_path(i,:)) fs handles.paths.summary_dir];
        file_frames = [strtrim(full_path(i,:)) fs handles.paths.frames];
        motion_numbers = [strtrim(full_path(i,:)) fs handles.paths.append_path_motion_numbers];
        csv_parcs = [strtrim(full_path(i,:)) fs handles.paths.append_path_csv_parcellations];
    end
    if exist(summary_dir)==7 || exist(file_frames)==2 || exist(motion_numbers)==7 || exist(csv_parcs)==7
        disp('Macaque FNL_preproc folder structure exists. Continuing...')
        break
    else
        disp('Macaque FNL_preproc folder structure DNE. Resetting to OG GUI_environments paths')
        handles.paths.append_path_csv_parcellations=['analyses_v2' fs 'timecourses'];% subfolders after pipeline to find csv parcellations
        handles.paths.append_path_motion_numbers=['analyses_v2' fs 'motion'];% subfolders after pipeline to find motion mumbers
        handles.paths.matlab_code_with_EPI=['analyses_v2' fs 'matlab_code' fs 'FNL_preproc_analysis_v2.m'];% subfolders after pipeline to find motion mumbers
        handles.paths.frames=['summary' fs 'frames_per_scan.txt'];% subfolders after pipeline to find motion mumbers
        handles.paths.summary_dir=['summary'];
        summary_dir = [strtrim(full_path(i,:)) fs handles.paths.summary_dir];
        file_frames = [strtrim(full_path(i,:)) fs handles.paths.frames];
        motion_numbers = [strtrim(full_path(i,:)) fs handles.paths.append_path_motion_numbers];
        csv_parcs = [strtrim(full_path(i,:)) fs handles.paths.append_path_csv_parcellations];
    end
    if exist(summary_dir)==7 || exist(file_frames)==2 || exist(motion_numbers)==7 || exist(csv_parcs)==7
        disp('OG GUI_environments folder structure exists. Continuing...')
        break
    else
        error('This version of GUI_environments has not yet been configured for your subjects folder structure or there is missing data. Please get in contact with Anders Perrone (perronea@ohsu.edu).')
    end
    %}
end
handles.paths.motion_masks = motion_masks;
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_scout_motion.
function pushbutton_scout_motion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_scout_motion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% flag to keep track of the motion censoring methods to be used
motions(1)=handles.read_none;
motions(2)=handles.read_FD;
motions(3)=handles.read_power_2014_FD_only;
motions(4)=handles.read_power_2014_motion;
handles.mc.motions=motions;

n=handles.participants.N; % count the individual studies
ticks=handles.mc.ticks; %read the brakes in FD from the settings
n_ticks=length(ticks);% count the possible number of FD's, 0: 0.01: 0.5
full_path=handles.participants.full_path;
frames=cell(n,1);
fs=filesep;
frame_removal=cell(n,1);
has_variance_flag=zeros(n,1);

% Start reading the total number of frames per study
for i=1:n
    disp(['Reading frames count for participant ' num2str(i) ' out of ' num2str(n)])
    load(handles.paths.motion_masks{i});
    frames{i} = motion_data{1,1}.total_frame_count;
    
    % check if variance file exist
    has_variance_flag(i) = has_variance_file(handles.paths.motion_masks{i});
    
    %{
    file_frames = [strtrim(full_path(i,:)) fs handles.paths.frames];
    frames_temp{1}=csvread(file_frames);
    %true_frames = dir([strtrim(full_path(i,:)) fs 'summary' fs 'FD_REST*.txt']);
    summary_dir=strsplit(handles.paths.frames,'/');
    summary_dir=summary_dir{1};
    %true_frames = dir([strtrim(full_path(i,:)) fs summary_dir fs 'FD_REST*.txt']);
    %if isempty(true_frames)
    %    temp_a=strtrim(full_path(i,:)) ;
    %    temp_b=[handles.paths.frames];
    %    temp_b(1:7)=[];
    %    temp_b=['summary_FNL_preproc_v2' temp_b];
    %    file_frames = [temp_a fs temp_b];
    %    frames_temp{1}=csvread(file_frames);
        
        %true_frames = dir([strtrim(full_path(i,:)) fs 'summary_FNL_preproc_v2' fs '*FD_*REST*.txt']);
        
    true_frames=sort_RS_GUI_environments([strtrim(full_path(i,:)) fs summary_dir fs '*FD_*REST*.txt']);
    %end
    
    
    count = 0;
    for j = 1:max(size(true_frames))
        count = count + 1;
        %         frames{i}(count,1)=frames_temp{1}(str2num(true_frames(j).name(end-4))); % to be fixed for more than 9 RS
        frames{i}(count,1)=frames_temp{1}(j); % to be fixed for more than 9 RS
        
    end
    %}
end
handles.mc.frames=frames;
disp('Done reading frames count')
disp(' ')

% Preallocate memory to read the motion censored frames
TR=zeros(n,1);
if motions(2)
    FD=zeros(n,n_ticks);
    FD_TR=zeros(n,1);
    cat_FD=cell(n,1);
end

if motions(3)
    FD_power_2014_FD_only=zeros(n,n_ticks);
    FD_power_2014_FD_only_TR=zeros(n,1);
    cat_FD_power_2014_FD_only=cell(n,1);
end

if motions(4)
    FD_power_2014_motion=zeros(n,n_ticks);
    FD_power_2014_motion_TR=zeros(n,1);
    cat_FD_power_2014_motion=cell(n,1);
end

motion_found=zeros(n,3); % to keep track of guys without a particular motion censoring dataset

% Read the motion numbers
tic
for i=1:n
    %path_to_motion = [strtrim(full_path(i,:)) fs handles.paths.append_path_motion_numbers];
    path_to_motion = [strtrim(full_path(i,:)) fs 'func'];
    disp(['Reading motion numbers from participant ' num2str(i) ' out of ' num2str(n)])
    filename=handles.paths.motion_masks{i};
    load(filename);
    frames{i} = motion_data{1,1}.total_frame_count;
    
    if motions(3)
        %filename = [strtrim(full_path(i,:)) fs handles.paths.matlab_code_with_EPI];
        %filename = [strtrim(full_path(i,:)) fs handles.paths.matlab_code_with_EPI];
        %TR(i) = read_TR_MC_none(filename);frame_removal
        TR(i) = motion_data{1,1}.epi_TR;
        [FD_power_2014_FD_only(i,:) cat_FD_power_2014_FD_only{i} TR(i) frame_removal{i}]=read_motion_data(filename,n_ticks);
        motion_found(i,2)=1;
    end
    
    
end
handles.mc.frame_removal=frame_removal;

disp(['Done'])
toc


set(handles.text_FD_th,'string',make_text_FD_th(handles));

set(handles.text6,'visible','on')
set(handles.text_7,'visible','on')
set(handles.text8,'visible','on')
set(handles.text12,'visible','on')

set(handles.edit_FD_th,'visible','on')
set(handles.edit_min_time_minutes,'visible','on')
set(handles.edit_skip,'visible','on')
set(handles.edit_n_ar,'visible','on')




uTRs=unique(TR);
nTRs=length(uTRs);
if nTRs==1
    handles.mc.TR=uTRs;
else
    disp(['you are combining data with ' num2str(nTRs) ' distinct TR''s: '])
end
for i=1:nTRs
    disp(['TR ' num2str(i) ' = ' num2str(uTRs(i),'%4.4f') ' seconds, present in ' num2str(sum(TR==uTRs(i))) ' participants'])
end

if sum(uTRs==0)>0
    temp_ix=find(TR==0);
    n_temp_ix=length(temp_ix);
    disp ('Indices of participants with TR = 0')
    disp(temp_ix)
end

tick=find(ticks>=handles.mc.FD_th,1);
handles.mc.tick=tick;
handles=count_remaining_frames(handles);

% save FD
handles.mc.orig_surv_std=handles.mc.surv_std;
handles.mc.orig_surv_mb=handles.mc.surv_mb;

% calculate outliers
handles.mc.outlier_mask_std=cell(handles.participants.N,1);
handles.mc.outlier_mask_mb=cell(handles.participants.N,1);
alternative_path_variances=ask_for_alternative_path_variance(has_variance_flag);
handles.alternative_path_variances=alternative_path_variances;
handles = make_outliers_mask(handles);

set(handles.checkbox_detect_outliers,'visible','on');

set(handles.text9,'visible','on')
set(handles.text_FD_th,'string',make_text_FD_th(handles));
set(handles.text_FD_th,'visible','on')

set(handles.text10,'visible','on')
set(handles.text_survivors,'string',make_text_survivors(handles));
set(handles.text_survivors,'visible','on')

set(handles.pushbutton_show_histogram,'visible','on')
set(handles.pushbutton_find_timecourses,'visible','on')



handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in radiobutton_none.
function radiobutton_none_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_none
handles.read_none=get(handles.radiobutton_none,'Value');
if handles.read_none
    handles.read_FD=0;
    handles.read_power_2014_FD_only=0;
    handles.read_power_2014_motion=0;
end
set(handles.radiobutton_none,'Value',handles.read_none);
set(handles.radiobutton_FD,'Value',handles.read_FD);
set(handles.radiobutton_power_2014_FD_only,'Value',handles.read_power_2014_FD_only);
set(handles.radiobutton_power_2014_motion,'Value',handles.read_power_2014_motion);


handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in radiobutton_FD.
function radiobutton_FD_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_FD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_FD
handles.read_FD=get(handles.radiobutton_FD,'Value');
if handles.read_FD
    handles.read_none=0;
    handles.read_power_2014_FD_only=0;
    handles.read_power_2014_motion=0;
    
end
set(handles.radiobutton_none,'Value',handles.read_none);
set(handles.radiobutton_FD,'Value',handles.read_FD);
set(handles.radiobutton_power_2014_FD_only,'Value',handles.read_power_2014_FD_only);
set(handles.radiobutton_power_2014_motion,'Value',handles.read_power_2014_motion);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in radiobutton_power_2014_FD_only.
function radiobutton_power_2014_FD_only_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_power_2014_FD_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.read_power_2014_FD_only=get(handles.radiobutton_power_2014_FD_only,'Value');
if handles.read_power_2014_FD_only
    handles.read_none=0;
    handles.read_FD=0;
    handles.read_power_2014_motion=0;
end
set(handles.radiobutton_none,'Value',handles.read_none);
set(handles.radiobutton_FD,'Value',handles.read_FD);
set(handles.radiobutton_power_2014_FD_only,'Value',handles.read_power_2014_FD_only);
set(handles.radiobutton_power_2014_motion,'Value',handles.read_power_2014_motion);

handles.output = hObject;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_power_2014_FD_only


% --- Executes on button press in radiobutton_power_2014_motion.
function radiobutton_power_2014_motion_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_power_2014_motion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.read_power_2014_motion=get(handles.radiobutton_power_2014_motion,'Value');

if handles.read_power_2014_motion
    handles.read_none=0;
    handles.read_FD=0;
    handles.read_power_2014_FD_only=0;
end

set(handles.radiobutton_none,'Value',handles.read_none);
set(handles.radiobutton_FD,'Value',handles.read_FD);
set(handles.radiobutton_power_2014_FD_only,'Value',handles.read_power_2014_FD_only);
set(handles.radiobutton_power_2014_motion,'Value',handles.read_power_2014_motion);
handles.output = hObject;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_power_2014_motion



function edit_FD_th_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FD_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=str2double(get(hObject,'String'));
if temp<0
    temp=0;
end
if temp>0.5;
    temp=.5;
end
handles.mc.FD_th=round(temp,2);
handles.mc.tick=find(handles.mc.ticks>=handles.mc.FD_th,1);


set(hObject,'String',num2str(temp,'%4.2f'))
set(handles.text_FD_th,'string',make_text_FD_th(handles));
set(handles.text_FD_th,'visible','on')

handles=count_remaining_frames(handles);
set(handles.checkbox_detect_outliers,'value',0.0);
set(handles.text_survivors,'string',make_text_survivors(handles));

handles.output = hObject;
guidata(hObject, handles);


% Hints: get(hObject,'String') returns contents of edit_FD_th as text
%        str2double(get(hObject,'String')) returns contents of edit_FD_th as a double


% --- Executes during object creation, after setting all properties.
function edit_FD_th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FD_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_min_time_minutes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_time_minutes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_time_minutes as text
%        str2double(get(hObject,'String')) returns contents of edit_min_time_minutes as a double
temp=str2double(get(hObject,'String'));
if temp<0
    temp=0;
end

handles.mc.min_time_minutes=temp;
handles.mc.min_frames=floor(handles.mc.min_time_minutes*60/handles.mc.TR);
set(hObject,'String',num2str(temp,'%4.4f'))
set(handles.text_FD_th,'string',make_text_FD_th(handles));
set(handles.text_FD_th,'visible','on')

handles=count_remaining_frames(handles);
set(handles.text_survivors,'string',make_text_survivors(handles));
set(handles.checkbox_detect_outliers,'value',0.0);
handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_min_time_minutes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_time_minutes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_show_histogram.
function pushbutton_show_histogram_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_show_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
make_hist_surv(handles);


function edit_skip_Callback(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_skip as text
%        str2double(get(hObject,'String')) returns contents of edit_skip as a double
temp=str2double(get(hObject,'String'));
if temp<0
    temp=handles.mc.skip;
end

handles.mc.skip=temp;
set(hObject,'String',num2str(temp,'%4.0f'))
set(handles.text_FD_th,'string',make_text_FD_th(handles));
set(handles.text_FD_th,'visible','on')
handles=count_remaining_frames(handles);
set(handles.text_survivors,'string',make_text_survivors(handles));
set(handles.checkbox_detect_outliers,'value',0.0);
handles.output = hObject;
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function edit_skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_n_ar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n_ar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n_ar as text
%        str2double(get(hObject,'String')) returns contents of edit_n_ar as a double
temp=str2double(get(hObject,'String'));
if temp<0
    temp=handles.connectotyping_settings.n_ar;
end

handles.connectotyping_settings.n_ar=temp;
set(hObject,'String',num2str(temp,'%4.0f'))
set(handles.text_FD_th,'string',make_text_FD_th(handles));
set(handles.text_FD_th,'visible','on')
handles=count_remaining_frames(handles);
set(handles.text_survivors,'string',make_text_survivors(handles));
set(handles.checkbox_detect_outliers,'value',0.0);
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_n_ar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n_ar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_detect_outliers.
function checkbox_detect_outliers_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_detect_outliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_detect_outliers

handles=count_remaining_frames(handles);
handles.mc.orig_surv_std=handles.mc.surv_std;
handles.mc.orig_surv_mb=handles.mc.surv_mb;

if handles.checkbox_detect_outliers.Value
    for i=1:handles.participants.N
        handles.mc.surv_std{i} = handles.mc.orig_surv_std{i} .* handles.mc.outlier_mask_std{i}==1;
        handles.mc.surv_mb{i} = handles.mc.orig_surv_mb{i} .* handles.mc.outlier_mask_mb{i}==1;
        handles.mc.n_surv_frames(i,1)=sum(handles.mc.surv_std{i});
        handles.mc.n_surv_frames(i,2)=sum(handles.mc.surv_mb{i});
        
    end
else
    for i=1:handles.participants.N
        handles.mc.surv_std{i} = handles.mc.orig_surv_std{i};
        handles.mc.surv_mb{i} = handles.mc.orig_surv_mb{i};
        handles.mc.n_surv_frames(i,1)=sum(handles.mc.surv_std{i});
        handles.mc.n_surv_frames(i,2)=sum(handles.mc.surv_mb{i});
    end
end
handles.mc.surv_ix=handles.mc.n_surv_frames>handles.mc.min_frames;
set(handles.text_survivors,'string',make_text_survivors(handles));
handles.output = hObject;
guidata(hObject, handles);




% --- Executes on button press in pushbutton_find_timecourses.
function pushbutton_find_timecourses_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_find_timecourses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = find_parcellated_paths(handles);


set(handles.uibutton_parcels,'visible','on')
set(handles.uipanel_connectotype,'visible','off')
set(handles.uibuttongroup_env,'visible','on')
n=length(handles.mc.surv_parcels);
%%
for i=1:n
    handles.cbh(i) =uicontrol(handles.uibutton_parcels,'Style','checkbox',...
        'String',handles.mc.surv_parcels{i},...
        'Value',0,'Position',[20 15*i 130 20]);
end

% handles.checkboxmb_few_frames
set(handles.edit_min_frames,'string',handles.mc.min_frames);
set(handles.pushbutton_set_path_gagui,'visible','on')


handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in checkbox_std.
function checkbox_std_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_std


% --- Executes on button press in checkbox_no_auto.
function checkbox_no_auto_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_no_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.env.flag(2)=get(hObject,'Value');
handles.output = hObject;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_no_auto


% --- Executes on button press in checkbox_mb_all.
function checkbox_mb_all_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mb_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.env.flag(3)=get(hObject,'Value');

if sum(handles.env.flag(3:4))>0
    set(handles.uipanel_connectotype,'visible','on')
else
    set(handles.uipanel_connectotype,'visible','off')
end

handles.output = hObject;
guidata(hObject, handles);


% Hint: get(hObject,'Value') returns toggle state of checkbox_mb_all


% --- Executes on button press in checkboxmb_few_frames.
function checkboxmb_few_frames_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxmb_few_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxmb_few_frames
handles.env.flag(4)=get(hObject,'Value');

if get(hObject,'Value')
    set(handles.text13,'visible','on');
    set(handles.text17,'visible','on');
    set(handles.edit_min_frames,'visible','on');
    set(handles.edit_rep_model,'visible','on');
    set(handles.edit_min_frames,'string',handles.mc.min_frames);
    set(handles.edit_rep_model,'string',handles.connectotyping_settings.repetitions);
    handles.env.name{4}=['connectotyping_' num2str(handles.connectotyping_settings.default_frames) '_frames'];
else
    set(handles.text13,'visible','off');
    set(handles.text17,'visible','off');
    set(handles.edit_min_frames,'visible','off');
    set(handles.edit_rep_model,'visible','off');
end

if sum(handles.env.flag(3:4))>0
    set(handles.uipanel_connectotype,'visible','on')
else
    set(handles.uipanel_connectotype,'visible','off')
end

handles.output = hObject;
guidata(hObject, handles);

if get(hObject,'Value')
end



function edit_min_frames_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_frames as text
%        str2double(get(hObject,'String')) returns contents of edit_min_frames as a double
temp=str2double(get(hObject,'String'));
if temp<handles.mc.min_frames
    temp=handles.mc.min_frames;
end
handles.connectotyping_settings.default_frames=temp;
set(handles.edit_min_frames,'string',num2str(handles.connectotyping_settings.default_frames,'%4.0f'));
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_min_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% handles.env.name{4}=['connectotyping_' num2str(handles.connectotyping_settings.default_frames) '_frames'];
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_part_model_Callback(hObject, eventdata, handles)
% hObject    handle to edit_part_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_part_model as text
%        str2double(get(hObject,'String')) returns contents of edit_part_model as a double
temp=str2double(get(hObject,'String'));
if temp<0
    temp=0;
end
if temp>99;
    temp=99;
end
handles.connectotyping_settings.partition_model=temp;
set(hObject,'String',num2str(temp,'%4.2f'))

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_part_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_part_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rep_svd_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rep_svd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rep_svd as text
%        str2double(get(hObject,'String')) returns contents of edit_rep_svd as a double
temp=str2double(get(hObject,'String'));
if temp<0
    temp=0;
end

handles.connectotyping_settings.rep_svd=temp;
set(hObject,'String',num2str(temp,'%4.2f'))

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_rep_svd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rep_svd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rep_model_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rep_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rep_model as text
%        str2double(get(hObject,'String')) returns contents of edit_rep_model as a double
temp=str2double(get(hObject,'String'));
if temp<1
    temp=1;
end
handles.connectotyping_settings.repetitions=temp;
set(handles.edit_rep_model,'string',num2str(handles.connectotyping_settings.repetitions,'%4.0f'));
handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_rep_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rep_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_set_path_gagui.
function pushbutton_set_path_gagui_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_path_gagui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[d1, d2, d3] = fileparts(handles.groupFile);

handles.env.path_group_list=d1;
handles.env.original_filename=d2;
handles.env.original_filename_ext=d3;

dummy=strfind(d1,filesep);

% path_gagui=d1(1:dummy(end)-1);
% handles.env.path_gagui=path_gagui;
path_gagui=d1;
handles.env.path_gagui=d1;

handles.env.path_gagui=uigetdir(path_gagui,'Path to save connectivity matrices');
set(handles.pushbutton_make_environments,'visible','on');
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_make_environments.
function pushbutton_make_environments_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_make_environments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename_censored_data=make_filename_censored_data(handles);
handles.env.group=filename_censored_data;
make_file_censored_data(handles);

handles.save_raw_timecourses_flag=ask_save_raw_timecourses();
if handles.env.flag(1)
    make_std_env(handles);
    disp ('Done calculating correlation matrices!');
end

if handles.env.flag(2)
    make_no_autocorrelation_env(handles);
    disp ('Done calculating correlation matrices with no autocorrelation!');
end

if or(handles.env.flag(3),handles.env.flag(4))
    make_model_based_env(handles);
end

disp ('Thank you for using BICEPS to calculate connectivity matrices!');

handles.output = hObject;
guidata(hObject, handles);
