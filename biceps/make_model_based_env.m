function make_model_based_env(handles)

%% Internal variables
fs=filesep;
env_folder=[handles.env.path_gagui fs ...,
    'connectotyping' fs,...
    handles.func_data_name fs,...
    handles.env.group];
mkdir(env_folder);
change_permissions(handles,env_folder)
n_parcel=length(handles.mc.surv_parcels);
n_ar=handles.connectotyping_settings.n_ar;

% Identify participants surviving motion censoring


n_frames = handles.mc.min_frames;% identify the min frames set in th
n_frames2= min(handles.mc.n_surv_frames);% identify the min number of frames after censoring (this number must be equal or larger that the previous one)
n_frames2(1)=[];
%% make symbolic links to tc

no_auto_folder=[handles.env.path_gagui fs ...,
    handles.env.name{2} fs,...
    handles.func_data_name fs,...
    handles.env.group];


for i=1:n_parcel
    j=strcmp(cat(1,{handles.cbh.String}'),strtrim(char(handles.mc.surv_parcels{i})));
    if handles.cbh(find(j)).Value
        parcel_folder=[env_folder fs strtrim(char(handles.mc.surv_parcels{i}))];
        mkdir(parcel_folder)
        change_permissions(handles,parcel_folder)
        
        tc_no_auto_path=[no_auto_folder fs strtrim(char(handles.mc.surv_parcels{i}))];
        source=[tc_no_auto_path fs handles.env.masked_tc];
        destination=[parcel_folder fs handles.env.masked_tc];
        eval(['! ln -s ' source ' ' destination])
        
        make_wrapper_connectotype(handles,parcel_folder);
    end
end
display(['Wrappers are done!'])
