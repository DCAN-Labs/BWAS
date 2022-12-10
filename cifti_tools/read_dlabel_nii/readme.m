%% read_dlabel_nii tools

% Use this functions to read dlabel files directly from Matlab.
%% dlabel_to_tidyTable
% Use the function dlabel_to_tidyTable to go directly from the dlabel.nii
% to a table with the ROI names, RGB colors and alpha values
clear
clc
fs=filesep;
path_dlabel='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\label_files\human\HCP.subcortical.32k_fs_LR.dlabel.nii';
tidyTable_filename=[pwd fs 'HCP'];
tidyTable=dlabel_to_tidyTable(path_dlabel,tidyTable_filename);
%% read_temp_label_txt
% USe the function read_temp_label_txt to read a txt file already made by -cifti-label-export-table
temp_label_txt='HCP.txt';
T = read_temp_label_txt(temp_label_txt);