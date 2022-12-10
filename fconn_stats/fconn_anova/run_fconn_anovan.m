function run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,varargin)

%% run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,varargin)

% run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,varargin)
%%
% repo_folder='C:\Users\oscar\Box\UCDavis_conData';
% fs=filesep;
% fconn_path=[repo_folder fs 'output_GUI_env' fs ...
%     'connectotyping' fs ...
%     'Functional' fs ...
%     'path_sbj_MCMethod_power_2014_FD_only_FD_th_0_40_min_frames_130_skip_frames_5_TRseconds_2_30' fs ...
%     'BezginRM2008_timeseries.ptseries' fs ...
%     'fconn_384_frames.mat'];
% path_imaging=fconn_path;
% path_demographics_Table='C:\Users\oscar\Box\UCDavis_conData\True_groups_04.csv';
% path_group_Design_Table='C:\Users\oscar\Box\UCDavis_conData\Group_Design_Table.csv';
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Bezgin.csv';
% path_Group_Color_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Group_Color_Table.csv';
% run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table)
% %
% run_fconn_anovan(path_imaging,path_demographics_Table,path_group_Design_Table,path_parcellation_table,...
% 'path_Group_Color_Table',path_Group_Color_Table);
%% Credits
% Oscar Miranda-Dominguez
% First line of code: Sep 3, 2020

%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=[pwd fs 'output_fconn_anovan'];

% Define default options
options = [];
user_provided_options_flag=0;

% Use default within model that also include connections
WM=[];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'path_Group_Color_Table'
            path_Group_Color_Table=varargin{q+1};
            Group_Color_Table_flag=1;
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;
            
        case 'WithinModel'
            WM=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;

%% Load imaging data
% path_imaging='C:\Users\oscar\Box\UCDavis_conData\output_GUI_env\connectotyping\Functional\path_sbj_MCMethod_power_2014_FD_only_FD_th_0_40_min_frames_130_skip_frames_5_TRseconds_2_30\BezginRM2008_timeseries.ptseries\fconn_384_frames.mat';
fconn = load_imaging_data(path_imaging);

%% Symmetrize, if fconn
% Correlation matrices are already symmetrized. THis step is implemented
% for connectotyping. When applied to correlation matrices, there is no
% effect, just a few miliseconds wasted
sz=size(fconn);
if numel(sz)==3
    fconn=symmetryze_M(fconn);
end

%% Load demographics table
% path_demographics_Table='C:\Users\oscar\Box\UCDavis_conData\True_groups_04.csv';
demographics_Table=readtable(path_demographics_Table);
% "C:\Users\oscar\Box\UCDavis_conData\True_groups_04.csv"

%% Load group_Design_Table
% path_group_Design_Table='C:\Users\oscar\Box\UCDavis_conData\Group_Design_Table.csv';
group_Design_Table=readtable(path_group_Design_Table);



%% Load parcellation schema
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Bezgin.csv';
parcel=loadParcel(path_parcellation_table);
%% Prep group design for fconn_rm_anovan

T_column_names_for_between = get_variable_design(group_Design_Table,'between');
T_column_names_for_within = get_variable_design(group_Design_Table,'within');
T_column_names_for_id = get_variable_design(group_Design_Table,'id');
[between_design, within_design, M, resorted_T,ix]=local_prep_for_fconn_rm_anovan(demographics_Table,T_column_names_for_between,T_column_names_for_within,fconn,T_column_names_for_id);
%% Colorize groups

% 1. Get default colors
[between_design,within_design]=colorize_design_groups(between_design,within_design);% 2. Check for missihg groups
% 3. COlorize
if Group_Color_Table_flag
    %     path_Group_Color_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Group_Color_Table.csv';
    Group_Color_Table=readtable(path_Group_Color_Table);
    [between_design,within_design]=colorize_design_groups(between_design,within_design,Group_Color_Table);
end
%% Load options

options=update_options(options);
%% Move to output_folder

local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
cd(output_folder)
%% Run it
[main_table_long, global_stats]=fconn_rm_anovan(M,parcel,between_design,within_design,options,WM);

%% Move back to local path
cd(local_path)