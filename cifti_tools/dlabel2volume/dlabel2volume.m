function dlabel2volume(...
    path_dlabel,...
    path_left_midthicknes,...
    path_right_midthicknes,...
    path_left_pial,...
    path_right_pial,...
    path_left_white,...
    path_right_white,...
    path_volume_template,...
    left_output_volume_filename,...
    right_output_volume_filename,...
    subcortical_output_volume_filename)

%% dlabel2volume

% Oscar Miranda-Dominguez
% First line of code: March 26, 2022
init_time=datetime('now');
tStart = tic;   
%% Define temp files
wd=pwd;
fs=filesep;
left=[wd fs 'L.who_knows.32k_fs_LR.label.gii'];
right=[wd fs 'R.who_knows.32k_fs_LR.label.gii'];


% left_vol=[wd fs 'temp_left.nii.gz'];
% right_vol=[wd fs 'temp_right.nii.gz'];
%% Get path to wb_command
foo=validate_path_wb_command();
path_wb_command=foo.paths.wb_command;

%% Split dlabel into components
% do it for left
text=[path_wb_command ' -cifti-separate ' path_dlabel ' COLUMN -label CORTEX_LEFT ' left];
try
    display('Extracting left cortex gifti')
    [status,cmdout] = system(text,'-echo');
catch
    display('Failed Extracting left cortex gifti')
end


% do it for right
text=[path_wb_command ' -cifti-separate ' path_dlabel ' COLUMN -label CORTEX_RIGHT ' right];
try
    display('Extracting right cortex gifti')
    system(text);
catch
    display('Failed Extracting right cortex gifti')
end


% do it for volume
text=[path_wb_command ' -cifti-separate ' path_dlabel ' COLUMN -volume-all ' subcortical_output_volume_filename];
try
    display('Extracting subcortical volume')
    system(text);
catch
    display('Failed Extracting subcortical volume')
end

%% Make volumes

% do left
text=[path_wb_command ' -label-to-volume-mapping ' left ' ' path_left_midthicknes ' ' path_volume_template ' ' left_output_volume_filename ' -ribbon-constrained ' path_left_white ' ' path_left_pial];
try
    display('Extracting left cortex volume')
    system(text);
catch
    display('Failed Extracting left cortex volume')
end

% do right
text=[path_wb_command ' -label-to-volume-mapping ' right ' ' path_right_midthicknes ' ' path_volume_template ' ' right_output_volume_filename ' -ribbon-constrained ' path_right_white ' ' path_right_pial];
try
    display('Extracting right cortex volume')
    system(text);
catch
    display('Failed Extracting right cortex volume')
end

%% clean up
delete(left);
delete(right);

%% Say goodbay!
tEnd = toc(tStart);
end_time=datetime('now');

disp('Done!')
disp(['job started on: ' datestr(init_time)])
disp(['job  ended  on: ' datestr(end_time)])
disp(['Total completion time: ' num2str(tEnd/60) ' minutes'])

if isdeployed
    exit
end
%%
% %% Merge volumes
% % start with left
% text=[path_wb_command ' -volume-merge ' output_volume_filename ' -volume ' left_vol];
% try
%     system(text)
% end
% 
% % add right
% text=[path_wb_command ' -volume-merge ' output_volume_filename ' -volume ' output_volume_filename ' -volume ' right_vol];
% try
%     system(text)
% end
% 
% % add subcortical
% text=[path_wb_command ' -volume-merge ' output_volume_filename ' -volume ' output_volume_filename ' -volume ' sub];
% try
%     system(text)
% end

