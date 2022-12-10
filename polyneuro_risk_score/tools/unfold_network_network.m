function T2 = unfold_network_network(T1)

n=size(T1,1);
names=cell(n,2);

q=T1{:,1};
if iscell(q)
    q=char(q);
end

for i=1:n
    str=q(i,:);
    delimiter='and';
    foo=split(str,delimiter);
    for j=1:numel(foo)
        names(i,j)=strtrim(foo(j));
    end
end
%% Remove empty spaces

% ix=cellfun(@isempty,names);
% names=names(~ix);

T2=[array2table(names) T1(:,2:end)];
T2.Properties.VariableNames{1}='From';
if numel(foo)>1
    T2.Properties.VariableNames{2}='To';
end