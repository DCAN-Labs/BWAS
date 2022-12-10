function [MAE]=report_components(cat_mae,cat_n_comp,labels,d)


N=size(cat_mae,1);
all_comp=cellfun(@numel,cat_mae);
max_comp=max(all_comp);

MAE=nan(N,max_comp);
n_COMP=nan(N,max_comp);

min_mae=nan(N,1);
min_comp=nan(N,1);
for i=1:N
    [b,ix]=min(cat_mae{i});
    min_mae(i)=b;
    min_comp(i)=cat_n_comp{i}(ix);
    
    MAE(i,1:all_comp(i))=cat_mae{i};
    n_COMP(i,1:all_comp(i))=cat_n_comp{i};
end

%%
MAE=array2table(MAE);
for i=1:max_comp
    MAE.Properties.VariableNames{i}=['comp_' num2str(i)];
end

for i=1:N
    MAE.Properties.RowNames{i}=char(labels{i,:});
end
%%
MAE=[table(min_mae) table(min_comp) table(d) MAE ];
%%
[B, IX]=sort(min_mae);

MAE=MAE(IX,:);