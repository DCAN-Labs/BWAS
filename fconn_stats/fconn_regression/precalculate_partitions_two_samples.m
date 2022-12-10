function [ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions_two_samples(n,options)

%% Get asked partirions
% n_in_out=[n-options.xval_left_N_out options.xval_left_N_out];
% n_in=n_in_out(1);
% n_out=n_in_out(2);


n_in=n(1);
n_out=0;
%% Calculate the number of unique combinations
unique_combinations=combnk(1:n(1),n(1));

%% If N of unique combinations is < N required, then only used the unique combinations
N_reps=min(options.N,size(unique_combinations,1));
if options.N~=N_reps
    disp(['Only ' num2str(size(unique_combinations,1)) ' repetitions will be made since those are the unique combinations can be made given the partitions']);
    options.N=N_reps;
end

%% Pre-allocate partitions
ix=1:n;
ix_in=zeros(N_reps,n_in);
ix_out=zeros(N_reps,n_out);
if size(unique_combinations,1)==N_reps
    
    for i=1:N_reps
        ix_in(i,:)=unique_combinations(i,:);
        ix_out(i,:)=[];
    end
else
    for i=1:N_reps
%         dummy=randi(n,[n 1]);% originally coded this way
        dummy=randperm(n);%
        ix_in(i,:)=dummy(1:n_in);
        ix_out(i,:)=dummy(end-n_out+1:end);
    end
end
%% Pre-allocate partitions for Null

N_reps=options.N_Null;

ix_in_Null=zeros(N_reps,n_in);
ix_out_Null=zeros(N_reps,n_out);

for i=1:N_reps
%     dummy=randi(n,[n 1]);% originally coded this way
    dummy=randperm(n(1));%
    ix_in_Null(i,:)=dummy(1:n_in);
    ix_out_Null(i,:)=dummy(end-n_out+1:end);
end
