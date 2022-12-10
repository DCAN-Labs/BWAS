function rename_BIDs_Data(path_to_BIDS,new_output_path)

if isempty(new_output_path)
    new_output_path=path_to_BIDS;
end
 %%
% 
% path_to_BIDS='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\data\human';
% new_output_path='C:\Users\oscar\OneDrive\matlab_code\GUI_environments\data\anonymized_human';
%% Get list orig files
depth=3;
string_to_match='*';
orig_list=get_path_to_files_here(path_to_BIDS,depth);

%% Get list of IDs and visits
depth=2;
list=get_path_to_folders(path_to_BIDS,depth);
n=size(list,1);
nested_folder_name=extract_nested_folder_name(list);
original_IDs=nested_folder_name(:,end-1);
original_visits=nested_folder_name(:,end);
%% Anonymize IDs

preffix='fake_ID_';
suffix=[];
[new_IDs unique_new_IDs unique_original_IDs ]=get_old_new_table(original_IDs,preffix,suffix);

%% Anonymize visits
preffix='fake_visit_';
suffix=[];
[new_visit unique_new_visits unique_original_visits ]=get_old_new_table(original_visits,preffix,suffix);
%% Prep destination files
destination=orig_list;

% Apply new root path
destination=strrep(destination,path_to_BIDS,new_output_path);

% Apply new IDs 
destination=strrep_vectorized(destination,unique_original_IDs,unique_new_IDs);

% Apply new subject ID
destination=strrep_vectorized(destination,unique_original_visits,unique_new_visits);

%% Make new folders

if ~isdir(new_output_path)
    mkdir(new_output_path)
end
    
for i=1:n
    new_folder=list{i};
    new_folder=strrep(new_folder,path_to_BIDS,new_output_path);
    new_folder=strrep(new_folder,original_IDs{i},new_IDs{i});
    new_folder=strrep(new_folder,original_visits{i},new_visit{i});
    mkdir(new_folder);
    mkdir([new_folder filesep 'anat']);
    mkdir([new_folder filesep 'func']);
end


%% copy files to new folder

n=numel(orig_list);
for i=1:n
    copyfile(orig_list{i},destination{i});
end


% %%
% get_old_new_table(old,preffix,suffix)
% unique_original_IDs=unique(original_IDs);
% n_unique_original_IDs=numel(unique_original_IDs);
% flag_format=['%0' num2str(ceil(log10(n_unique_original_IDs))) '.f'];
% unique_new_IDs=[repmat('fake_ID_',n_unique_original_IDs,1) num2str([1:n_unique_original_IDs]',flag_format)];
% for i=1:
% end
% 
% %%
