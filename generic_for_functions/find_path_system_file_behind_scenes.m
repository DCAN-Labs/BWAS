function path_system_file = find_path_system_file_behind_scenes(prog_file)

%% Oscar Miranda-Dominguez
%% First line of code: July 9, 2020
% Use this function to locate the path of a system file that will ve called
% within matlab
% Example
% prog_file='wb_command';
% paths_wb_command=find_path_system_file_behind_scenes(prog_file);

command=['which ' prog_file];
if ispc
    command=['where ' prog_file];
end


[status,cmdout] = system(command);

cmdout=strtrim(cmdout);
if status~=0
    cmdout=[];
end
% cmdout=quotes_if_space(cmdout);

path_system_file=cmdout;