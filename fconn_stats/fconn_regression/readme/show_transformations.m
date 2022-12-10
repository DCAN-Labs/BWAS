
%%
path_imaging='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\M1_corr.mat';
path_demographics_Table='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Table1.csv';
path_dictionary_demographics_Table='C:\Users\Oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\dictionary_tables1_and_2.csv';
path_group_Design_Table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\Group_Design_Table.csv';
path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_stats\fconn_regression\readme\example_data\two_samples\HCP_ColeAnticevic_combined_Visual_PD25.csv';
options.resort_parcel_order=[7 13];%
options.symmetrize=1;
%%
%% Load parcellation schema
% path_parcellation_table='C:\Users\oscar\OneDrive\matlab_code\fconn_matrices_tools\parcel_schemas\Bezgin.csv';
parcel=loadParcel(path_parcellation_table);
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
%% Load imaging data
% path_imaging='C:\Users\oscar\OneDrive\matlab_code\polyneuro_risk_score\data\xsectional_1_outcome_cthickness\path_hcp.txt';

fconn = load_imaging_data(path_imaging);
if isinf(fconn(1))
    fconn=tanh(fconn);
end
%% Get fconn as table

[X, imaging_type,ind] = get_fconn_as_table(fconn,demographics_Table,options);

%% Get outcome

T_column_names_for_outcome = get_variable_design(group_Design_Table,'outcome');
IX_column_names_for_outcome = find_ix_in_header(demographics_Table,T_column_names_for_outcome);
y=demographics_Table{:,T_column_names_for_outcome};

%% catch and remove nans
ix_nan_y=isnan(y);
ix_nan_x=sum(isnan(X),2)>0;
ix_nan=or(ix_nan_y,ix_nan_x);
n_nans=sum(ix_nan);
if n_nans>0
    y(ix_nan)=[];
    X(ix_nan,:)=[];
    disp(['Removing data from ' num2str(n_nans) ' participant(s) since data has nans'])
    disp('Removed participants:')
    disp(demographics_Table(ix_nan,:));
end
%% Make headers

network_names=get_network_names(parcel,imaging_type,ind,options);
%% Select required networks

ix=censor_networks(network_names,parcel,imaging_type,options);
M=X(:,ix);
within_headers=network_names(ix,:);
%% apply transformations
T_column_names_for_between = get_variable_design(group_Design_Table,'between');
IX_column_names_for_between = find_ix_in_header(demographics_Table,T_column_names_for_between);
if isnan(IX_column_names_for_between)
    IX_column_names_for_between=[];
end
between_groups=demographics_Table(:,IX_column_names_for_between);
if isempty(between_groups)
    between_groups=table(repmat('all',size(M,1),1));
end
%%
options.calculate_Fisher_Z_transform=0;
options.boxcox_transform=0;
x1=apply_transformations(M,between_groups,within_headers,options);

options.calculate_Fisher_Z_transform=1;
options.boxcox_transform=0;
x2=apply_transformations(M,between_groups,within_headers,options);

options.calculate_Fisher_Z_transform=0;
options.boxcox_transform=1;
x3=apply_transformations(M,between_groups,within_headers,options);
%%
labs1=repmat(within_headers{:,1}',size(x1,1),1);
labs2=repmat(cellstr(between_groups{:,1}),1,size(x1,2));
spc=repmat({' '},size(x1,1),size(x1,2));
labs=[cat(1,labs1{:}) cat(1,spc{:}) cat(1,labs2{:})];
labs=table(labs);

%%
Correlations=table(x1(:));
Fisher=table(x2(:));
BoxCox=table(x3(:));
T1=[labs Correlations];
T1.Properties.VariableNames{2}='Correlations';
T2=[labs Fisher];
T2.Properties.VariableNames{2}='Fisher';
T3=[labs BoxCox];
T3.Properties.VariableNames{2}='BoxCox';
%%
use_median_instead_of_mean_flag=0;
ol_flag=0;
ptiles=[.1 99.9];
subplot 311
yl=prctile(x1(:),ptiles);
skinny_plot(T1,[],...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'ol_flag',ol_flag,...
    'yl',yl)

subplot 312
yl=prctile(x2(:),ptiles);
skinny_plot(T2,[],...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'ol_flag',ol_flag,...
    'yl',yl)

subplot 313
yl=prctile(x3(:),ptiles);
skinny_plot(T3,[],...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'ol_flag',ol_flag,...
    'yl',yl)