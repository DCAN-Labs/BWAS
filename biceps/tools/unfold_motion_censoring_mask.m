function unfold_motion_censoring_mask(path_to_list,path_to_functional)

%% Use this function to unfold masks to calculate connectotyping via // code
%% path to functional
% path_to_functional='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README\output_GUI_env\standard\Functional';
% path_to_list      ='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README\all_dtseries_list_N_14_MCMethod_power_2014_FD_only_FD_th_0_20_min_frames_375_skip_frames_5_TRseconds_0_80.txt';
%%
% path_to_mask      ='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\README\output_GUI_env\standard\Functional\all_dtseries_list_N_14_MCMethod_power_2014_FD_only_FD_th_0_50_min_frames_150_skip_frames_5_TRseconds_0_80\frame_removal_mask.mat';
%%
nested_folder_name=extract_nested_folder_name(path_to_list);

%% Build path to mask

fs=filesep;
[root_path filename extension]=fileparts(path_to_list);

path_mask=[path_to_functional  fs filename fs 'frame_removal_mask.mat'];

%% Load mask
load(path_mask)
[r,c]=size(mask);

%% Count surviving frames and define suffix
surv_frames=cellfun(@sum,mask);
suffix=cell(c,1);
if c==3
    suffix{1}='all';
    for i=2:c
        suffix{i}=num2str(surv_frames(1,i));
    end
end
%% read list

list = importdata(path_to_list);
%% Make filename to save mask
root_path_unfolded_mask='mask_as_csvs';
root_path_unfolded_mask=[path_to_functional  fs filename fs root_path_unfolded_mask];

if ~isfolder(root_path_unfolded_mask)
    mkdir(root_path_unfolded_mask)
end

for i=1:r
    nested_folder_name=extract_nested_folder_name(list{i});
    local_filename_root=[nested_folder_name{end-1} '_' nested_folder_name{end} '_N_frames_'];
    for j=1:c
        local_filename=[local_filename_root suffix{j}];
        csv_filename=[root_path_unfolded_mask fs local_filename '.csv'];
        csvwrite(csv_filename,mask{i,j});
    end
end