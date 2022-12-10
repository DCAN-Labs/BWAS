function [ptseries, pconn]=add_ptseries_pconn_from_label(path_label_file)

%% [ptseries, pconn]=add_ptseries_pconn_from_label(path_label_file)
% Use this function to calculate and save ptseries and pconn files from a
% template label file

%% Example

% path_label_file='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\label_files\human\HCP_ColeAnticevic_wSubcorGSR.dlabel.nii';
% [ptseries, pconn]=add_ptseries_pconn_from_label(path_label_file)
%% Identify path to dense timeseries

dtseries=which('Atlas_subcortical.dtseries.nii');
[repo_path , name , ext ] = fileparts(dtseries);
fs=filesep;

%% Define path_to_save_data


path_ptseries = repo_path;
path_pconn = strrep( repo_path , 'xtseries' , 'xconn' );

%% Get path to wb_command
handles=[];
handles = validate_path_wb_command(handles);
path_wb_command=handles.paths.wb_command;

%% Define filenames
[who_cares , label_name , ext ] = fileparts(path_label_file);

base_name = strrep( label_name , '.dlabel' , '' );

ptseries = [path_ptseries fs base_name '.ptseries.nii'];
pconn    = [path_pconn    fs base_name '.pconn.nii']; 
%% parcellate data

text_to_eval=[path_wb_command  ' -cifti-parcellate ' dtseries ' ' path_label_file ' COLUMN ' ptseries];
unix(text_to_eval);

%% Calculate connextivity matrix

text_to_eval=[path_wb_command  ' -cifti-correlation ' ptseries ' ' pconn];
unix(text_to_eval);

