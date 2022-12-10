function [ix_in,ix_out,ix_in_Null,ix_out_Null,options]=precalculate_partitions(n,options)

%% Get asked partirions
n_in_out=[n-options.xval_left_N_out options.xval_left_N_out];
n_in=n_in_out(1);
n_out=n_in_out(2);

%% Calculate the number of unique combinations


count_unique_combinations = nchoosek(n,n_in_out(2));


%% If N of unique combinations is < N required, then only used the unique combinations

if options.N>=count_unique_combinations
    unique_combinations=combnk(1:n,n_in_out(2));
    N_reps=count_unique_combinations;
    disp(['Only ' num2str(count_unique_combinations) ' repetitions will be made since those are the unique combinations can be made given the partitions']);
    options.N=N_reps;
end
N_reps=options.N;
%% Pre-allocate partitions
ix=1:n;
ix_in=zeros(N_reps,n_in);
ix_out=zeros(N_reps,n_out);
if count_unique_combinations==N_reps
    
    for i=1:N_reps
        ix_out(i,:)=unique_combinations(i,:);
        ix_in(i,:)=find(~ismember(ix,unique_combinations(i,:)));
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
    dummy=randperm(n);%
    ix_in_Null(i,:)=dummy(1:n_in);
    ix_out_Null(i,:)=dummy(end-n_out+1:end);
end
