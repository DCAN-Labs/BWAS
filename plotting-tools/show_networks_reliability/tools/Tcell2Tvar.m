function [Tvar, Tix]= Tcell2Tvar(exp_var_table,exp_variance_header)
%% Oscar Miranda-Dominguez
% First line of code: Nov 26, 2021
%%

n_datasets=size(exp_var_table,2);
%% Read raw tables

T_cell=cell(n_datasets,1);
for i=1:n_datasets
    T_cell{i}=readtable(exp_var_table(i).path);
end

%%
cols=size(T_cell,1);
rows=size(T_cell{1},1);

Tvar=nan(rows,cols);
Tix=nan(rows,cols);
Tix(:,1)=1:rows;

% Read data
for i=1:cols
    T=T_cell{i};    
    IX=find_ix_in_header(T,exp_variance_header);
    IX(isnan(IX))=[];
    IX=IX(1);
    if i==1
        row_names=T{:,1};
    else
        for j=1:rows
            Tix(j,i)=find(ismember(T{:,1},row_names{j}));
        end
    end
    
    Tvar(:,i)=T{:,IX};

end

%% Tablify
header_names=cat(1,exp_var_table.title);
Tvar=tablify_T(Tvar,row_names,header_names);
Tix=tablify_T(Tix,row_names,header_names);


