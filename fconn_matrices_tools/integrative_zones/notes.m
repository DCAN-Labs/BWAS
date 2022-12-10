%% add paths
addpath(genpath('C:\Users\oscar\OneDrive\matlab_code'));

%%
wd='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\integrative_zones';
%%
fs=filesep;

%% PAth to label file

path_dlabel=[wd fs 'integrative_zones.dlabel.nii'];

%% This section reads the label file and save ROIs as text file

tidyTable_filename=[pwd fs 'integrative_zones_temp'];
tidyTable=dlabel_to_tidyTable(path_dlabel,tidyTable_filename);

%% Network assignment was done at the msi:
% /home/miran045/shared/projects/messing_with_labels/int_zones