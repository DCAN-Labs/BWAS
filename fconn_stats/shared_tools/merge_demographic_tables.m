function [new_filename,demographics_Table_all]=merge_demographic_tables(path_demographics_Table,path_demographics_Table_2,path_dictionary_demographics_Table)

%% Read paths
[path_g1,name_g1,ext] = fileparts(path_demographics_Table);
[path_g2,name_g2,ext] = fileparts(path_demographics_Table_2);

%% Read tables
[demographics_Table_g1, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table);
[demographics_Table_g2, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table_2);

%% concatenate tables

demographics_Table_all=[demographics_Table_g1;demographics_Table_g2];

%% Define path to save
old='g1';
new='all';
new_name=strrep(name_g1,old,new);
new_filename=[path_g1 filesep new_name ext];
writetable(demographics_Table_all,new_filename)