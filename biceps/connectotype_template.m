%% From wrapper
parc_folder=['/group_shares/FAIR_LAB2/Projects/ADHD_HCP_biomarkers/experiments/model_based/' parcellation];
addpath(genpath('/group_shares/FAIR_LAB/Staff/Oscar/matlab_code/'));


%% Connectotyping settings
options.params.cutoff=1;
options.params.lags=0;
options.params.autocorrelation=0;
options.params.concurrent=1;
options.params.pass_th=0;
perc1=handles.connectotyping_settings.partition_model/100;
perc2=handles.connectotyping_settings.partition_validation/100;
options.perc=[perc1 perc2];
options.rep_svd=handles.connectotyping_settings.rep_svd; % how many times to repeat the svd decomposition to maximize out of sample data predictions
options.rep_model=handles.connectotyping_settings.repetitions; % if number of frames not empty, how many times recalculate the model based on the minimum required frames
%% Calculate the model
model_name=[parcellation '_' num2str(local_i) '.mat'];
signal=group_mc(local_i).censored_tc_no_ac;
tic
[SV, R]=model_tsvd(signal,options);
options.min_frames=min_frames(local_i);
options.SV=SV;
m=make_model_tsvd(signal,options);
display(['run ' num2str(local_i) ', time = ' num2str(toc) ' s'])
save([parc_folder '/' model_name],'m')
exit
