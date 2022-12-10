function [cat_local_table,cat_local_within_headers,cat_up_to_components,ROI_pair]=prep_scout(main_table, within_headers,fconn_reg_options,ix_to_ix_table)

NN=unique(table2array(within_headers));
n_NN=length(NN);

n_subjects=size(main_table,1);

cat_local_table=cell(n_NN,1);
cat_local_within_headers=cell(n_NN,1);
cat_up_to_components=cell(n_NN,1);
if nargin==4
    n_rows=size(ix_to_ix_table,1);
    ROI_pair=cell(n_NN,n_rows);
end


for k=1:n_NN
    local_tit=NN{k};
    ix=ismember(table2array(within_headers),local_tit);
    n_ix=sum(ix);
    ix=find(ix);
    
    cat_local_table{k}=main_table(:,[1; ix(:)+1]);
    cat_local_within_headers{k}=within_headers(ix,:);
    cat_up_to_components{k}=1:min([n_ix n_subjects-fconn_reg_options.xval_left_N_out])-1;  
    
    if nargin==4
        for i=1:n_rows
            ROI_pair{k,i}=ix_to_ix_table{i,ix}';
        end
    end
end