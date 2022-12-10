function [W,P,performance,Y]=regression_xval(X,y,options)

if nargin < 3
    options=[];
end

%% Validate inputs
[n, n_feat]=size(X);
[a b]=size(y);
if a~=n
    error('Verify size of X and y')
end

%% Read options
[options] = read_options_regression_xval(options);

%% Validate sample size and get partitions

[ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions(n,options);

%% Calculate the model
is_null=0;
[alt,W,Y.alt]=do_regression(X,y,ix_in,ix_out,is_null,options);
performance.alt=alt;
%% Calculate the Null, if required
is_null=1;
[null foo Y.null]=do_regression(X,y,ix_in_Null,ix_out_Null,is_null,options);
performance.null=null;

%% Calculate significance
if options.N_Null>0
    P=get_P(performance,options);
end

