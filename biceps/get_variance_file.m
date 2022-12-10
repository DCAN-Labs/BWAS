function dtseries_var=get_variance_file(dtseries_var_path,handles)

%% dtseries_var=get_variance_file(dtseries_var_path)
%
% This function was made to calculate variance files if they does not exist

%%
% [exist_variance_file dtseries_var_path]=isfile(dtseries_var_path);
[exist_variance_file dtseries_var_path] = check_exist_variance_file(dtseries_var_path,handles);
if exist_variance_file==1
    dtseries_var = dlmread(dtseries_var_path);
else
    
    %% Find the path to the dtseries file
    old_text='_variance';
    new_text='.dtseries';
    [filepath,name,ext]=fileparts(dtseries_var_path);
    dtseries_filename = strrep(name,old_text,new_text);
    
    new_ext='.nii';
    
    dtseries_path = [filepath filesep dtseries_filename new_ext];
    if isfile(dtseries_path)
        
        %% Calculate the variance file
        
        % This text makes text to save the file in the same location of the
        % dtseries file
        %     text_for_wb_command_cifti_stats=[handles.paths.wb_command ' -cifti-stats ' dtseries_path ' -reduce VARIANCE > ' dtseries_var_path]
        
        
        % This text makes text to save the file in the local directory
        
        local_dtseries_var_path=[name ext];
        
        handles.paths.wb_command=quotes_if_space(handles.paths.wb_command);
        dtseries_path=quotes_if_space(dtseries_path);
        local_dtseries_var_path=quotes_if_space(local_dtseries_var_path);
        

        
        
        text_for_wb_command_cifti_stats=[handles.paths.wb_command ' -cifti-stats ' dtseries_path ' -reduce VARIANCE > ' local_dtseries_var_path];
        display(['Calculating variance across grayordinates for dtseries: ' dtseries_filename]);
        system(text_for_wb_command_cifti_stats);
        dtseries_var = dlmread(local_dtseries_var_path);
    else
        display(['dtseries are needed, this file was not found:'])
        dtseries_path
    end
end
    
