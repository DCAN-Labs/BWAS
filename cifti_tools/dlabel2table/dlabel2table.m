function dlabel2table(...
    path_dlabel,...
    path_left_midthicknes,...
    path_right_midthicknes,...
    output_folder,...
    suffix)

%% Oscar Miranda-Dominguez
% First line of code: March 26, 2022
init_time=datetime('now');
tStart = tic;  

fs=filesep;
%% Make output folder
local_path=pwd;
if ~isfolder(output_folder)
    mkdir(output_folder)
end
%% dlabel_to_tidyTable
% Use the function dlabel_to_tidyTable to go directly from the dlabel.nii
% to a table with the ROI names, RGB colors and alpha values

fs=filesep;
tidyTable_filename=[output_folder fs 'summary' suffix];
summaryLabel=dlabel_to_tidyTable(path_dlabel,tidyTable_filename);

%% Define temp files
wd=pwd;
fs=filesep;
left=[output_folder fs 'L_' suffix '.label.gii'];
right=[output_folder fs 'R_' suffix '.label.gii'];
volume=[output_folder fs 'V_' suffix '.nii.gz'];

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
text=[path_wb_command ' -cifti-separate ' path_dlabel ' COLUMN -volume-all ' volume];
try
    display('Extracting subcortical volume')
    system(text);
catch
    display('Failed Extracting subcortical volume')
end

%% Read giftis from midthicknes
display('Reading midthicknes files');
L_mid=gifti(path_left_midthicknes);
R_mid=gifti(path_right_midthicknes);
% vertices=[double(L_mid.vertices);double(R_mid.vertices)];
XYZ_left=double(L_mid.vertices);
XYZ_right=double(R_mid.vertices);
XYZ_left=array2table(XYZ_left);
XYZ_right=array2table(XYZ_right);
XYZ_left.Properties.VariableNames{1}='X';
XYZ_left.Properties.VariableNames{2}='Y';
XYZ_left.Properties.VariableNames{3}='Z';

XYZ_right.Properties.VariableNames{1}='X';
XYZ_right.Properties.VariableNames{2}='Y';
XYZ_right.Properties.VariableNames{3}='Z';

L_lab=gifti(left);
R_lab=gifti(right);
% % cdata=[L_lab.cdata;R_lab.cdata];
%% Read label names
display('Reading labels')
L = unfold_ROI_label_color(L_lab.cdata,summaryLabel);
R = unfold_ROI_label_color(R_lab.cdata,summaryLabel);
%% concatenate tables
display('Making tables')
L=[L XYZ_left];
R=[R XYZ_right];

%% Save tables
display('Saving tables')
writetable(L,[output_folder fs suffix '_left_labels.csv']);
writetable(R,[output_folder fs suffix '_right_labels.csv']);

try
    catT=[L;R];
    writetable(catT,[output_folder fs suffix '.csv']);
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