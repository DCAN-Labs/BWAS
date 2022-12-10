function PBScores=run_PNRS(path_imaging,path_betaweights,path_Rsquared,varargin)

%% Oscar Miranda-Dominguez
% First line of code: Oct 12, 2020
%% run polyconn score
init_time=datetime('now');
tStart = tic;   
%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=[pwd fs 'PNRS'];

% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];
options.N_null=400;

% Define path_demographics_Table
path_demographics_Table_flag=0;

%
path_Group_Color_Table=[];

% path_group_Design_Table
path_group_Design_Table=[];

% Assume no parcellation table is provided
parcel_set_provided_flag=0;
path_parcellation_table=[];

% Assume no use of networks table from BWAS
provided_path_reference_table_by_networks_flag=0;
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
            
        case 'path_demographics_Table'
            path_demographics_Table=varargin{q+1};
            path_demographics_Table_flag=1;
            q = q+1;
            
        case 'path_dictionary_demographics_Table'
            path_dictionary_demographics_Table=varargin{q+1};
            path_demographics_Table_flag=1;
            q = q+1;
            
        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;
            
        case 'path_group_Design_Table'
            path_group_Design_Table=varargin{q+1};
            q = q+1;
            
        case 'path_parcellation_table'
            path_parcellation_table=varargin{q+1};
            parcel_set_provided_flag=1;
            q = q+1;
            
        case 'path_reference_table_by_networks'
            path_reference_table_by_networks=varargin{q+1};
            provided_path_reference_table_by_networks_flag=1;
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
user_provided_options_flag=user_provided_options_flag==1;
path_demographics_Table_flag=path_demographics_Table_flag==1;
parcel_set_provided_flag=parcel_set_provided_flag==1;
provided_path_reference_table_by_networks_flag=provided_path_reference_table_by_networks_flag==1;
%% Move to output_folder

local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
cd(output_folder)
%% MAke default correlations_by_networks file
if provided_path_reference_table_by_networks_flag==0
    filename='correlations_by_networks.csv';
    path_reference_table_by_networks=[pwd filesep 'tables' filesep filename];
end

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

%% Read group design table
if ~isempty(path_group_Design_Table)
    group_Design_Table=readtable(path_group_Design_Table);
    T_column_names_for_id = get_variable_design(group_Design_Table,'id');
    T_column_names_for_outcome = get_variable_design(group_Design_Table,'outcome');
    outcome=demographics_Table{:,T_column_names_for_outcome};
    ids=demographics_Table(:,T_column_names_for_id);
else
%     N_subjects=size(fconn);
%     N_subjects=N_subjects(end);
    N_subjects=size(Y,1);
    ids=table(ix_to_include);
    outcome=ones(N_subjects,1);
end
%% Load beta weigths
betas=readtable(path_betaweights);

%% Load R qsquared
R=readtable(path_Rsquared);

%% catch and remove nans
brain_features=table2array(Y);
ix_nan_y=isnan(outcome);
ix_nan_x=sum(isnan(brain_features),2)>0;

ix_nan=or(ix_nan_y,ix_nan_x);
n_nans=sum(ix_nan);
if n_nans>0
    outcome(ix_nan)=[];
    Y(ix_nan,:)=[];
    brain_features(ix_nan,:)=[];
    disp(['Removing data from ' num2str(n_nans) ' participant(s) since data has nans'])
    disp('Removed participants:')
    disp(demographics_Table(ix_nan,:));
    demographics_Table(ix_nan,:)=[];
    ids(ix_nan,:)=[];
end

%% Make W_V figure
output_folder_W_V=[output_folder fs 'figures' fs 'Weights_ExplainedVariance'];
patch_W_V_across_samples(brain_features,...
    betas,...
    outcome,...
    output_folder_W_V,...
    R)
%% Calculate scores

[PBScores, IX, PBScores_null]= PNRS(Y,...
    R,...
    betas,...
    ids,...
    imaging_type,...
    ind,...
    options);

%% Calculate scatter plot if demographics table is provided
if path_demographics_Table_flag
    
    outcome=scatters_score_outcome(demographics_Table,...
        path_group_Design_Table,...
        PBScores,...
        path_Group_Color_Table,...
        PBScores_null);
    
end

%% Do it by networks

%% Load parcellation schema if provided
if parcel_set_provided_flag==1
    [PBScores_by_networks, IX_networks] = PNRS(Y,...
        R,...
        betas,...
        ids,...
        imaging_type,...
        ind,...
        options,...
        'path_parcellation_table',path_parcellation_table);
    if path_demographics_Table_flag
        path_save_scatter_plots=[pwd filesep 'figures' filesep 'scatter_plots' filesep 'by_networks'];
        scatters_score_outcome(demographics_Table,...
            path_group_Design_Table,...
            PBScores_by_networks,...
            path_Group_Color_Table,...
            [],...
            path_save_scatter_plots);
        %         scatters_score_outcome(path_dictionary_demographics_Table,path_demographics_Table,path_group_Design_Table,PBScores_by_networks,path_Group_Color_Table,...
        %             PBScores_by_networks_null)
        
        orig_sort_network_names=PBScores_by_networks.Properties.VariableNames(2:end);
        make_cummulative_and_null_by_network(IX_networks,...
            Y,...
            ids,...
            orig_sort_network_names,...
            betas,...
            outcome,...
            options,...
            path_reference_table_by_networks)
    end
end
%% 
cd(local_path)
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