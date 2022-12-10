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
foo=which('CWAS');
[repo_path , name , ext ] = fileparts(foo);
repo_path;

%% Define root output folder
% Update accordingly
if ispc
root_output_folder='C:\Users\oscar\Downloads';
else
    root_output_folder='/Users/miran045/Desktop/polyneuro_risk_score';
end

%% Define paths to the data

% path to the imaging data
path_imaging=[repo_path  fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'path_hcp.txt'];
% path_parcellation_table=[repo_path fs 'data' fs 'xsectional_1_outcome_pcaLutein_fconn' fs 'HCP_ColeAnticevic.csv'];
% path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xtseries\HCP.ptseries.nii';

% Path to damographics table and corresponding dictionary
path_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'demographics_Table.csv'];
path_dictionary_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Dictionary_for_demographics_Table.csv'];

% Path to group design table
path_group_Design_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Group_Design_Table.csv'];

% Path to group color table
path_Group_Color_Table =[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Group_Color_Table.csv'];

% path to options file
path_options=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'define_options.m'];

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'basic_example' fs 'CWAS'];

%% Estimate the beta-weights
% Define model to fit
model='Delta_DTCgaitspeed ~ brain_feature-1';
run_CWAS (path_imaging,...
    path_demographics_Table,...
    path_dictionary_demographics_Table,...
    path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)
%% Explore outputs
% blah blah blah

% The betaweights are saved in the folder 
[output_folder fs 'tables' fs 'brain_feature.csv'];

%% Use the calculated beta-weighs to estimate risk

% Ideally beta-weights should be used to calculate risk in an independent
% dataset. For testing purposes we are using the same dataset to estimate
% beta-weights and to estimate risk

path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'basic_example' fs 'PBS'];


PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder);
% PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
%     'output_folder',output_folder,...
%     'path_parcellation_table',path_parcellation_table);
%% Exploring outputs

%% Calculate risk and make scatters 

output_folder=[root_output_folder fs 'basic_example' fs 'PBS_plus_scatters'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table);

%% Customizing colors in scatters

output_folder=[root_output_folder fs 'basic_example' fs 'PBS_plus_scatters_custom_colors'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);
%% Going deeper estimating beta-weights 

% Testing the three different ways to fit models

%

% Outcome: PCA lutein score
% -
%
% neuroimaging data: functional connectivity
%
% covariates:
% - between factors:
%   - age
%
% - within factors
%   - diet
%
%%
foo=which('CWAS');
[repo_path , name , ext ] = fileparts(foo);
repo_path;

fs=filesep;
path_imaging=[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'fconn.mat'];
path_parcellation_table=[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'parcel.mat'];

path_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'demographcis_Table.csv'];
path_dictionary_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'Dictionary_for_demographics_Table.csv'];
path_group_Design_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'Group_Design_Table.csv'];


path_Group_Color_Table =[repo_path fs 'data' fs 'xsectional_1_outcome_fconn' fs 'Group_Color_Table.csv'];

path_options=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'define_options.m'];


%% Case 1: Run only outcome | imaging
model='lutein_PCA1 ~ brain_feature+betacarotene_PCA1+Diet+1';
model='lutein_PCA1 ~ brain_feature-1';
% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case1_no_covariates' fs 'CWAS'];

% Calculate beta-weights
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model,...
    'path_parcellation_table',path_parcellation_table)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
path_reference_table_by_networks=[output_folder fs 'tables' fs 'correlations_by_networks.csv'];


% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case1_no_covariates' fs 'PBS'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'path_parcellation_table',path_parcellation_table,...
    'path_reference_table_by_networks',path_reference_table_by_networks);

%% Case 2: Run  outcome | imaging + covariates
model='lutein_PCA1 ~ brain_feature+Diet+betacarotene_PCA1+1';

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case2_yes_covariates' fs 'CWAS'];

run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case2_yes_covariates' fs 'PBS'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);


%% Case 3: Run  outcome | imaging after prewhitening
model='lutein_PCA1 ~ brain_feature+Diet+betacarotene_PCA1+1';
output_folder=[root_output_folder fs 'going_deeper' fs 'case3_prewhitening' fs 'CWAS' fs 'prewhithen_data'];

% pre-whitening
[fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder);

% Calculate beta weigths on pre-whiten data (fconn_R)
model='lutein_PCA1 ~ brain_feature-1';
path_imaging=fconn_R;

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case3_prewhitening' fs 'CWAS'];

run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];

% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper' fs 'case3_prewhitening' fs 'PBS'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);

%% Repeating 3 cases using cortical thickness

%% Define paths to the data

if ispc
root_output_folder='C:\Users\oscar\Downloads';
else
    root_output_folder='/Users/miran045/Desktop/polyneuro_risk_score';
end


fs=filesep;

% path to the imaging data
path_imaging=[repo_path  fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'path_hcp.txt'];
% path_parcellation_table=[repo_path fs 'data' fs 'xsectional_1_outcome_pcaLutein_fconn' fs 'HCP_ColeAnticevic.csv'];
% path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xtseries\HCP.ptseries.nii';

% Path to damographics table and corresponding dictionary
path_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'demographics_Table.csv'];
path_dictionary_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Dictionary_for_demographics_Table.csv'];

% Path to group design table
path_group_Design_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Group_Design_Table.csv'];

% Path to group color table
path_Group_Color_Table =[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Group_Color_Table.csv'];

% path to options file
path_options=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'define_options.m'];

%% Case 1: Run only outcome | imaging
% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case1_no_covariates' fs 'CWAS'];

model='Delta_DTCgaitspeed ~ brain_feature-1';
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case1_no_covariates' fs 'PBS'];


PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);

%% Case 2: Run  outcome | imaging + covariates
model='Delta_DTCgaitspeed ~ brain_feature + Age_at_session + scanner_model + MoCA_score + MDS_UPDRSIII_score + 1';
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case2_yes_covariates' fs 'CWAS'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case2_yes_covariates' fs 'PBS'];


PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);


%% Case 3: Run  outcome | imaging after prewhitening

% Pre-whithening
model='Delta_DTCgaitspeed ~ brain_feature-1';
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case3_prewhitening' fs 'CWAS'];
[fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder);


% Calculate beta weigths on pre-whiten data (fconn_R)
model='Delta_DTCgaitspeed ~ brain_feature-1';
path_imaging=fconn_R;

run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder,...
    'model',model)

% calculate scores
path_betaweights=[output_folder fs 'tables' fs 'brain_feature.csv'];
path_Rsquared=[output_folder fs 'tables' fs 'Rsquared.csv'];
% path_imaging will not be updated since we are applying the
% betaweights to the same dataset. Non-optimal but this is just an example

% Define output folder to save outputs (output path to your system)
output_folder=[root_output_folder fs 'going_deeper_example2' fs 'case3_prewhitening' fs 'PBS'];

PBScores=run_PBS(path_imaging,path_betaweights,path_Rsquared,...
    'output_folder',output_folder,...
    'path_demographics_Table',path_demographics_Table,...
    'path_dictionary_demographics_Table',path_dictionary_demographics_Table,...
    'path_group_Design_Table',path_group_Design_Table,...
    'path_Group_Color_Table',path_Group_Color_Table);
