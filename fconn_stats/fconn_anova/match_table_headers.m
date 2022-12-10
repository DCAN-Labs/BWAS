function [matched_table_headers, matched_p_to_store, matched_DOF]=match_table_headers(table_headers,p_to_store,DOF)

%% Oscar Miranda-Domimguez
% First line of code March 27, 2018
%%
matched_p_to_store=p_to_store;
matched_DOF=DOF;

n1=size(table_headers,1);
n_headers=zeros(n1,1);
for i=1:n1
    n_headers(i)=size(table_headers{i},1);
end

[max_n_headers, ix_max]=max(n_headers);
ix1=find(n_headers<max_n_headers);

master_table_headers=table_headers{ix_max};
for i=1:length(ix1)
    j=ix1(i);
    local_table_headers=table_headers{j};
    local_p=p_to_store{j};
    local_DOF=DOF{j};
    new_p=nan(max_n_headers,1);
    new_DOF=nan(max_n_headers,1);
    for k=1:n_headers(j)
        local_ix=find(ismember(master_table_headers,local_table_headers{k})); % | local_ix is the index in the template table
        new_p(local_ix)=local_p(k);
        new_DOF(local_ix)=local_DOF(k);
    end  
    matched_p_to_store{j}=new_p;
    matched_DOF{j}=new_DOF;
end

matched_p_to_store=cell2mat(matched_p_to_store')';
matched_DOF=cell2mat(matched_DOF')';
matched_table_headers=table_headers{ix_max}';
% whos matched_p_to_store matched_table_headers
