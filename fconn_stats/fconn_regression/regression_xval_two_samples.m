function [W,P,performance,Y]=regression_xval_two_samples(X,y,options)

if nargin < 3
    options=[];
end

%% Validate inputs
n=zeros(2,1);
n_feat=zeros(2,1);
a=zeros(2,1);
b=zeros(2,1);
for i=1:2
    [n(i), n_feat(i)]=size(X{i});
    [a(i), b(i)]=size(y{i});
end
  


if prod(a~=n)==1
    error('Verify size of X and y')
end

%% Read options
[options] = read_options_regression_xval(options);

%% Validate sample size and get partitions


[ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions_two_samples(n,options);

%% Calculate the model
is_null=0;
[alt,W,Y.alt]=do_regression_two_samples(X,y,ix_in,ix_out,is_null,options);
performance.alt=alt;
%% Calculate the Null, if required
is_null=1;
[null foo Y.null]=do_regression_two_samples(X,y,ix_in_Null,ix_out_Null,is_null,options);
performance.null=null;

%% Calculate significance
if options.N_Null>0
    P=get_P_two_samples(performance,options);
end

