function handles = validate_path_wb_command(handles)

local_wb_command_path_file=which('local_wb_command_path.mat');
if isfile(local_wb_command_path_file)
    load(local_wb_command_path_file)
    handles.paths.wb_command=local_wb_command_path;
end

try
    local_wb_command_exist=isfile(handles.paths.wb_command);
catch
    local_wb_command_exist=0;
end

if local_wb_command_exist == 0
    wb_command_on_msi = '/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command';
    
    if isfile(wb_command_on_msi) == 1
        handles.paths.wb_command= wb_command_on_msi;
    else        
        wb_command_vm='/opt/workbench/wb_command';
        
        if isfile(wb_command_vm) == 1
            handles.paths.wb_command= wb_command_vm;
        else 
            disp('Please provide path to wb_command')
            [file, path] = uigetfile(...
                '*.*',...
                'Please provide path to wb_command');
            handles.paths.wb_command=[path  file];
            local_wb_command_path=handles.paths.wb_command;
            foo=which('biceps');
            [filepath,~,~] = fileparts(foo);
            local_wb_command_path_file=[filepath filesep 'local_wb_command_path.mat'];
            save(local_wb_command_path_file,'local_wb_command_path')
        end
    end
end
