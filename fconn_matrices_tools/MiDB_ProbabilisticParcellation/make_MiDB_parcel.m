%% Robert provided the files:

% - parcel_probability_map.mat
% - Roberts_ROI_set_w_names.xlsx
% - TMprobability_modules.csv

a=dir('parcel_probability_map.mat');
filename=[a.folder filesep a.name]
[filepath,name,ext] = fileparts(filename);

load(filename)
orig_parcel=parcel;
%% Renaming done by copy pasting names from Roberts_ROI_set_w_names.xlsx to parcel
for i=1:14
ix=parcel(i).ix;
parcel(i).RGB=RGB(1:3);
parcel(i).ix=ix';
end
%% Removing the 4th element Robert provided for RGB
for i=1:14
RGB=parcel(i).RGB;
parcel(i).RGB=RGB(1:3);
end
%% Transposing ix
%% saving
save('MiDB_ProbabilisticParcellation.mat','parcel')
T = parcel_str2table(parcel);
writetable(T,'MiDB_ProbabilisticParcellation.csv')

% MiDB_ProbabilisticParcellation=