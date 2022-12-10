%% Basic example

fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\fconn_63_scanns.mat';
path_imaging=fconn_path;
path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\table_subjects.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\parcel.mat';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\basic_example';

run_fconn_anovan(path_imaging,...
    path_demographics_Table,...
    path_group_Design_Table,...
    path_parcellation_table,...
    'output_folder',output_folder);
%%


path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Basic_example\define_options.m';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\basic_example_with_customized_colors';
run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'options',path_options,...
    'output_folder',output_folder);
%% Longitudinal, 3 groups, 3 time points
repo_folder='C:\Users\oscar\Box\UCDavis_conData';
fs=filesep;
fconn_path=[repo_folder fs 'output_GUI_env' fs ...
    'connectotyping' fs ...
    'Functional' fs ...
    'path_sbj_MCMethod_power_2014_FD_only_FD_th_0_40_min_frames_130_skip_frames_5_TRseconds_2_30' fs ...
    'BezginRM2008_timeseries.ptseries' fs ...
    'fconn_384_frames.mat'];
fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\fconn_63_scanns.mat';
path_imaging=fconn_path;
path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\table_subjects_between_within_design.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\parcel.mat';
path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\define_options.m';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\Example_3_groups_3_timepoints';
run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'options',path_options,...
    'output_folder',output_folder);
%% Longitudinal, 3 groups, 3 time points, indicating WithinModel
repo_folder='C:\Users\oscar\Box\UCDavis_conData';
fs=filesep;
fconn_path=[repo_folder fs 'output_GUI_env' fs ...
    'connectotyping' fs ...
    'Functional' fs ...
    'path_sbj_MCMethod_power_2014_FD_only_FD_th_0_40_min_frames_130_skip_frames_5_TRseconds_2_30' fs ...
    'BezginRM2008_timeseries.ptseries' fs ...
    'fconn_384_frames.mat'];
fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\fconn_63_scanns.mat';
path_imaging=fconn_path;
path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\table_subjects_between_within_design.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\parcel.mat';
path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\define_options.m';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\Example_3_groups_3_timepoints_custom_WithinModel';
WithinModel='Networks*age';
run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'options',path_options,...
    'output_folder',output_folder,...
    'WithinModel',WithinModel);


%% Longitudinal, 3 groups, 3 time points, indicating WithinModel, comparing correction methods

% Define options for repeated measures anova n
for correction_type=1:5
    % Correction for multiple comparisons
    % correction_type:
    % 1}='tukey-kramer';
    % 2}='dunn-sidak';
    % 3}='bonferroni';
    % 4}='scheffe';
    % 5}='lsd';
    
    corr_type{1}='tukey-kramer';
    corr_type{2}='dunn-sidak';
    corr_type{3}='bonferroni';
    corr_type{4}='scheffe';
    corr_type{5}='lsd';
    
    options.correction_type=correction_type;
    
    % Here you define if you want to make the analysis on a few networks or
    % not. It acceots as input a vector with the functional networks you want
    % to include. IF not provided, it uses all the available networks. You can
    % also us as input '[]' to use all the networks
    options.resort_parcel_order=[];
    % options.resort_parcel_order=[5 6 7];
    
    % Apply Fisher_Z_transform to connectivity values. Use 1 or 0
    options.calculate_Fisher_Z_transform=0;
    
    % Apply an optimized box_cox transform to the data.
    options.boxcox_transform=0;
    
    options.save_figures=1;
    options.display_figures=1;
    % options.plot_uncorrected_NN_other_factor=1;
    
    % p-value threshold used for visualization
    options.p_th=[0.05];
    
    % show numerical scale for connectivity values (y-axis)
    options.show_y_scale=1;
    
    % options.filename_to_save_all_before_plotting
    options.filename_to_save_all_before_plotting='all_results';
    
    options.bar_lengh_times_standard_error=1.15;
    
    fs=filesep;
    fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\fconn_63_scanns.mat';
    path_imaging=fconn_path;
    path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\table_subjects_between_within_design.csv';
    path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Design_Table.csv';
    path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\parcel.mat';
    path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Color_Table.csv';
    output_folder=['C:\Users\oscar\Downloads\output_fconn_anovan\Example_3_groups_3_timepoints_correction_type_' corr_type{correction_type}];
    WithinModel='Networks*age';
    run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
        'path_Group_Color_Table',path_Group_Color_Table,...
        'options',options,...
        'output_folder',output_folder,...
        'WithinModel',WithinModel);
