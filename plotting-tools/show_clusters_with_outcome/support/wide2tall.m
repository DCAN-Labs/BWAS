function Ttall=wide2tall(Twide,outcome_headers)


IX=find_ix_in_header(Twide,outcome_headers);
n_outcomes=numel(IX);
[r,c]=size(Twide);

VALUES=Twide{:,IX};
OUTCOME=repmat(outcome_headers,r,1);


n_others=c-n_outcomes;
pre=cell(n_outcomes*r,n_others);


ix=find(~ismember(Twide.Properties.VariableNames,outcome_headers));
for i=1:n_others
    j=ix(i);
    temp=repmat(Twide{:,j},1,n_outcomes);
    pre(:,i)=temp(:);
end

Ttall=[cell2table(pre) table(OUTCOME(:),VALUES(:))];
for i=1:n_others
    j=ix(i);
    Ttall.Properties.VariableNames{i}=Twide.Properties.VariableNames{:,j};
end
Ttall.Properties.VariableNames{end-1}='Behavior';
Ttall.Properties.VariableNames{end}='Score';
