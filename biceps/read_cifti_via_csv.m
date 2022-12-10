function tseries = read_cifti_via_csv (path_cifti,path_wb_c)

%% tseries = read_cifti_via_csv (path_cifti,path_wb_c)
% This function reads ciftis by making a csv first and then importing the
% content into matlab,

%% Some paths for testing
% path_cifti='/home/groups/brainmri/abcd/data/HCP/derivatives/dcan_abcd_pipeline//sub-NDARINVEBMR55XD/ses-baselineYear1Arm1/func/sub-NDARINVEBMR55XD_ses-baselineYear1Arm1_task-rest_bold_timeseries.dtseries.nii';

% path_cifti='/home/exacloud/lustre1/fnl_lab/data/HCP/derivatives/marc/sub-MARC0220/ses-None/func/sub-MARC0220_ses-None_task-rest_run-1_bold_timeseries.dtseries.nii';
% path_cifti='/home/exacloud/lustre1/fnl_lab/data/HCP/derivatives/marc/sub-MARC0220/ses-None/func/sub-MARC0220_ses-None_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_timeseries.ptseries.nii';
% path_wb_c='/home/exacloud/lustre1/fnl_lab/code/external/utilities/workbench-1.2.3-HCP/bin_rh_linux64/wb_command';
%% Section to make a temporary filename

N_random_char=10;
ascii_char_map=[65:90 48:57 97:122];
ix=1:numel(ascii_char_map);
rand_ix=randi(numel(ix),N_random_char,1);
rand_part=char(ascii_char_map(rand_ix));
temp_csv=['who_cares_' rand_part '.csv'];
%% Create the text to run in the system

if ~isfile(path_cifti)
    path_cifti = strrep(path_cifti,'atlas','roi');
end
to_run = [path_wb_c ' -cifti-convert -to-text ' quotes_if_space(path_cifti) ' ' temp_csv];
%% Send instruction to be executed on your local system


% tic;
% disp('Doing cifti to txt')
system(to_run);
% disp('DONE cifti to txt')
% toc
%% Read csv

% tic
% disp('Reading txt')
tseries=dlmread(temp_csv);
% disp('DONE Reading txt')
% toc
%% clean up | Deleting csv
delete(temp_csv)
