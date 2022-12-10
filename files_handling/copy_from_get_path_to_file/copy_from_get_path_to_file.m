function copy_from_get_path_to_file (list,root_path,new_target_path,varargin)
%% move_from_get_path_to_file (list,root_path,new_target_path)
% This function takes as input a list obtained using get_path_to_file and
% copies the data into a new folder after replacing root_path with new_target_path

% Oscar Miranda-Dominguez
% First line of code: Jun 18, 2020
%% Example
% 1. Find all the tsv files in a foldet
%
% root_path='/home/exacloud/lustre1/fnl_lab/data/HCP/processed/BCP_8+/latest_processing_round_Jan2020/derivatives/abcd-hcp-pipeline';
% depth=2;
% string_to_match=['func' f '*.tsv'];
% list=get_path_to_file(root_path,depth,string_to_match);
%
% 2. Copy the files into a new folder:
%
% new_target_path='/home/exacloud/lustre1/bcp/experiments/move_tsv_data';
% copy_from_get_path_to_file (list,root_path,new_target_path)
%
% 3. Example saving data as sym link
% 
% save_as_simlink_flag=1;
% copy_from_get_path_to_file (list,root_path,new_target_path,...
%     'save_as_simlink_flag',save_as_simlink_flag)

%% Define default values for optional arguments
save_as_simlink_flag=0;
%% Read optional arguments


v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'save_as_simlink_flag'
            save_as_simlink_flag=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
save_as_simlink_flag=save_as_simlink_flag==1;
%%
new_list = strrep(list,root_path,new_target_path);
n=size(list,1);

for i=1:n
    source=list{i};
    destination=new_list{i};
    [filepath,name,ext] = fileparts(destination);
    if ~isfolder(filepath)
        mkdir(filepath);
    end
    if save_as_simlink_flag==1
        system(['ln -s ' source ' ' destination]);
    else
        copyfile(source,destination)
    end
end