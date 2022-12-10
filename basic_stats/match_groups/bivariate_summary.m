function bivariate_table=bivariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
%% part of the match_groups function
%
% Oscar Miranda Dominguez, Feb 9, 2019

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

n_summary_stats=2;
summary_stats_names=cell(n_summary_stats,1);
i=0;
i=i+1;summary_stats_names{i}='p, ttest';
i=i+1;summary_stats_names{i}='p, Kolmogorov-Smirnov';

%%

paired_names = combnk(groups,2);
paired_ix = combnk(1:n_groups,2);
n_paired=size(paired_names,1);
P=nan(n_summary_stats*n_vars,n_paired);
row_names=cell(n_summary_stats*n_vars,1);

table_column_names=cell(n_paired,1);
for i=1:n_paired
    tempt_text=[paired_names{i,1} ' vs ' paired_names{i,2}];
    tempt_text = regexprep(tempt_text,' ','_');
    table_column_names{i}=tempt_text;
end

c=0;
for i=1:n_vars
    local_table=tidyData(:,[column_to_group_by columns_to_be_matched(i)]);
    for j=1:n_paired
        
        if isempty (matched_participants)
            ix1=ix_all{paired_ix(j,1)};
            ix2=ix_all{paired_ix(j,2)};
        else
            ix1=matched_participants(:,paired_ix(j,1));
            ix2=matched_participants(:,paired_ix(j,2));
        end
        x1=table2array(local_table(ix1,end));
        x2=table2array(local_table(ix2,end));
        
        [h, pt]=ttest2(x1,x2);
        [h, pk]=kstest2(x1,x2);
        P(c+[1 2])=[pt pk];
        row_names{c+1}=[local_table.Properties.VariableNames{end} ', ' summary_stats_names{1}];
        row_names{c+2}=[local_table.Properties.VariableNames{end} ', ' summary_stats_names{2}];
        c=c+n_summary_stats;
    end
end

bivariate_table=array2table(P);
bivariate_table.Properties.RowNames=row_names;
bivariate_table.Properties.VariableNames=table_column_names;