%% dlabel2table

% This function make tables with coordinates of each grayordinate in a
% label file. The table also include ROI names and colors



%% Define input label file
path_dlabel='HCP_ColeAnticevic_wSubcorGSR.dlabel.nii';


%% Provide references

path_left_midthicknes='Atlas1.L.midthickness.32k_fs_LR.surf.gii';
path_right_midthicknes='Atlas1.R.midthickness.32k_fs_LR.surf.gii';

%% Define output folder and suffix for naming
fs=filesep;
output_folder=[pwd fs 'outputs'];
suffix = '_HCP';
%% Run the function
dlabel2table(...
    path_dlabel,...
    path_left_midthicknes,...
    path_right_midthicknes,...
    output_folder,...
    suffix)