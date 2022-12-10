function make_wrapper_connectotype(handles,parcel_folder)
fs=filesep;

surv=handles.mc.surv_ix;
surv(:,1)=[]; %first column refers to standard, second one to model based
n_surv=sum(surv);
ix=find(surv);


grid_sub_folfer=[parcel_folder fs 'grid_sub'];
mkdir(grid_sub_folfer);
change_permissions(handles,grid_sub_folfer);

wrapper_filename=[parcel_folder fs handles.connectotyping_settings.run_connectotype_filename];
eval(['!rm -f ' wrapper_filename]);
eval(['! touch ' wrapper_filename]);
queue_text=['QUEUE="' handles.connectotyping_settings.QUEUE '"'];
eval(['!echo ' queue_text ' >> ' wrapper_filename])

surv_text=['n_survivors="' num2str(n_surv) '"'];
eval(['! echo ' surv_text ' >> ' wrapper_filename])

dummy=which ('GUI_environments.m');
[matlab_template_path,b,c]=fileparts(dummy);
matlab_template='matlab_mb_template.m';
matlab_template_text=['matlab_template=""' matlab_template_path fs matlab_template '""'];
eval(['! echo ' matlab_template_text ' >> ' wrapper_filename])

cat_text=['cat ' matlab_template_path fs 'run_make_model_template.bat'];
eval(['! ' cat_text ' >> ' wrapper_filename])

