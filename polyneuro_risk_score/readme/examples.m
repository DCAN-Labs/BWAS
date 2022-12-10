%% Cross-sectional study, 1 outcome
% Using cortical thickness to predict changes in dual task cost
%
% Outcome: change in dual task cost
% -
%
% neuroimaging data: cortical thichness
%
% covariates:
% - between factors:
%   - age
%   - disease duration
%   - freezing status
%   - sex
%   - scanner
%
% - within factors
%   - none
% clear
fs=filesep;


ix_parcel=1;
clear parcel
parcel{1}='hcp';
parcel{2}='gordon';

if ix_parcel==1
    path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\path_hcp.txt';
    path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_pcaLutein_fconn\HCP_ColeAnticevic.csv';
    path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xtseries\HCP.ptseries.nii';
else
    path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\path_gordon.txt';
    path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_pcaLutein_fconn\Gordon.csv';
    path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xtseries\Gordon.ptseries.nii';
end

path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\demographics_Table.csv';
path_dictionary_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Dictionary_for_demographics_Table.csv';


path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Group_Design_Table_few.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Group_Design_Table.csv';


path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\define_options.m';
output_folder=['C:\Users\oscar\Downloads\CWAS\Example_x_sectional_cthickness_' parcel{ix_parcel}];
%% Pre-whithening
output_folder=['C:\Users\oscar\Downloads\CWAS\auto_prewhitening_'  parcel{ix_parcel}];
[fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder);

%% Case 1: Run only outcome | imaging
model='Delta_DTCgaitspeed ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\Example_x_sectional_cthickness_' parcel{ix_parcel} filesep 'case1_no_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)

%% Case 2: Run  outcome | imaging + covariates
model='Delta_DTCgaitspeed ~ brain_feature + Age_at_session + scanner_model + MoCA_score + MDS_UPDRSIII_score + 1';
output_folder=['C:\Users\oscar\Downloads\CWAS\Example_x_sectional_cthickness_' parcel{ix_parcel} filesep 'case2_yes_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)

%% Case 3: Run  outcome | imaging after prewhitening

model='Delta_DTCgaitspeed ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\Example_x_sectional_cthickness_' parcel{ix_parcel} filesep 'case3_prewhitening'];
path_imaging=fconn_R;
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)
%% Cross-sectional study, 1 outcome, within and between data

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

fs=filesep;
path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_fconn\fconn.mat';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_fconn\parcel.mat';
path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xconn\Bezgin.pconn.nii';

path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_fconn\demographcis_Table.csv';
path_dictionary_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_fconn\Dictionary_for_demographics_Table.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_fconn\Group_Design_Table.csv';


path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\define_options.m';



%% Case 1: Run only outcome | imaging
model='lutein_PCA1 ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional_lutein' filesep 'case1_no_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)

%% Case 2: Run  outcome | imaging + covariates
model='lutein_PCA1 ~ brain_feature+Diet+betacarotene_PCA1+1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional_lutein' filesep 'case2_yes_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)
%% Pre-whithening
% foo=fconn;
% foo(81:end,:,:)=[];
% foo(:,81:end,:)=[];
% whos fconn foo
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional_lutein\auto_prewhitening'];
[fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,...
    path_demographics_Table,...
    path_dictionary_demographics_Table,...
    path_group_Design_Table,...
    'output_folder',output_folder);
%% Case 3: Run  outcome | imaging after prewhitening

model='lutein_PCA1 ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional_lutein' filesep 'case3_prewhitening'];
path_imaging=fconn_R;
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)
%% Cross-sectional study, 1 outcome, within and between data

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

fs=filesep;
path_imaging='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\fconn.mat';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Gordon_subcortical.csv';
path_cifti_template='C:\Users\oscar\OneDrive\matlab_code\cifti_tools\templates\xtseries\Gordon_subcortical.pconn.nii';

path_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\subjects_table.csv';
path_dictionary_demographics_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\dictionary_subjects_table.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Group_Design_Table.csv';


path_Group_Color_Table ='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_anova\readme\Data\Example_3_groups_xsectional\Group_Color_Table.csv';
path_options='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\define_options.m';



%% Case 1: Run only outcome | imaging
model='fake_score ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional' filesep 'case1_no_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)

%% Case 2: Run  outcome | imaging + covariates
model='fake_score ~ group + brain_feature + 1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional' filesep 'case2_yes_covariates'];
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)
%% Pre-whithening
% foo=fconn;
% foo(81:end,:,:)=[];
% foo(:,81:end,:)=[];
% whos fconn foo
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional\auto_prewhitening'];
[fconn_R,model, ranovatbl] = run_fconn_residualizer(path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,...
    'output_folder',output_folder);
%% Case 3: Run  outcome | imaging after prewhitening

model='fake_score ~ brain_feature-1';
output_folder=['C:\Users\oscar\Downloads\CWAS\fconn_xsectional' filesep 'case3_prewhitening'];
path_imaging=fconn_R;
run_CWAS (path_imaging,path_demographics_Table,path_dictionary_demographics_Table,path_group_Design_Table,path_parcellation_table,...
    'output_folder',output_folder,...
    'model',model)
%% Cross-sectional study, several outcomes

% Outcome: UPDRS and moca scores
% -
%
% neuroimaging data: cortical thickness
%
% covariates:
% - between factors:
%   - age
%   - disease duration
%   - freezing status
%   - sex
%   - scanner
%
% - within factors
%   - none