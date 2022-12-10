function row_column_cifti_table=update_row_column_cifti_table(varargin)

%% OScar Miranda-Domimguez
% row_column_cifti_table=update_row_column_cifti_table();
% First line of code: Sept 9, 2020
%% Run this function if you add cifti templates 
%% Get the path to the code
func_to_search='mat2cifti';
root_path=which(func_to_search);
[root_path filename extension]=fileparts(root_path);

%% Filesep
fs =filesep;
%% Define path to save the table

path_to_save=[root_path fs 'tools'];
%% Path to find xtseries and xconn templates

root_path=strrep(root_path,func_to_search,'templates');
%% Read templates

list=get_path_to_files_here([root_path filesep 'x*'],0);
%% Get path to wb_command
handles=[];
handles = validate_path_wb_command(handles);
path_wb_command=handles.paths.wb_command;
%% Count
n=size(list,1);

disp ([num2str(n) ' template ciftis were identified'])
r=zeros(n,1);
c=zeros(n,1);
filename=cell(n,1);
relative_path_from_templates=cell(n,1);
for i=1:n
    local_file=list{i};
    M=cifti2mat(local_file);
    [r(i),c(i)]=size(M);
    [local_path,local_filename,ext]=fileparts(local_file);
    filename{i}=[local_filename ext];
    nested_folder_name=extract_nested_folder_name(local_file);
    relative_path_from_templates{i}=nested_folder_name{end-1};
    local_text = get_local_text(local_file, i, n);
    disp(local_text)
end
%% Do xtseries
row_column_cifti_table=table(r,c,relative_path_from_templates,filename);

%% Save files
disp('Saving files')
dot_mat = [path_to_save fs 'row_column_cifti_table.mat'];
save(dot_mat,'row_column_cifti_table');

dot_csv = [path_to_save fs 'row_column_cifti_table.csv'];
writetable(row_column_cifti_table,dot_csv)
%% Final results
disp(['Final result:'])
disp(row_column_cifti_table)