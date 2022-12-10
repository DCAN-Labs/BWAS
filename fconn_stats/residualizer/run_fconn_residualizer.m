function [fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,varargin)

%% Output:
%   - Residuals
%   - Test
init_time=datetime('now');
tStart = tic;   
%% Credits
% Oscar Miranda-Dominguez
% First line of code: Octuber 5, 2020

%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=[pwd fs 'output_fconn_residualizer'];

% Define default options
user_provided_options_flag=0;
options.symmetrize=1;
options.only_consider_significant_covariates_in_mass_univariate=0;

% Indicate model is not provided
user_provided_model_flag=0;% If no model provided, it will test all the default

% residualizer method
residualizer_method='repeated_measures';
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
            
            
        case 'model'
            user_provided_model_flag=1;
            model=varargin{q+1};
            q = q+1;
            
        case 'residualizer_method'
            residualizer_method=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;
user_provided_model_flag=user_provided_model_flag==1;
%% Make output folder
local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
cd(output_folder)
%% Load imaging data
% path_imaging='C:\Users\oscar\Box\UCDavis_conData\output_GUI_env\connectotyping\Functional\path_sbj_MCMethod_power_2014_FD_only_FD_th_0_40_min_frames_130_skip_frames_5_TRseconds_2_30\BezginRM2008_timeseries.ptseries\fconn_384_frames.mat';
fconn = load_imaging_data(path_imaging);
%% Symmetrize, if fconn
% Correlation matrices are already symmetrized. THis step is implemented
% for connectotyping. When applied to correlation matrices, there is no
% effect, just a few miliseconds wasted
sz=size(fconn);
if numel(sz)==3
    if options.symmetrize==1
        fconn=symmetryze_M(fconn);
    end
end
%% Tabify imaging data

[Y, imaging_type, ind, sz, BrainFeatures_table] = fconn2table(fconn,options);
%% Load demographics table

% demographics_Table=readtable(path_demographics_Table, 'ReadVariableNames',true);
% demographics_Table=readtable(path_demographics_Table);
% demographics_Table=readmatrix(path_demographics_Table);

% path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\demographics_Table.csv';
% path_dictionary_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Dictionary_for_demographics_Table.csv';%
[demographics_Table, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table);

%% Load group_Design_Table
% path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Group_Design_Table.csv';
group_Design_Table=readtable(path_group_Design_Table);

%% Define demographics table headers by type

T_column_names_for_between = get_variable_design(group_Design_Table,'between');
T_column_names_for_within = get_variable_design(group_Design_Table,'within');
T_column_names_for_outcome = get_variable_design(group_Design_Table,'outcome');
T_column_names_for_id = get_variable_design(group_Design_Table,'id');
%% Select included imaging
brain_features=table2array(Y);
try
    
    [demographics_Table, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table);
    IX=find_ix_in_header(demographics_Table,'consecutive_number');
    ix_to_include=demographics_Table{:,IX};
catch
    ix_to_include=[1:size(brain_features,1)]';
end
Y=Y(ix_to_include,:);

%% Concatenate imaging and non-imaging data

catT=[demographics_Table Y];

%% select_residualizer and calculate residuals
switch residualizer_method
    case 'repeated_measures'
        [R, model,ranovatbl]=residuals_by_repeated_measures(user_provided_model_flag,...
            ind,...
            T_column_names_for_id,...
            T_column_names_for_between,...
            T_column_names_for_within,...
            catT,...
            BrainFeatures_table,...
            output_folder,...
            fs,...
            Y,...
            options);
        
    case 'mass_univariate'
        [R, model,ranovatbl]=residuals_by_mass_univariate(user_provided_model_flag,...
            ind,...
            T_column_names_for_id,...
            T_column_names_for_between,...
            T_column_names_for_within,...
            catT,...
            BrainFeatures_table,...
            output_folder,...
            fs,...
            Y,...
            options);
end

%% Reshape residuals as fconn was provided

fconn_R = table2fconn(R,options, imaging_type, ind, sz);
%% Reformat as provided
fconn_R=blow_fconn_as_provided(fconn,fconn_R,ix_to_include,imaging_type);

%% Save Residuals

save([output_folder fs 'residuals.mat'],'fconn_R','-v7.3')
% save([output_folder fs 'model.mat'],'model')
% fid = fopen([output_folder fs 'model.txt'],'wt');
% fprintf(fid, model);
% fclose(fid);


%% Say goodbay!
tEnd = toc(tStart);
end_time=datetime('now');

disp('Done!')
disp(['job started on: ' datestr(init_time)])
disp(['job  ended  on: ' datestr(end_time)])
disp(['Total completion time: ' num2str(tEnd) ' seconds'])
if isdeployed
    exit
end