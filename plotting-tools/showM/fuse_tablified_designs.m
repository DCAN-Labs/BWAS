function T=fuse_tablified_designs(T1,T2)

ix=unique([T1.ix T2.ix]);
n=numel(ix);
ix1=T1.ix;
ix2=T2.ix;
name1=T1.name;
name2=T2.name;

new_name=cell(n,1);
for i=1:n
    local_ix1=find(ismember(ix1,i));
    local_ix2=find(ismember(ix2,i));
    new_name{i}=[name1(local_ix1,:) '_' name2(local_ix2,:)];
end
T=table(new_name,ix);
%%
ix1=T1.ix;
for i=1:2
    T1.Properties.VariableNames{i}=[T1.Properties.VariableNames{i} '_1'];
    T2.Properties.VariableNames{i}=[T2.Properties.VariableNames{i} '_2'];
end

T1=sortrows(T1,2);
T2=sortrows(T2,2);
T=[T T1 T2];