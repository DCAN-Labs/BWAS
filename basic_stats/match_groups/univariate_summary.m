function univariate_table=univariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)

%% part of the match_groups function
%
% Oscar Miranda Dominguez, Feb 9, 2019
% if matched_participants is empty, it uses the data from all the
% participants

%%
%%
labels=table2cell((tidyData(:,column_to_group_by)));
groups=unique(labels);
n_groups=size(groups,1);
ix_all=cell(n_groups,1);
n_subjects=zeros(n_groups,1);
for i=1:n_groups
    ix_all{i}=find(ismember(labels,groups{i}));
    n_subjects(i)=numel(ix_all{i});
end
%%
n_vars=numel(columns_to_be_matched);
N=size(matched_participants,1);

n_summary_stats=5;
summary_stats_names=cell(n_summary_stats,1);
i=0;
i=i+1;summary_stats_names{i}='mean';
i=i+1;summary_stats_names{i}='median';
i=i+1;summary_stats_names{i}='std';
i=i+1;summary_stats_names{i}='min';
i=i+1;summary_stats_names{i}='max';

r=n_vars*n_summary_stats;
c=n_groups;

S=zeros(r,c);
ix=1:n_summary_stats;
for i=1:n_vars
    s=zeros(n_summary_stats,1);
    for j=1:n_groups
        if isempty(matched_participants)
            local_ix=ix_all{j};
        else
            local_ix=matched_participants(:,j);
        end
        local_table=tidyData(local_ix,[column_to_group_by columns_to_be_matched(i)]);
        local_data=table2array(local_table(:,end));
        try
            local_data=cell2mat(local_data);
        end
        %         mean(local_data)
        try
            k=0;
            k=k+1;s(k)=nanmean(local_data);
            k=k+1;s(k)=prctile(local_data,50);
            k=k+1;s(k)=nanstd(local_data);
            k=k+1;s(k)=min(local_data);
            k=k+1;s(k)=max(local_data);
            S(ix+n_summary_stats*(i-1),j)=s;
        catch
            1;
        end
    end
end



if isempty(matched_participants)
    S=[n_subjects';S];
else
    S=[repmat(N,1,size(S,2));S];
end

univariate_table=array2table(S);
for j=1:n_groups
    preffix = regexprep(groups{j},' ','_');
    univariate_table.Properties.VariableNames{j}=preffix;
end

c=0;
row_names=cell(r,1);
for i=1:n_vars
    preffix=tidyData.Properties.VariableNames{columns_to_be_matched(i)};
    for j=1:n_summary_stats
        c=c+1;
        row_names{c}=[preffix ', ' summary_stats_names{j}];
    end
end

row_names=['N'; row_names];

univariate_table.Properties.RowNames=row_names;