%SAD
%% Coming from wrapper
i=1
path_to_tc
%% Template
options.params.cutoff=1;
options.params.lags=0;
options.params.autocorrelation=0;
options.params.concurrent=1;
options.params.pass_th=0;
options.perc=[0.6 0.4];
% options.perc=[handles.connectotyping_settings.partition_model handles.connectotyping_settings.partition_validation]/100
options.rep_svd=10; % how many times to repeat the svd decomposition to maximize out of sample data predictions
options.rep_model=1; % if number of frames not empty, how many times recalculate the model based on the minimum required frames
inc_frames=[];
%%
% signal=group_mc(i).censored_tc_no_ac;
signal=masked_tc{i};
tic
[SV, R]=model_tsvd(signal,options);
options.min_frames=342;
options.SV=SV;
model=make_model_tsvd(signal,options);
display(['run ' num2str(i) ', time = ' num2str(toc) ' s'])
toc
