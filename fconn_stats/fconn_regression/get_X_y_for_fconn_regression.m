function [main_table,within_headers,y]=get_X_y_for_fconn_regression(path_imaging,...
    path_dictionary_demographics_Table,...
    path_demographics_Table,...
    path_group_Design_Table,...
    parcel,...
    options)

%% Credits
% Oscar Miranda-Dominguez
% First line of code: Nov 4, 2020

%% Define defaults

fs = filesep;

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

%% Censor "networks" with one connectivity value

[u,nu,ix,nix]=find_uniques(within_headers);
ix_to_kill=nix==1;
ix_to_kill=cell2mat(ix(ix_to_kill));

within_headers(ix_to_kill,:)=[];
M(:,ix_to_kill)=[];

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
x=apply_transformations(M,between_groups,within_headers,options);
%% Wrap output
T_column_names_for_id = get_variable_design(group_Design_Table,'id');
IX_column_names_for_between = find_ix_in_header(demographics_Table,T_column_names_for_id);
main_table=[demographics_Table(ix_nan==0,T_column_names_for_id) array2table(x)];



