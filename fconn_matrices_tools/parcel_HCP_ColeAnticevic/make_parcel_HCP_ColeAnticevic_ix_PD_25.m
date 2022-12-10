%% Define who am I
if ispc
    this_computer='OscarDell';
else
    this_computer='OscarMac';
end


switch this_computer
    case 'OscarDell'
        root_code_path='C:\Users\Oscar\OneDrive\matlab_code';
    case 'OscarMac'
        root_code_path='/Users/miran045/OneDrive/matlab_code';
end

%% add dependancies

fs=filesep;
addpath(genpath([root_code_path fs 'fconn_stats']))
addpath(genpath([root_code_path fs 'tables_handling']))
addpath(genpath([root_code_path fs 'fconn_matrices_tools']))
addpath(genpath([root_code_path fs 'generic_for_functions']))
addpath(genpath([root_code_path fs 'text_manipulation']))


%%

% 1. load parent parcel
% 1. load table of roi names
% 1. load table of roi-network assignment
% 1. define which network will be deleted
%% Define working directory
wd=[root_code_path fs 'fconn_matrices_tools' fs 'parcel_HCP_ColeAnticevic'];
cd(wd)
%% Load parent parcel

load('HCP_ColeAnticevic.mat')

%% Read ROI names

tidyData_filename=[wd fs 'HCP_PD25.dlabel.csv'];
Dictionary_filename=[wd fs 'dictionary_HCP_PD25.dlabel.csv'];
[roi_names, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);


%% Read ROI/network assignment

Dictionary_filename=[root_code_path fs 'fconn_matrices_tools' fs 'MNI_PD25' fs 'dictionary_subcortical_roi_network_assignment.csv'];
tidyData_filename=[root_code_path fs 'fconn_matrices_tools' fs 'MNI_PD25' fs 'subcortical_roi_network_assignment.csv'];
[roi_network_assignment, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);

%% do it for parcel
parent_parcel=parcel;
network_name_to_delete='Subcortical';
newParcel = append_network(parent_parcel,roi_names,roi_network_assignment,network_name_to_delete)
summarize_parcel(parent_parcel)
summarize_parcel(newParcel)

%% Do it for combined parcel

parent_parcel=combined_parcel;
network_name_to_delete='Subcortical';
combined_newParcel = append_network(parent_parcel,roi_names,roi_network_assignment,network_name_to_delete);
summarize_parcel(parent_parcel)
summarize_parcel(newParcel)


%% Rename and save
parcel=newParcel;
combined_parcel=combined_newParcel;
save('HCP_PD25.mat','parcel','combined_parcel');