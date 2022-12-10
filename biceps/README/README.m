%% BICEPS

%% Overview

%% Example

%% Exploring the outputs

%% Rationale

%% Recommended steps in preparation to run it smoothly

%% Explore BIDS folders, get list of participants and report counts
%
% To feed the GUI_environments you need a list of participants (paths to
% BIDS formatted data). You can use the function |scout_bids_for_gui_env| to generate this list.
%
% This function will allow you to:
%
% * Get a properly formatted list to feed the GUI_environments.
% * Make a report of dtseries, ptseries and dot mat dot mat files.
% * Generate a report of folders with missing data.
%
% By default, it will search for dot mat movement file (|*rest*bold*.mat|), and
% dtseries nifti (|*rest*bold*dtseries.nii*|) files.
%
% This is the most basic example to run it:
%
% Define path to BIDS folder to extract the list
path_BIDS_data='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\data\anonymized_human'; % Update path accordingly to your system
[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data)
% 
% **Mandatory Input**
% * path_BIDS_data: path to your data
% Outputs:
%%
%
% To add a prefix to the list name, provide the extra argument preffix:
preffix='all_dtseries_';
[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data,...
    'preffix',preffix)
%
% This created the file |all_dtseries_list_N_14.txt|
%%
% To look for paths with several parcellation schemas, for example Gordon
% and HCP, you define the extra argument |extra_strings_to_match| as follows: 
extra_strings_to_match{1}='*rest*bold*ordon*ptseries.nii*';
extra_strings_to_match{2}='*rest*bold*HCP*ptseries.nii*';
[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data,...
    'extra_strings_to_match',extra_strings_to_match)
%%
% To look for all the possible parcels:
extra_strings_to_match='*rest*bold*ptseries.nii*';
[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data,...
    'extra_strings_to_match',extra_strings_to_match)
%% 
%
% To exclude dtseries, only look for HCP and specifying a output filename
preffix='only_Gordon_no_dtseries';
exclude_dtseries_flag=1;
extra_strings_to_match='*rest*bold*HCP*ptseries.nii*';

[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data,...
    'extra_strings_to_match',extra_strings_to_match,...
    'exclude_dtseries_flag',exclude_dtseries_flag,...
    'extra_strings_to_match',extra_strings_to_match)
%%
% Example using macaque data
%
path_BIDS_data='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\data\macaque';
preffix='macaque_Bezgin_';
exclude_dtseries_flag=1;
extra_strings_to_match='*Bezgin*ptseries.nii*';

[T_count, list,text_counts,text_missing] = scout_bids_for_gui_env(path_BIDS_data,...
    'extra_strings_to_match',extra_strings_to_match,...
    'exclude_dtseries_flag',exclude_dtseries_flag,...
    'extra_strings_to_match',extra_strings_to_match,...
    'preffix',preffix)
%% Pre-calculate variance file for all the subjects
%
% The `GUI_environments` look for outliers based on the variance of the
% dtseries. If existing, that file is used, if not the file is calculated
% by the `GUI_environments`. If variance files do not exist, you can save time by pre-calculating them by running this patch:
path_list_file='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README\list_N_14.txt';
dtvariance_patch(path_list_file)

%% 
%
% Do it for macaque
%
% 
path_list_file=['C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README' filesep 'macaque_Bezgin_list_N_11.txt'];
output_folder=['C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README' filesep ' macaque_variance'];
dtvariance_patch(path_list_file,...
    'output_folder',output_folder)
%% Known issues

%% Installation and set-up
