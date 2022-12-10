function cat_MAE=concatenate_MAE_tidy(MAE_cell,out_for_xval)

n=size(MAE_cell,1);
if nargin<2
    out_for_xval=1:n;
end


%% Concatenate
cat_MAE=[];
for i=1:n
    MAE=MAE_cell{i};
    MAE=MAE(:,1:3);
    r=size(MAE,1);
    T=table(repmat(out_for_xval(i),r,1));
    T.Properties.VariableNames{1}='out_for_xval';
    MAE=[MAE T];
    for j=1:r
%         MAE.Properties.RowNames{j}=[MAE.Properties.RowNames{j} ', out ' num2str(out_for_xval(i))];
        MAE.Properties.RowNames{j}=[MAE.Properties.RowNames{j}];
    end
    cat_MAE=[cat_MAE; MAE];
end

%% Sort

cat_MAE=sortrows(cat_MAE,3,'descend');