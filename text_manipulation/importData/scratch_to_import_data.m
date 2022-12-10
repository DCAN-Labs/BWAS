%% adding paths
if ispc
    addpath(genpath('P:\code\internal\utilities\OSCAR_WIP\'))
else
    addpath(genpath('/public/code/internal/utilities/OSCAR_WIP/'))
end
f=filesep;
%% change to wd

wd='P:\code\internal\utilities\OSCAR_WIP\text_manipulation\importData';
if ~ispc
    wd=rewrite_paths(wd);
end

%% Wrappers
Dictionary_filename='C:\Users\mirandad\Box Sync\NHP anesthesia rsfcMRI Brambrink\ePhysioData\Dictionary_tidyfied_ISO_data_for_Oscar.csv';
tidyData_filename='C:\Users\mirandad\Box Sync\NHP anesthesia rsfcMRI Brambrink\ePhysioData\tidyfied_ISO_data_for_Oscar.csv';
[tidyData, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);

%%
Dictionary = importDictionary(Dictionary_filename);
tidyData = import_tidyData(Dictionary,tidyData_filename);

