function G=quick_posthoc_fconn_rm_anovan_truncated(global_stats)
mm=global_stats.m;
T=global_stats.results;
%%
G1=T(:,[1 2]);
G2=T(:,[1 3]);
n_rows=size(T,1);

%%
for i=1:n_rows
    local_nn=T{i,1};
    local_group=G1{i,2};
    local_ix1=ismember(mm{:,2},local_nn);
    local_ix2=ismember(mm{:,1},local_group);
    local_ix=and(local_ix1,local_ix2);
    G1(i,3:6)=mm(local_ix,3:end);
    
    local_group=G2{i,2};
    local_ix2=ismember(mm{:,1},local_group);
    local_ix=and(local_ix1,local_ix2);
    G2(i,3:6)=mm(local_ix,3:end);
    
end
%%

for i=3:6
    G1.Properties.VariableNames{i}=[G1.Properties.VariableNames{2} '_' mm.Properties.VariableNames{i}];
    G2.Properties.VariableNames{i}=[G2.Properties.VariableNames{2} '_' mm.Properties.VariableNames{i}];
end

%%
G=[G1 G2(:,2:end)];
%%
G=[G T(:,4:end)];