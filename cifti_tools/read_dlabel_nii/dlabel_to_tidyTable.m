function tidyTable=dlabel_to_tidyTable(path_dlabel,tidyTable_filename)

%%

%%
fs=filesep;
%% Look for wb_command
% path_wb_command = read_path_wb_command();
% path_wb_command=quotes_if_space(path_wb_command);

%% Get path to wb_command
foo=validate_path_wb_command();
path_wb_command=foo.paths.wb_command;
%% read label file via -cifti-label-export-table

% temp_label_txt=[pwd fs random_name(20,'txt')];
[ filepath , temp_label_txt ] = fileparts( tidyTable_filename );
ext='.txt';
temp_label_txt=[ filepath fs temp_label_txt ext ];

text_for_wb_command=[path_wb_command ' -cifti-label-export-table ' path_dlabel ' 1 ' temp_label_txt];
system(text_for_wb_command);

%% Read file made in previous section

T = read_temp_label_txt(temp_label_txt);

%% Delete temporary file

% delete(temp_label_txt)
%% Save table

writetable(T,[tidyTable_filename '.csv'])
tidyTable=T;

%% copy dictionary template
template_filename=which( 'dictionary_dlabel.csv');
[ filepath , filename ] = fileparts(tidyTable_filename);
dictionary_filename=[filepath fs 'dictionary_' filename '.csv'];
copyfile(template_filename,dictionary_filename);