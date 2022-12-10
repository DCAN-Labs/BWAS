%% Define who am I
if ispc
    this_computer='OscarDell';
else
    this_computer='OscarMac';
end


switch this_computer
    case 'OscarDell'
        root_code_path='C:\Users\Oscar\OneDrive\matlab_code';
    case 'OscarMac'
        root_code_path='/Users/miran045/OneDrive/matlab_code';
end
%% ADD PATH
addpath(genpath([root_code_path]));

%%
%Example: 
% 
root_path='C:\Users\oscar\Box\Manuscripts\Carla_cortical_thickness\HBM\submission2';
depth=0;
string_to_match='*.fig*';

list=get_path_to_file(root_path,depth,string_to_match);

%%
dpi=1e3;
for i=1:size(list,1)
    path_dot_fig=list{i};
    read_save_dot_fig(path_dot_fig,...
        'dpi',dpi)
end