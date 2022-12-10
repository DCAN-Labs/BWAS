%% Identify repo's path
foo=which('CWAS');
fs=filesep;
[repo_path , name , ext ] = fileparts(foo);
repo_path;

% Path to damographics table and corresponding dictionary
path_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'demographics_Table.csv'];
path_dictionary_demographics_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Dictionary_for_demographics_Table.csv'];


% Path to group design table
path_group_Design_Table=[repo_path fs 'data' fs 'xsectional_1_outcome_cthickness' fs 'Group_Design_Table_to_describe_sample.csv'];

%% Read demo and group design table
[demographics_Table, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table);
group_Design_Table=readtable(path_group_Design_Table);

%% 
T_column_names_to_report = get_variable_design(group_Design_Table,'to_report');
T_column_names_for_group = get_variable_design(group_Design_Table,'group');

%%
columns_with_basic_info.group=T_column_names_for_group{1};
columns_with_basic_info.to_compare= T_column_names_to_report

%%
test_2_samples='k';
%%
clc
summarized_paired_comparisons=make_formatted_table_of_participants (demographics_Table, columns_with_basic_info,filename,...
    'test_2_samples',test_2_samples);
 md_table=table_in_markdown(summarized_paired_comparisons)