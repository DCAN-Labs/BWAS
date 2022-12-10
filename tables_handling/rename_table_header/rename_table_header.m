function updatedT=rename_table_header(T,old_header,new_header)

updatedT=T;
orig_headet_names=T.Properties.VariableNames;

ix=find(ismember(orig_headet_names,old_header));
n_ix=size(ix,2);

for i=1:n_ix
    j=ix(i);
    updatedT.Properties.VariableNames{j}=new_header{i};
end