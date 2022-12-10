function T=consensus_sig_connection(results,between_design)

sort_results=sortrows(results,'pValue');
sig_ix=find(table2array(sort_results(:,6))<.05);
input_table=sort_results(sig_ix,:);

ginfo(1).names={between_design(1).subgroups.name}';

% ginfo(1).names={between_design(1).subgroups.name}';
ginfo(1).n=size(ginfo(1).names,1);


ncases=2.^nchoosek(ginfo(1).n,2);% base 2 because for each comparison there are 2 possible outcomes: significant or not significant. nchoosek(ginfo(1).n,2) calculates how many pair comparisons can be made
foo=nchoosek(ginfo(1).names,2);% made for temp saving
temp_n=size(foo,1);
arms_comp=cell(temp_n,1);


for i=1:temp_n
    arms_comp{i}=[foo{i,1} '_' foo{i,2}];
end
dx=cat(1,between_design.subgroups.name);
n_dx=length(dx);


temp_conn=unique(input_table.conn);
n=size(temp_conn,1);
p=ones(n,temp_n);

temp_dx=cell(n,n_dx);
temp_largest_p=zeros(n,1);
cell_conn=table2array(input_table(:,1));
cellD1=table2array(input_table(:,2));
cellD2=table2array(input_table(:,3));

n_all=size(cellD2,1);
paired1=cell(n_all,1);
paired2=cell(n_all,1);

for i=1:n_all
    paired1{i}=[cellD1{i} '_' cellD2{i}];
    paired2{i}=[cellD2{i} '_' cellD1{i}];
end
input_table_p=table2array(input_table(:,6));

for i=1:n
    
    local_ix=find(ismember(cell_conn,temp_conn(i)));
    for j=1:length(local_ix)
        local_j1=find(ismember(arms_comp,paired1(local_ix(j))));
        local_j2=find(ismember(arms_comp,paired2(local_ix(j))));
        if local_j1
            p(i,local_j1)=input_table_p(local_ix(j));
        else
            p(i,local_j2)=input_table_p(local_ix(j));
        end
        
    end
end
largest_p=max(p,[],2);
try
    T=table(temp_conn,p(:,1),p(:,2),p(:,3),largest_p);
catch
    T=table(temp_conn);
    T=[T array2table(p) array2table(largest_p)];
end

T.Properties.VariableNames{1}='Connection';
for i=1:temp_n
    T.Properties.VariableNames{i+1}=arms_comp{i};
end

T=sortrows(T,'largest_p');
