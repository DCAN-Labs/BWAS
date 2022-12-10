function options = read_options_explore_parameters_fconn_regression(options)
%% Oscar Miranda-Dominguez

%% Assign default values, if not provided and error check

% Define the # of subjects to leave out for cross validation
if ~isfield(options,'out_for_xval') || isempty(options.out_for_xval)
    options.out_for_xval=1; % sort the parcels as presented in the structure parce
end
if options.out_for_xval<0
    options.out_for_xval=1;
end


% Set unmber of components ti keep in plsr
if ~isfield(options,'n_comp_to_keep') || isempty(options.n_comp_to_keep)
    options.n_comp_to_keep=1; % Making default =1
end
if options.n_comp_to_keep<0
    options.n_comp_to_keep=1;
end

% Define z-score: 0 none, 1: real zscoe, 2: boxcox
if ~isfield(options,'zscoring') || isempty(options.zscoring)
    options.zscoring=1; % Making default 0
end
if and(options.zscoring<0,options.zscoring>2)
    options.zscoring=1; % Making default 1
end


if ~isfield(options,'N') || isempty(options.N)
    options.N=1e4; % Making default 1e4
    
end

if ~isfield(options,'N_Null') || isempty(options.N_Null)
    options.N_Null=1e4; % Making default 1e4
    
end


if ~isfield(options,'save_data') || isempty(options.save_data)
    options.save_data=1; % Making default 1
end
options.save_data=options.save_data==1;