end
%% using boxcox 
for correction_type=1:55
    % Correction for multiple comparisons
    % correction_type:
    % 1}='tukey-kramer';
    % 2}='dunn-sidak';
    % 3}='bonferroni';
    % 4}='scheffe';
    % 5}='lsd';
    
    corr_type{1}='tukey-kramer';
    corr_type{2}='dunn-sidak';
    corr_type{3}='bonferroni';
    corr_type{4}='scheffe';
    corr_type{5}='lsd';
    
    options.correction_type=correction_type;
    
    % Here you define if you want to make the analysis on a few networks or
    % not. It acceots as input a vector with the functional networks you want
    % to include. IF not provided, it uses all the available networks. You can
    % also us as input '[]' to use all the networks
    options.resort_parcel_order=[];
    % options.resort_parcel_order=[5 6 7];
    
    % Apply Fisher_Z_transform to connectivity values. Use 1 or 0
    options.calculate_Fisher_Z_transform=0;
    
    % Apply an optimized box_cox transform to the data.
    options.boxcox_transform=1;
    
    options.save_figures=1;
    options.display_figures=1;
    % options.plot_uncorrected_NN_other_factor=1;
    
    % p-value threshold used for visualization
    options.p_th=[0.05];
    
    % show numerical scale for connectivity values (y-axis)
    options.show_y_scale=1;
    
    % options.filename_to_save_all_before_plotting
    options.filename_to_save_all_before_plotting='all_results';
    
    
    
    fs=filesep;
    fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\fconn_63_scanns.mat';
    path_imaging=fconn_path;
    path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\table_subjects_between_within_design.csv';
    path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Design_Table.csv';
    path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\parcel.mat';
    path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Bezgin_3_groups_3_timepoints\Group_Color_Table.csv';
    output_folder=['C:\Users\oscar\Downloads\output_fconn_anovan\Example_3_groups_3_timepoints_correction_type_' corr_type{correction_type} '_with_boxcox'];
    WithinModel='Networks*age';
    run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
        'path_Group_Color_Table',path_Group_Color_Table,...
        'options',options,...
        'output_folder',output_folder,...
        'WithinModel',WithinModel);
end

%% Example 4 time points
clear
repo_folder='C:\Users\oscar\Box\UCDavis_conData';
fs=filesep;

% Mandatory inputs
path_imaging='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Zfconn_407_frames.mat';
path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\subjects_table.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\parcel.mat';

% Optional inputs
path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\define_options.m';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\Example_4_time_points';

% Do it!
run_fconn_anovan(path_imaging,...
    path_demographics_Table,...
    path_group_Design_Table,...
    path_parcellation_table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'options',path_options,...
    'output_folder',output_folder);

%% Example cross-sectional
clear
fs=filesep;

fconn_path='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\fconn.mat';
path_imaging=fconn_path;
path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\subjects_table.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Gordon_subcortical.csv';
path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\define_options.m';
output_folder='C:\Users\oscar\Downloads\output_fconn_anovan\Example_3_groups_xsectional';
run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'options',path_options,...
    'output_folder',output_folder);
%%
run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
'path_Group_Color_Table',path_Group_Color_Table);
%% To download dependancies
% https://gitlab.com/Fair_lab/fconn_stats
% https://gitlab.com/Fair_lab/tables_handling
% https://gitlab.com/Fair_lab/fconn_matrices_tools.git
% https://gitlab.com/Fair_lab/generic_for_functions.git
% https://gitlab.com/Fair_lab/text_manipulation.git
%% Define who am I
if ispc
    this_computer='OscarDell';
else
    this_computer='OscarMac';
end


switch this_computer
    case 'OscarDell'
        root_code_path='C:\Users\Oscar\OneDrive\matlab_code';
    case 'OscarMac'
        root_code_path='/Users/miran045/OneDrive/matlab_code';
end
%% add dependancies

