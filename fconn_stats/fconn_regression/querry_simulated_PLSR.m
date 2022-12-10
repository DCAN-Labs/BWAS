function T=querry_simulated_PLSR(path_results,target_d)

% target_d=1.16;
% path_results='V:\FAIR_HORAK\Projects\Martina_RO1\Experiments\simulated_performance\open\system_pair_ReT_and_Sal_n_rep_100_add_noise_flag_1_xval_for_sim_same\ReT_and_Sal.mat'
load(path_results)

ss=unique(data(1).x);
n_ss=size(ss,1);
ptiles=zeros(n_ss,1);
R=zeros(n_ss,3);

x=data(1).x;
d=data(1).y;
for i=1:n_ss
    ix=find(x==ss(i));
    local_d=d(ix);
    ptiles(i)=get_ptile(local_d,target_d);
    R(i,1)=nanmin(local_d);
    R(i,2)=nanmedian(local_d);
    R(i,3)=nanmax(local_d);
end
%%
T=table(ss,target_d*ones(n_ss,1),R,ptiles);
T.Properties.VariableNames{1}='Sample_size';
T.Properties.VariableNames{2}='Targed_d';
T.Properties.VariableNames{3}='Range_d_min_med_max';
T.Properties.VariableNames{4}='Percentile_for_target_d';
T=T(:,[1 2 4 3]);
filename='target_d.csv';
writetable(T,filename)
