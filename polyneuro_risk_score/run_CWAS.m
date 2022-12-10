function run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,varargin)
%% Run a connectome wide association study
init_time=datetime('now');
tStart = tic;   
%% WM
warning_message='Please use the functions run_BWAS instead of run_CWAS and run_PNRS instead of PNRS, since run_BWAS and run_PBS will be deleted';
display(warning_message);
%% Credits
% Oscar Miranda-Dominguez
% First line of code: Sep 29, 2020
%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=[pwd fs 'BWAS'];

% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
user_provided_model_flag=0;
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];

% Assume no parcellation table is provided
parcel_set_provided_flag=0;
path_parcellation_table=[];
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
            
        case 'path_parcellation_table'
            path_parcellation_table=varargin{q+1};
            parcel_set_provided_flag=1;
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;
%% Move to output_folder

local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
cd(output_folder)
%% Load imaging data
% path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\path_hcp.txt';
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

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(fconn,options);

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

%% Guess default model
if user_provided_model_flag==0
    model=get_default_model(T_column_names_for_outcome,T_column_names_for_id,T_column_names_for_between,T_column_names_for_within);
end
disp(model)
save_model(output_folder,model);
% filename=[output_folder filesep 'model.mat'];
% save(filename,'model');
%
% filename=strrep( filename , '.mat' , '.txt' );
% fid = fopen(filename,'wt');
% fprintf(fid, model);
% fclose(fid);



%% Select included imaging
brain_features=table2array(Y);
try
    IX=find_ix_in_header(demographics_Table,'consecutive_number');
    ix_to_include=demographics_Table{:,IX};
catch
    ix_to_include=[1:size(brain_features,1)]';
end
brain_features=brain_features(ix_to_include,:);

%% catch and remove nans
X=brain_features;
y=demographics_Table{:,T_column_names_for_outcome};

ix_nan_y=isnan(y);
ix_nan_x=sum(isnan(X),2)>0;

ix_nan=or(ix_nan_y,ix_nan_x);
n_nans=sum(ix_nan);
if n_nans>0
    y(ix_nan)=[];
    X(ix_nan,:)=[];
    brain_features(ix_nan,:)=[];
    disp(['Removing data from ' num2str(n_nans) ' participant(s) since data has nans'])
    disp('Removed participants:')
    disp(demographics_Table(ix_nan,:));
    demographics_Table(ix_nan,:)=[];
end
%% Read ids

if ~isempty(path_group_Design_Table)
    ids=demographics_Table(:,T_column_names_for_id);
else
    ids=table(ix_to_include);
end
%% run test
[cwas_estimates, PBScores_by_networks] = BWAS (model,...
    demographics_Table,...
    ids,...
    brain_features,....
    imaging_type, ...
    ind, ...
    sz,...
    options,...
    path_parcellation_table);
%% Colorize groups
%
% % 1. Get default colors
% [between_design,within_design]=colorize_design_groups(between_design,within_design);% 2. Check for missihg groups
% % 3. COlorize
% if Group_Color_Table_flag
%     %     path_Group_Color_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_4_time_points\Group_Color_Table.csv';
%     Group_Color_Table=readtable(path_Group_Color_Table);
%     [between_design,within_design]=colorize_design_groups(between_design,within_design,Group_Color_Table);
% end
% %% Load options
%
% options=update_options(options);
%
%% Calculate correlations table by networks

if ~isempty(PBScores_by_networks)
    make_figures_flag=0;
    path_save_scatter_plots=[pwd filesep 'figures' filesep 'scatter_plots' filesep 'by_networks'];
    scatters_score_outcome(demographics_Table,...
        path_group_Design_Table,...
        PBScores_by_networks,...
        [],...
        [],...
        path_save_scatter_plots,...
        make_figures_flag);
end

%% sum of betaweights by networks
if ~isempty(path_parcellation_table)
    path_roi_table=[pwd fs 'tables', fs 'mapping_brain_feature_index_2_ROIs.csv'];
    path_correlations_by_networks=[pwd fs 'tables', fs  'correlations_by_networks.csv'];
    
    depth=0;
    
%     path_betaweights_cifti=strtrim(ls([pwd fs 'ciftis', fs 'brain_feature' fs 'brain_feature_Estimate.*.nii']));
    path_betaweights_cifti=get_path_to_file([pwd fs 'ciftis', fs 'brain_feature'],depth,'brain_feature_Estimate.*.nii');
    path_betaweights_cifti=path_betaweights_cifti{1};
    
    
%     local_path_explained_variance_cifti=strtrim(ls([pwd fs 'ciftis'  fs 'explained_variance.*.nii']));
    local_path_explained_variance_cifti=get_path_to_file([pwd fs 'ciftis'],depth,'explained_variance.*.nii');
    local_path_explained_variance_cifti=local_path_explained_variance_cifti{1};
    
    
%     local_path_pvalue_cifti=strtrim(ls([pwd fs 'ciftis' fs 'brain_feature'  fs 'brain_feature_pValue.*.nii']));
    local_path_pvalue_cifti=get_path_to_file([pwd fs 'ciftis' fs 'brain_feature'],depth,'brain_feature_pValue.*.nii');
    local_path_pvalue_cifti=local_path_pvalue_cifti{1};
    
    
    
    output_folder_ciftis=[output_folder fs 'ciftis', fs 'brain_feature'];
    ciftify_sum_betaweights(path_betaweights_cifti,...
        local_path_explained_variance_cifti,...
        local_path_pvalue_cifti,...
        options,...
        output_folder_ciftis,...
        'path_parcellation_table',path_parcellation_table,...
        'path_roi_table',path_roi_table,...
        'path_correlations_by_networks',path_correlations_by_networks)
end
%% Move back to local path
cd(local_path)

%% Say goodbay!
tEnd = toc(tStart);
end_time=datetime('now');

disp('Done!')
disp(['job started on: ' datestr(init_time)])
disp(['job  ended  on: ' datestr(end_time)])
disp(['Total completion time: ' num2str(tEnd) ' seconds'])

display(warning_message);
if isdeployed
    exit
end