function dtvariance_patch(path_list_file,varargin)


%% Internal variables
fs=filesep;

%% Define defaults

% Save in BIDS folder, default NO,
save_in_BIDS_folder=0;


output_folder=[pwd fs 'dtvariance_files'];

%
string_to_match=['*func' fs '*rest*bold*dtseries.nii*'];
%% Read additional arguments, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        case 'output_folder'
            output_folder=varargin{q+1};
            save_in_BIDS_folder=0;
            q = q+1;
            
        case 'save_in_BIDS_folder'
            save_in_BIDS_folder=varargin{q+1};
            q = q+1;
            
        case 'string_to_match'
            string_to_match=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

save_in_BIDS_folder=save_in_BIDS_folder==1;
%% Ask for path to wb_command
handles = validate_path_wb_command();
handles.paths.wb_command=quotes_if_space(handles.paths.wb_command);
%% Make output folder if requested

if and(isfolder(output_folder)==0,save_in_BIDS_folder==0)
    mkdir(output_folder)
end
%%
new_text='_variance';
old_text ='.dtseries';

%%
% path_list_file='C:\Users\oscar\Box\CV\ABCD\list_N_14.txt';
list=importdata(path_list_file);
n=size(list,1);


for i=1:n
    local_path=[list{i} filesep string_to_match];
    temp=dir(local_path);
    if size (temp,1)>0
        dtseries_path=[temp.folder fs temp.name];
        dtseries_path=quotes_if_space(dtseries_path);
        
        [filepath,name,ext]=fileparts(dtseries_path);
        name=strrep(name,old_text,new_text);
        
        
        if save_in_BIDS_folder
        else
            filepath=output_folder;
        end
        
        local_dtseries_var_path=[filepath fs name '.txt'];
        
        local_dtseries_var_path=quotes_if_space(local_dtseries_var_path);
        
        text_for_wb_command_cifti_stats=[handles.paths.wb_command ' -cifti-stats ' dtseries_path ' -reduce VARIANCE > ' local_dtseries_var_path];
        display(['Calculating variance across grayordinates for dtseries: ' dtseries_path]);
        system(text_for_wb_command_cifti_stats);
        
        
        
    end
end
