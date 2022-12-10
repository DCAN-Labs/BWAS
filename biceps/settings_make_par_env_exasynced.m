%%
fs = filesep;
handles.fs = fs;
%% Defaults to calculate connectotyping
handles.connectotyping_settings.default_frames=60; % set the number of random frames included to connectotype, subjects with fewer frames will be excluded from this environment
handles.connectotyping_settings.repetitions=10; % if a participant has more than 60 frames, then the model is repeated "repetitions" times
handles.connectotyping_settings.partition_model=80; % percentage of frames to calculate the pseudoinverse
handles.connectotyping_settings.partition_validation=100-handles.connectotyping_settings.partition_model; %percentage of frames to validate the number of singular values
handles.connectotyping_settings.rep_svd=10; % time per participant, in hours
handles.connectotyping_settings.time_per_part=.5; % time per participant, in hours
handles.connectotyping_settings.n_ar=5; % number of frames for autocorrelation, after skip
handles.connectotyping_settings.QUEUE='"qsub -l mf=4G,h_rt=2:40:00"';
handles.connectotyping_settings.run_connectotype_filename='run_connectotype.sh';
%% List of default environments
handles.env.name{1}='standard';
handles.env.name{2}='no_autocorrelation';
handles.env.name{3}='connectotyping_all_frames';
handles.env.name{4}=['connectotyping_' num2str(handles.connectotyping_settings.default_frames) '_frames'];
handles.env.flag=[1 0 0 0];
handles.env.std_mask_name='frame_removal_mask.mat';
handles.env.raw_tc='raw_timecourses.mat';
handles.env.masked_tc='masked_timecourses.mat';
%% Places where this GUI looks for paths and files, by default
handles.paths.wd=pwd; %working directory
handles.paths.group_file=[handles.paths.wd '/group_lists'];
handles.paths.append_path_csv_parcellations=['analyses_v2' fs 'timecourses'];% subfolders after pipeline to find csv parcellations
handles.paths.append_path_motion_numbers=['analyses_v2' fs 'motion'];% subfolders after pipeline to find motion mumbers
handles.paths.matlab_code_with_EPI=['analyses_v2' fs 'matlab_code' fs 'FNL_preproc_analysis_v2.m'];% subfolders after pipeline to find motion mumbers
handles.paths.frames=['summary' fs 'frames_per_scan.txt'];% subfolders after pipeline to find motion mumbers
handles.paths.append_results=['MNINonLinear' fs 'Results']

%% List of defaults for motion
handles.mc.FD_th=0.2;
handles.mc.min_time_minutes=2.5;
handles.mc.min_frames=60;
handles.mc.skip=5;
handles.mc.ticks=0:.01:.5;% breaks in the FD's
handles.mc.methods{1}='none';
handles.mc.methods{2}='FD';
handles.mc.methods{3}='power_2014_FD_only';
handles.mc.methods{4}='power_2014_motion';


handles.read_none=0;
handles.read_FD=0;
handles.read_power_2014_FD_only=1;
handles.read_power_2014_motion=0;
handles.detect_outliers=1;

%% permissions and file handling
handles.permissions='766';
handles.func_data_name='Functional';

%%
