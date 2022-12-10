%% dlabel2volume
% This function is a Matlab wrapper for a couple of functions in wb_command


%% Define input label file
path_dlabel='HCP_ColeAnticevic_wSubcorGSR.dlabel.nii';

%% Provide references

path_left_midthicknes='Atlas1.L.midthickness.32k_fs_LR.surf.gii';
path_right_midthicknes='Atlas1.R.midthickness.32k_fs_LR.surf.gii';
path_left_pial='Atlas1.L.pial.32k_fs_LR.surf.gii';
path_right_pial='Atlas1.R.pial.32k_fs_LR.surf.gii';
path_left_white='Atlas1.L.white.32k_fs_LR.surf.gii';
path_right_white='Atlas1.R.white.32k_fs_LR.surf.gii';
path_volume_template='T1w_restore_brain.nii.gz';


%% Define output volume filenames
left_output_volume_filename='left_output_vol.nii.gz';
right_output_volume_filename='right_output_vol.nii.gz';
subcortical_output_volume_filename='subcortical_output_vol.nii.gz';


%% Run the function
dlabel2volume(...
    path_dlabel,...
    path_left_midthicknes,...
    path_right_midthicknes,...
    path_left_pial,...
    path_right_pial,...
    path_left_white,...
    path_right_white,...
    path_volume_template,...
    left_output_volume_filename,...
    right_output_volume_filename,...
    subcortical_output_volume_filename)