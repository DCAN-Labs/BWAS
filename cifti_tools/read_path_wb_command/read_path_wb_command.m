function path_wb_command = read_path_wb_command()

%% OScar Miranda-Dominguez
% First line of code: July 7, 2020

prog_file='wb_command';

path_wb_command=find_path_system_file_behind_scenes(prog_file);

if isempty(path_wb_command)
    [file, path] = uigetfile(...
        '*.*',...
        'Please provide path to wb_command');
    path_wb_command=[path file];
end
path_wb_command = strrep(path_wb_command,'wb_command.exe','wb_command');