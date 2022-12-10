%% This wrapper runs corr_pt_dt after doing motion censoring
% Update code and paths accordingly ()

cd /group_shares/PSYCH/code/development/utilities/corr_pt_dt/ % move to the code

%% Auxiliary variables
FD_ticks=0:.01:.5;
%% Add paths to the code
% double check paths you are doing this in the new airc

addpath(genpath('/group_shares/PSYCH/code/development/utilities/corr_pt_dt'));% folder containing functions
addpath(genpath('/group_shares/PSYCH/code/external/utilities/gifti-1.4'));% folder containing functions
addpath(genpath('/group_shares/PSYCH/code/external/utilities/Matlab_CIFTI'));% folder containing functions


path_wb_c='/usr/global/hcp_workbench/bin_linux64/wb_command'; %path to wb_command. Update this accordingly

%% Paths to the data

f=filesep;
hosting_directory_until_pipeline='/group_shares/PSYCH/code/development/utilities/corr_pt_dt/temp_for_angelica/path_hcp_processed_until_pipeline'; %UPDATE
parcellation='Gordon_subcortical';
SubdID='Av_318'; %

dt_series_file=[hosting_directory_until_pipeline f SubdID f 'MNINonLinear' f 'Results' f SubdID '_FNL_preproc_Atlas.dtseries.nii'];
pt_series_file=[hosting_directory_until_pipeline f SubdID f 'MNINonLinear' f 'Results' f SubdID '_FNL_preproc_' parcellation '.ptseries.nii'];
ls(dt_series_file)
ls(pt_series_file)
 
%% Define the seed ROIs
ix=[342 162]; % selecting here ROIS 342) ACCUMBENS_LEFT and 162)162_R_Default
%% Extra step to do motion censoring using Power 2014 FD only

FD_th=0.2; %define motion censoring
FD_tick=find(FD_ticks==FD_th);


motion_file=[hosting_directory_until_pipeline f SubdID f 'analyses_v2' f 'motion' f 'power_2014_FD_only.mat'];
load(motion_file)

mask=~motion_data{FD_tick}.frame_removal;

display([num2str(sum(mask)) ' frames survived this criteria'])


%% Calculate connectivity maps

% define the name of the output file
output_file=['/group_shares/PSYCH/code/development/utilities/corr_pt_dt/temp_for_angelica/pt_dt_conn_censored']; %UPDATE

% DO THE WORK
corr_pt_dt(pt_series_file,dt_series_file,ix,output_file,mask)

