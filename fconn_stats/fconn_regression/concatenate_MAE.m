function cat_MAE=concatenate_MAE(MAE_cell,out_for_xval)

n=size(MAE_cell,1);
if nargin<2
    out_for_xval=1:n;
end


%% Concatenate
cat_MAE=[];
for i=1:n
    MAE=MAE_cell{i};
    MAE=sortrows(MAE,'RowNames');
    MAE=MAE(:,1:3);
    for j=1:3
        MAE.Properties.VariableNames{j}=[MAE.Properties.VariableNames{j} '_out_' num2str(out_for_xval(i))];
    end
    cat_MAE=[cat_MAE MAE];
end
%% Find min MAE 
min_mae=cat_MAE{:,1:3:end};
min_mae=min(min_mae,[],2);
min_mae=table(min_mae);

%% Find max d
max_d=cat_MAE{:,3:3:end};
max_d=max(max_d,[],2);
max_d=table(max_d);

%%
to_try=cat_MAE{:,2:3:end};
m=size(to_try,1);
n_comp=cell(m,1);
for i=1:m
    n_comp{i}=unique(to_try(i,:));
end
n_comp_to_try=table(n_comp);


cat_MAE=[cat_MAE min_mae max_d n_comp_to_try];

%% Sort

cat_MAE=sortrows(cat_MAE,size(cat_MAE,2)-1,'descend');