fs=filesep;
addpath(genpath([root_code_path fs 'fconn_stats']))
addpath(genpath([root_code_path fs 'tables_handling']))
addpath(genpath([root_code_path fs 'fconn_matrices_tools']))
addpath(genpath([root_code_path fs 'generic_for_functions']))
addpath(genpath([root_code_path fs 'text_manipulation']))
%% Assumptions
% - You have connectivity matrices made via GUI_environments
% - Data has been parcellated and you have a "parcel" object with network
% assignments for each ROI
% - you know the order of the participants: id, group and time-point
% - it is easier to have a table with assignments of


%% Example using 3 time points

switch this_computer
    case 'OscarDell'
        repo_folder='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme';
    case 'OscarMac'
        repo_folder='C:\Users\Oscar\Box Sync\fconn_stats_Roza\code\fconn_stats\fconn_anova\readme';
end

repo_folder=[root_code_path fs 'fconn_stats' fs 'fconn_anova' fs 'readme' fs 'Data' fs 'Example_3_time_points'];
% cd(repo_folder)
load([repo_folder filesep 'for_doc_rm_anovan.mat'])
%% Import table indicating subjects's grouping (between and within design)
% YOu need a table indicating the grouping for each sunject. THe order of
% the data should be as saved in the connectivity matrices made via the
% GUI_environments.
%
% In this example, the file "table_subjects_between_within_design.csv' has
% the assignment. The file
% 'dictionary_table_subjects_between_within_design.csv' indicates data
% type.
%
% This data is imported using the function import_tidyData_with_Dictionary
Dictionary_filename='dictionary_table_subjects_between_within_design.csv';
tidyData_filename='table_subjects_between_within_design.csv';
% tidyData_filename='table_subjects_between_within_design_4g.csv';
[t, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);
t
%% Use the table to define between_design and within_design
% consecutive_number=T.consecutive_number;
% FC=fconn(:,:,consecutive_number);
T_column_names_for_between='Diet';
T_column_names_for_within='age';
[between_design, within_design, M, resorted_T,ix]=local_prep_for_fconn_rm_anovan(t,T_column_names_for_between,T_column_names_for_within,fconn);
%% You can add colors for the traces associated to each grouping

within_design.subgroups(1).color=[106,61,154]/255;
within_design.subgroups(2).color=[230,171,2]/255;
within_design.subgroups(3).color=[231,41,138]/255;

%% Take a look at the assignment of ROIs and networks
%
% The variable 'combined_parcel' is a matlab structure that gorups ROIs by
% functional networks
%
% The function summarize_parcel summarizes associations
summarize_parcel(combined_parcel)
%% Define options for repeated measures anova n

% Correction for multiple comparisons
% correction_type:
% 1}='tukey-kramer';
% 2}='dunn-sidak';
% 3}='bonferroni';
% 4}='scheffe';
% 5}='lsd';
options.correction_type=2;

% Here you define if you want to make the analysis on a few networks or
% not. It acceots as input a vector with the functional networks you want
% to include. IF not provided, it uses all the available networks. You can
% also us as input '[]' to use all the networks
% options.resort_parcel_order=[];
options.resort_parcel_order=[5 6 7];
% options.resort_parcel_order=[];

% Apply Fisher_Z_transform to connectivity values. Use 1 or 0
options.calculate_Fisher_Z_transform=0;

% Apply an optimized box_cox transform to the data.
options.boxcox_transform=0;

options.save_figures=1;
options.display_figures=1;
% options.plot_uncorrected_NN_other_factor=1;

% p-value threshold used for visualization
options.p_th=[0.05];

% show numerical scale for connectivity values (y-axis)
options.show_y_scale=1;

%% Make a new folder and go there to save results

wd=[repo_folder fs 'three_time_points'];
% wd=[repo_folder fs 'three_time_points' fs 'from_windows'];

% update this to your local machine
mkdir(wd)
cd(wd)
%% Do the main analysis
[main_table_long, global_stats]=fconn_rm_anovan(M,combined_parcel,between_design,within_design,options);


%% Post hocs
% global_stats=run_posthoc_3F(global_stats);

%% More posthocs
% posthoc_3F_RM_by_connections=run_posthoc_3F_RM_by_connections(global_stats,between_design);
% global_stats.posthoc_3F_RM_by_connections=posthoc_3F_RM_by_connections;
