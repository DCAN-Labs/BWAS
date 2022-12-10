function IX=index_for_subsampling_surrogate_data(ss_to_explore,n_surr_subjects,n_rep,fconn_reg_options)

n_ss_to_explore=size(ss_to_explore,1);
IX=cell(n_ss_to_explore,1);

for i=1:n_ss_to_explore
    local_n=ss_to_explore(i);
    local_ix=zeros(n_rep,local_n);
    for j=1:n_rep
    ix=randperm(n_surr_subjects);
    local_ix(j,:)=ix(1:local_n);
    end
    IX{i}=local_ix;
end