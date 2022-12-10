%% Example using 2 samples: Cross-validation across samples

%% To download dependancies
% https://gitlab.com/Fair_lab/fconn_stats
% https://gitlab.com/Fair_lab/tables_handling
% https://gitlab.com/Fair_lab/fconn_matrices_tools.git
% https://gitlab.com/Fair_lab/generic_for_functions.git
% https://gitlab.com/Fair_lab/text_manipulation.git
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
addpath(genpath([root_code_path fs 'plotting-tools']))
%% Assumptions
% - You have connectivity matrices made via GUI_environments
% - Data has been parcellated and you have a "parcel" object with network
% assignments for each ROI
% - you know the order of the participants: id, group and time-point
% - it is easier to have a table with assignments of those variables. One
% of the headers must be consecutive_number indicating the position of the
% participant's connectivity matrix in the 3D array with connectivity
% matrices from the participants


%% Go to this project's working directory (wd)

wd = [root_code_path fs 'fconn_stats' fs 'fconn_regression' fs 'readme'];
cd (wd)

%% Load imaging data

% This example includes two datasets with imaging and non-imaging data.

repo_folder=[root_code_path fs 'fconn_stats' fs 'fconn_regression' fs 'readme' fs 'example_data' fs 'two_samples'];
load([repo_folder filesep 'data.mat'])

%%% Data description
%
% * *M1*: 3D array of size $ROI x ROI x n_subjects$ containing the
% connectivity matrices from each participant in the first sample
% * *M2*: Same as before for the second sample
% * *parcel*: Structure containing the assignment of each $ROI$ to each
% functional network
%% Import table indicating subjects's outcome to be predicted

% This example include that information for each dataset. Data will be
% impoted using the function import_tidyData_with_Dictionary

Dictionary_filename=[repo_folder filesep 'dictionary_tables1_and_2.csv'];
tidyData_filename1=[repo_folder filesep 'Table1.csv'];
tidyData_filename2=[repo_folder filesep 'Table2.csv'];
[T1, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename1);
[T2, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename2);
%
%%% Data description
%
% Each table contains three columns: Group, consecutive number, and outcome
% to be predicted. The second column indicates the location of the
% connectivity matrix for each participant in the 3D array loaded in the
% previous section.
%
% If you inspect the data you will see that some participants has nan in
% as outcome to be predicted. THose participents will be excluded.

%% Allign participants and resort data
T_column_names_for_between='Dx';
T_column_names_for_within=[];
[between_design_prisma, within_design, M_prisma, resorted_T_prisma,ix]=local_prep_for_fconn_rm_anovan(T1,T_column_names_for_between,T_column_names_for_within,M1);
[between_design_trio, within_design, M_trio, resorted_T_trio,ix]=local_prep_for_fconn_rm_anovan(T2,T_column_names_for_between,T_column_names_for_within,M2);

%% Intermediary step | Unfold connectivity matrices as tables

clear options
options.boxcox_transform=0;
options.calculate_Fisher_Z_transform=0;
options.resort_parcel_order=[10 11];% select which functional networks to include from the parcellation schema. When empty it uses all the functional network pairs (default behavior)

[main_table_trio, within_headers, opt_trio, r_trio, c_trio,ix_to_ix_table_trio] = extract_NN_table(M_trio,parcel,between_design_trio,within_design,options);
[main_table_prisma, within_headers, opt_prisma, r_prisma,c_prisma,ix_to_ix_table_prisma] = extract_NN_table(M_prisma,parcel,between_design_prisma,within_design,options);
%% Assign table values to $y$ variable

outcome_name='boxcox_EC';
IX1=find_ix_in_header(T1,outcome_name);
IX2=find_ix_in_header(T2,outcome_name);

y_prisma=T1{:,IX1};
y_trio=T2{:,IX2};


local_y_trio=y_trio;
local_y_prisma=y_prisma;
%% Define output directory

output_dir=[wd fs 'output' fs 'example_fconn_2_samples'];
mkdir(output_dir)
cd(output_dir)

%% Define options for PLSR models
clear options
options.out_for_xval=3;
options.zscoring=[0];
options.N=1e4;
options.N_Null=1e4;
options.save_data=1;
options.scout_up_to=3;
rng('shuffle')

%% This section remove nan
[main_table_trio_no_nans,local_y_trio_no_nans]=exclude_nans(main_table_trio,local_y_trio);
[main_table_prisma_no_nans,local_y_prisma_no_nans]=exclude_nans(main_table_prisma,local_y_prisma);

%% run test
scout_parameters_fconn_regression(main_table_trio_no_nans,within_headers,local_y_trio_no_nans,options,main_table_prisma_no_nans,local_y_prisma_no_nans)
cd(wd)
