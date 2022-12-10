function [main_table, global_stats] = parcel_rm_anovan(dmap,parcel,between_design,within_design,options)

%%
if nargin < 5
    options=[];
end


%% Resort alphabetically
if isfield(options,'resort_parcel_order')
    temp_ix=options.resort_parcel_order;
else
    temp_ix=1:size(parcel,2);
end
if isempty (temp_ix)
    temp_ix=1:size(parcel,2);
end


[aa bb]=unique(char(parcel(temp_ix).shortname),'rows','sorted');
options.resort_parcel_order=temp_ix(bb');
clear aa bb

%% Read options

[options] = read_options_fconn_anovas(options,parcel);
% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_fconn_anovas(options,n_cases, n_feat);

% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_basic_SVM(options,n_cases, n_feat);
global_stats.options=options;
options

%%
p_th=options.p_th; %P value for figures

%% Resort
ix=options.ix_sorting;
dmap_backup=dmap;
dmap=dmap(ix,:);

sN=size(dmap,2);
n_ROIs=size(ix,1); % Notice this number is read from ix, not from dmap. THis trick is to allow the exclussion of functional networks in options (options.resort_parcel_order), since in options you can specify which networks to include in the analysis
