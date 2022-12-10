function options = read_options_regression_xval(options)
%% Oscar Miranda-Dominguez



%% Assign default values, if not provided and error check
%% Check method
if ~isfield(options,'method') || isempty(options.method)
    options.method='plsr'; % Making default 1    
end

ct{1}='plsr';
ct{2}='tsvd';
if sum(ismember(ct,options.method))==0
    display('Available methods are')
    display(ct)
    error(['unknown method: ' options.method,])
end


%% How many components/SV to preserve

% Define the sorting order of the parcels
if ~isfield(options,'components') || isempty(options.components)
    options.components=1; % 
end
options.components=round(options.components);
%% How many times to make the null

% Define the sorting order of the parcels
if ~isfield(options,'N_Null') || isempty(options.N_Null)
    options.N_Null=1e4; % 
end
options.N_Null=round(options.N_Null);
%% How many repetitions

if ~isfield(options,'N') || isempty(options.N)
    options.N=1000; % 
end
options.N=round(options.N);
%% Cross validation how many samples are left out for xval
if ~isfield(options,'xval_left_N_out') || isempty(options.xval_left_N_out)
    options.xval_left_N_out=1; % Making default 0
end
options.xval_left_N_out=round(options.xval_left_N_out);

%% Comparison method
if ~isfield(options,'comparison_method') || isempty(options.comparison_method)
    options.comparison_method='kolmogorov'; % Making default 1    
end

ct{1}='kolmogorov';
ct{2}='cumulative';
if sum(ismember(ct,options.comparison_method))==0
    display('Available methods are')
    display(ct)
    error(['unknown method: ' options.method,])
end