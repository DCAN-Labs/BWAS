function [fconn_data,between_design,within_design,ix_to_ix]=unfold_global_stats_for_posthocs(t,within,ix_to_ix_table)
%% Oscar Miranda Dominguez
% First line of code: Feb 23, 2018

%% get within design
if size(within,2)>1
    within_design.name=within.Properties.VariableNames{2};
    name=table2array(unique(within(:,2),'stable'));
    n_within=length(name);
    for i=1:n_within
        within_design.subgroups(i).name=name{i};
    end
else
    within_design=[];
    n_within=1;
end

%% get between_design
between_design.name=t.Properties.VariableNames{1};
name=table2array(unique(t(:,1),'stable'));
n_between=length(name);

between_base=cell(n_between,1);
for i=1:n_between
    between_design.subgroups(i).name=name{i};
    between_base{i}=find(ismember(table2array(t(:,1)),name{i}))';
    between_design.subgroups(i).ix=between_base{i};
    between_design.subgroups(i).ix=[];
end
%% unfold within factor into fconn_data
x=[1 2 3 4 5 6 ;7 8 9 10 11 12;13 14 15 16 17 18;19 20 21 22 23 24];%% proof of concept
x=table2array(t(:,2:end));

[r, c]=size(x);

foo_ix=1:c;
foo_ix=reshape(foo_ix,c/n_within,n_within)';
xx=zeros(r*n_within,c/n_within);
local_ix=1:r;
for i=1:n_within
    xx(local_ix,:)=x(:,foo_ix(i,:));
    
    within_design.subgroups(i).ix=local_ix;
    
    for j=1:n_between
        between_design.subgroups(j).ix=[between_design.subgroups(j).ix between_base{j}+r*(i-1)];
    end
    
    
    local_ix=local_ix+r;
         
end
fconn_data=xx;

ix_to_ix=table2array(ix_to_ix_table(:,1:c/n_within));