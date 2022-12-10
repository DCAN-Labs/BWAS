function [P_unc var_names]=table2matrix(posthoc_3F_RM_by_connections)

%%
pTable=posthoc_3F_RM_by_connections.p_uncorrected;
IX=posthoc_3F_RM_by_connections.IX;
ix=cat(3,IX{:});
ix=squeeze(ix(:,1,:))';

n_rois=max(ix(:));

%%
var_names=pTable.Properties.VariableNames;
n_var=size(var_names,2);
for i=1:n_var
    foo=var_names{i};
    if regexp(foo,'conn_')
        var_names{i}=foo(6:end);
    end
    if regexp(foo,'_conn')
        var_names{i}=foo(1:end-5);
    end
end

P_unc=zeros(n_rois,n_rois,n_var);
%%
n_unique_conn=size(pTable,1);
conn=pTable.Properties.RowNames;

conn_num=zeros(n_unique_conn,1);
conn_ij=zeros(n_unique_conn,2);

for i=1:n_unique_conn
    foo=conn{i};
    conn{i}=foo(6:end);
    conn_num(i)=str2double(conn{i});
    conn_ij(i,:)=ix(conn_num(i),:);
    ii=ix(conn_num(i),1);
    jj=ix(conn_num(i),2);
    for j=1:n_var
        P_unc(ii,jj,j)=table2array(pTable(i,j));
        P_unc(jj,ii,j)=table2array(pTable(i,j));
    end
end
%% for validation

pTable=[pTable table(conn_num) table(conn_ij)];

%%
