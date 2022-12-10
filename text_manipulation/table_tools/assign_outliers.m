function T=assign_outliers(T,outliers,id_column)

%% This function takes as input a Table with participants and tests and a structure with the ID and tasks that need to be flagged as outliers


n_outliers=length(outliers);

ids=table2array(T(:,id_column));

for i=1:n_outliers
    ix_test=find(ismember(T.Properties.VariableNames,outliers(i).task));
    ix_id=find(ismember(ids,outliers(i).id));
    T(ix_id,ix_test)=table(1);
end