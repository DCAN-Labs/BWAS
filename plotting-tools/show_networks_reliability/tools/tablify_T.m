function T = tablify_T(T,row_names,header_names)

T=array2table(T);
for i=1:size(T,2)
    T.Properties.VariableNames{i}=header_names(i,:);
end
T.Properties.RowNames=row_names;