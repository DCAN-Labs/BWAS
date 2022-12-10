function options = read_options_fconn_anovas(options,parcel)
%% Oscar Miranda-Dominguez

n_parcels=size(parcel,2);
%% Assign default values, if not provided and error check

% Define length of bars in terms of times the standard error tse
if ~isfield(options,'bar_lengh_times_standard_error') || isempty(options.bar_lengh_times_standard_error)
    options.bar_lengh_times_standard_error=1.96; % sort the parcels as presented in the structure parce
    % tse=1.96;% 95%
    % tse=1.15;% 75%
end


% Define the sorting order of the parcels
if ~isfield(options,'resort_parcel_order') || isempty(options.resort_parcel_order)
    options.resort_parcel_order=1:n_parcels; % sort the parcels as presented in the structure parce
end
ix_sorting=cat(1,parcel(options.resort_parcel_order).ix);
options.ix_sorting=ix_sorting;


% Calculate or not Fisher Z transform
if ~isfield(options,'calculate_Fisher_Z_transform') || isempty(options.calculate_Fisher_Z_transform)
    options.calculate_Fisher_Z_transform=0; % Making default =0
end
options.calculate_Fisher_Z_transform=options.calculate_Fisher_Z_transform==1;%% making it binary (==)


if ~isfield(options,'boxcox_transform') || isempty(options.boxcox_transform)
    options.boxcox_transform=0; % Making default 0
end
options.boxcox_transform=options.boxcox_transform==1;


if ~isfield(options,'correction_type') || isempty(options.correction_type)
    options.correction_type=1; % Making default 1
    options.correction_type=round(options.correction_type);
    
end
if and(options.correction_type<1,options.correction_type>5)
    options.correction_type=1; % Making default 1
end
ct{1}='tukey-kramer';
ct{2}='dunn-sidak';
ct{3}='bonferroni';
ct{4}='scheffe';
ct{5}='lsd';
options.correction_type=ct{options.correction_type};

if ~isfield(options,'save_figures') || isempty(options.save_figures)
    options.save_figures=1; % Making default 1
end
options.save_figures=options.save_figures==1;

if ~isfield(options,'display_figures') || isempty(options.display_figures)
    options.display_figures=1; % Making default 1
end
options.display_figures=options.display_figures==1;
options.display_figures=1; % temp: making it always 1 for troubleshouting


if ~isfield(options,'plot_uncorrected_NN_other_factor') || isempty(options.plot_uncorrected_NN_other_factor)
    options.plot_uncorrected_NN_other_factor=0; % Making default 0
end
options.plot_uncorrected_NN_other_factor=options.plot_uncorrected_NN_other_factor==1;

if ~isfield(options,'p_th') || isempty(options.p_th)
    options.p_th=0.05; % Making default 0.05
end
if or(options.p_th<0,options.p_th>1)
    error(['p_th provided is ' num2str(options.p_th) '. This valua can not be less than zero or greather than one.'])
end
    
if ~isfield(options,'show_y_scale') || isempty(options.show_y_scale)
    options.show_y_scale=0; % Making default 0
end
options.show_y_scale=options.show_y_scale==1;

if ~isfield(options,'show_p_value') || isempty(options.show_p_value)
    options.show_p_value=1; % Making default 0
end
options.show_p_value=options.show_p_value==1;

if ~isfield(options,'is_connectotyping') || isempty(options.is_connectotyping)
    options.is_connectotyping=0; % Making default 0
end
options.is_connectotyping=options.is_connectotyping==1;

if ~isfield(options,'avoid_main_table') || isempty(options.avoid_main_table)
    options.avoid_main_table=1; % Making default 0
end
options.avoid_main_table=options.avoid_main_table==1;


if ~isfield(options,'use_half_matrix') || isempty(options.use_half_matrix)
    options.use_half_matrix=0; % Making default 0
end
options.use_half_matrix=options.use_half_matrix==1;

% 
% % Pecentile, 0 to 100 to be included in training
% if ~isfield(options,'perc_training') || isempty(options.perc_training);
%     options.perc_training=80;
% elseif options.perc_training<0
%     options.perc_training=10;
% elseif options.perc_training>=100
%     options.perc_training=99;
% end;
% options.perc_training=options.perc_training;
% 
% % Define the minimum set of core_features to start doing SVM
% if ~isfield(options,'core_features') || isempty(options.core_features);
%     options.core_features=round(n_feat/10);
% elseif options.core_features>n_feat
%     options.core_features=n_feat;
% elseif options.core_features<0
%     options.core_features=round(n_feat/10);
% end;
% options.core_features=round(options.core_features);
% 
% % Define how many features to add per set
% if ~isfield(options,'increment_features') || isempty(options.increment_features);
%     options.increment_features=round(n_feat/10);
% end;
% options.increment_features=round(options.increment_features);
% 
% % Define until how many features to include
% if ~isfield(options,'upto_features') || isempty(options.upto_features);
%     options.upto_features=n_feat;
% elseif options.upto_features > n_feat
%     options.upto_features=n_feat;
% elseif options.upto_features<0;
%     options.upto_features=n_feat;
% end;
% options.upto_features=round(options.upto_features);
% 
% % Define the minimum set of core_features to start doing SVM
% if ~isfield(options,'partition') || isempty(options.partition);
%     options.partition='LeaveOut';
% elseif options.partition>n_cases
%     options.partition='LeaveOut';
% elseif options.partition<0
%     options.partition='LeaveOut';
% end;
% 
% 
% % Define how many to optimize svm
% if ~isfield(options,'N_opt_svm') || isempty(options.N_opt_svm);
%     options.N_opt_svm=1;
% elseif options.N_opt_svm<0;
%     options.N_opt_svm=1;
% end;
% options.N_opt_svm=round(options.N_opt_svm);
% 
% 
% % Define if Null hypothesis will be calculated, if not provided, by default
% % will use the number of features with the best out of sample performance
% % to calculate the null hypothesis
% if ~isfield(options,'null_hypothesis') || isempty(options.null_hypothesis);
%     options.null_hypothesis='best';
% elseif ~and(strcmp(options.null_hypothesis,'all'),strcmp(options.null_hypothesis,'none'))
%     options.null_hypothesis='best';
% end
% 
% % Define if ones and zeros need to be balanced
% if ~isfield(options,'balance_1_0') || isempty(options.balance_1_0);
%     options.balance_1_0=1;
% elseif options.balance_1_0>1
%     options.balance_1_0=1;
% elseif options.balance_1_0<0
%     options.balance_1_0=0;
% end;
% options.balance_1_0=round(options.balance_1_0);
% %% unfold variables
% N=options.N;
% perc_training= options.perc_training;
% core_features=options.core_features;
% increment_features=options.increment_features;
% upto_features=options.upto_features;
% partition=options.partition;
% N_opt_svm=options.N_opt_svm;
% balance_1_0=options.balance_1_0;
% null_hypothesis=options.null_hypothesis;
