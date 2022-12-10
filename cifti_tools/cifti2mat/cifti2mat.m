function M = cifti2mat(path_to_cifti)

% M = cifti2mat(path_to_cifti)
% First line of code: Sept 9, 2020
% Oscar Miranda-Dominguez

%% Get path to wb_command
handles=[];
handles = validate_path_wb_command(handles);
path_wb_command=handles.paths.wb_command;


%% Read cifti and save as double
cii=ciftiopen(path_to_cifti,path_wb_command);
newcii=cii;
X=newcii.cdata;
M=double(X);