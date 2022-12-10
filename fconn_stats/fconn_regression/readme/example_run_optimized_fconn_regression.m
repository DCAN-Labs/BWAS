%% Basic example

% This example ilustrate how to run a polyneuro risk score analysis. Here
% we will use cortical thickness data to predict outcome (change in dual
% task cost)
%% Add code to your matlab session
% update this accordingly to your system
if ispc
    path_code='C:\Users\oscar\OneDrive\matlab_code';
else
    path_code='/Users/miran045/OneDrive/matlab_code';
end
addpath(genpath(path_code))
fs= filesep;
%% Identify repo's path
foo=which('fconn_regression');
[repo_path , name , ext ] = fileparts(foo);
repo_path;
%%%% Define root output folder
% Update accordingly
if ispc
root_output_folder='C:\Users\oscar\Downloads';
else
    root_output_folder='/Users/miran045/Desktop/';
end
%%
path_imaging_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M1_corr.mat'];
% path_imaging_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M1.mat'];
path_demographics_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Table1.csv'];
path_dictionary_demographics_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'dictionary_tables1_and_2.csv'];
path_group_Design_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Group_Design_Table.csv'];
path_imaging_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M2_corr.mat'];
% path_imaging_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M2.mat'];
path_demographics_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Table2.csv'];
path_dictionary_demographics_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'dictionary_tables1_and_2.csv'];
path_group_Design_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Group_Design_Table.csv'];
path_parcellation_table=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'HCPcombPD25.mat'];

%%
% % path_imaging_training='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\M1_corr.mat';
% path_imaging_training='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\M1.mat';
% path_demographics_Table_training='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Table1.csv';
% path_dictionary_demographics_Table_training='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\dictionary_tables1_and_2.csv';
% path_group_Design_Table_training='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Group_Design_Table.csv';
% % path_imaging_prediction='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\M2_corr.mat';
% path_imaging_prediction='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\M2.mat';
% path_demographics_Table_prediction='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Table2.csv';
% path_dictionary_demographics_Table_prediction='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\dictionary_tables1_and_2.csv';
% path_group_Design_Table_prediction='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Group_Design_Table.csv';
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\HCP_ColeAnticevic_combined_Visual_PD25.csv';
output_folder=[root_output_folder fs 'output_optimized_fconn_regression'];
clear options
options.out_for_xval=1;
options.zscoring=[0];
options.resort_parcel_order=[1 2];%
options.N=1e2;
options.N_Null=4e2;
options.save_data=1;
options.scout_up_to=2;
options.symmetrize=1;
rng('shuffle')

%%

run_optimized_fconn_regression(path_imaging_training,...
    path_demographics_Table_training,...
    path_dictionary_demographics_Table_training,...
    path_group_Design_Table_training,...
    path_imaging_prediction,...
    path_demographics_Table_prediction,...
    path_dictionary_demographics_Table_prediction,...
    path_group_Design_Table_prediction,...
    path_parcellation_table,...
    'output_folder',output_folder,...
    'options',options)

%% Gordon


path_imaging_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M1_corr_Gordon.mat'];
% path_imaging_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M1.mat'];
path_demographics_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Table1.csv'];
path_dictionary_demographics_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'dictionary_tables1_and_2.csv'];
path_group_Design_Table_training=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Group_Design_Table.csv'];
path_imaging_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M2_corr_Gordon.mat'];
% path_imaging_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'M2.mat'];
path_demographics_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Table2.csv'];
path_dictionary_demographics_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'dictionary_tables1_and_2.csv'];
path_group_Design_Table_prediction=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Group_Design_Table.csv'];
path_parcellation_table=[repo_path fs 'readme' fs 'example_data' fs 'two_samples' fs 'Gordon_subcortical.csv'];
output_folder=[root_output_folder fs 'output_optimized_fconn_regression_Gordon'];
clear options
options.out_for_xval=3;
options.zscoring=[0];
options.resort_parcel_order=[2 13];%
options.resort_parcel_order=[];
options.N=1e4;
options.N_Null=1e4;
options.save_data=1;
options.scout_up_to=12;
options.symmetrize=1;
rng('shuffle')
%%

run_optimized_fconn_regression(path_imaging_training,...
    path_demographics_Table_training,...
    path_dictionary_demographics_Table_training,...
    path_group_Design_Table_training,...
    path_imaging_prediction,...
    path_demographics_Table_prediction,...
    path_dictionary_demographics_Table_prediction,...
    path_group_Design_Table_prediction,...
    path_parcellation_table,...
    'output_folder',output_folder,...
    'options',options)