function list=get_path_to_file(root_path,depth,string_to_match)

%% list=get_path_to_file(root_path,depth,string_to_match)
%
% Oscar Miranda-Dominguez
% First line of code: Oct 8, 2019
%% This function outputs a list of files that match a given string (including wild characters)
%
% Inputs
% root_path, root path shared by all the files
% depth, number of nested folders that can have different names. 
% string_to_match, text pattern to match

%Example: 
% 
% root_path='C:\Users\mirandad\Box\PCO_branch\manuscripts\left_pallidus\figures\';
% depth=1;
% string_to_match='Fig_*.tif*';
%%

fs=filesep;

% check rooth path does not end with filesep
if strcmp(root_path(end),fs)
    root_path(end)=[];
end

% include nested folders
target_path=root_path;
for i=1:depth    
    target_path=[target_path fs '*'];
end

% concatenate pattern to match
target_path=[target_path fs string_to_match];

% do the search
full_list=dir(target_path);

% preallocate memory to unfolde the list
n=size(full_list,1);

% unfold the list
list=cell(n,1);
for i=1:n
    list{i}=[full_list(i).folder fs full_list(i).name];
end

% if output is folder, remove extra files
n=size(list,1);
ix_to_keep=ones(n,1);
ix_to_keep=ix_to_keep==1;
ends_with_dot=0;
for i=1:n
    ends_with_dot(i)=strcmp([filesep '.'],list{i}(end-1:end));
end
ends_with_dot=ends_with_dot==1;

if sum(ends_with_dot)>0
    ix_to_keep=ends_with_dot;
end
list=list(ix_to_keep);