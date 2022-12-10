%% show_networks_reliability

% Use this example to run show_networks_reliability

%% local set up

wd='C:\Users\oscar\OneDrive\matlab_code\plotting-tools\show_networks_reliability';
fs=filesep;
cd(wd)
%% path HCP
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\HCP_ColeAnticevic_subcortical.mat';
Tcolor = parcel2Tcolor(path_parcellation_table);
%% Example 1
clear exp_var_table
exp_var_table(1).path=[wd fs 'correlations_by_networks_ARM1-ARM2.csv'];
exp_var_table(1).title='ARM1-ARM2';
exp_var_table(2).path=[wd fs 'correlations_by_networks_ARM2-ARM1.csv'];
exp_var_table(2).title='ARM2-ARM1';
show_networks_reliability (exp_var_table,...
    'Tcolor',Tcolor)
%% Example 2
exp_var_table(3).path=[wd fs 'correlations_by_networks_ARM1-ARM2.csv'];
exp_var_table(3).title='ARM1-ARM3';
% Define resolution to save
res=1000;

% Define output_folder
output_folder=pwd;

% Define filename
filename='toy_example_3_networks';

% Define n_upto
n_upto=20;

% Run
show_networks_reliability (exp_var_table,...
    'Tcolor',Tcolor,...
    'output_folder',output_folder,...
    'filename',filename,...
    'n_upto',n_upto,...
    'res',res)

