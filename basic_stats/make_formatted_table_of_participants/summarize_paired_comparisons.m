function summarized_paired_comparisons=summarize_paired_comparisons(tidyData,matched_participants,column_to_group_by,columns_to_be_matched,test_2_samples)
%% part of the match_groups function
%
% Oscar Miranda Dominguez, November 1st, 2019

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
% N=size(matched_participants,1);

n_summary_stats=1;
summary_stats_names=cell(n_summary_stats,1);
i=0;
i=i+1;summary_stats_names{i}='p, ttest';
% i=i+1;summary_stats_names{i}='p, Kolmogorov-Smirnov';

%%

% paired_names = combnk(groups,2);
paired_ix = combnk(1:n_groups,2);
n_paired=size(paired_ix,1);
P=nan(n_summary_stats*n_vars,n_paired);

P=cell(n_summary_stats*n_vars,n_paired);

stat=cell(n_summary_stats*n_vars,n_paired);
row_names=cell(n_summary_stats*n_vars,1);

table_column_names=cell(n_paired,1);
for i=1:n_paired
    tempt_text=[groups{paired_ix(i,1)} ' vs ' groups{paired_ix(i,2)}];
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
        
        
        %         [test, stat{i,j}, P(i,j)]=compare_2_groups(x1,x2);
        try
        [test, stat{i,j}, local_p]=compare_2_groups(x1,x2,test_2_samples);
        catch
            local_p=nan;
        end
        P{i,j}=num2format_text(local_p);
        
    end
    row_names{i}=[local_table.Properties.VariableNames{end}];
end
%%
% bivariate_table=array2table(P);
bivariate_table=cell2table(stat);
% bivariate_table=array2table(stat);
bivariate_table.Properties.RowNames=row_names;
bivariate_table.Properties.VariableNames=table_column_names;


%% Get univariate count
univariate_count=cell(n_vars,n_groups);
for i=1:n_vars
    for j=1:n_groups
        local_table=tidyData(:,[column_to_group_by columns_to_be_matched(i)]);
        x=local_table{ix_all{j},end};
        try
            try
                x=cell2mat(x);
            end
        univariate_count{i,j}=[num2str(nanmean(x)), ' (' num2str(nanstd(x)) ')'];
        univariate_count{i,j}=[num2format_text(nanmean(x),'0.1'), ' (' num2format_text(nanstd(x)) ')'];
        catch
            univariate_count{i,j}=' ';
        end
    end
end

univariate_count=array2table(univariate_count);
univariate_count.Properties.RowNames=row_names;
univariate_count.Properties.VariableNames=groups;

%%
n_count=array2table(n_subjects');
n_count.Properties.VariableNames=groups;
n_count.Properties.RowNames={'Count'};

%%
summarized_paired_comparisons=[univariate_count bivariate_table];
summarized_paired_comparisons{end+1,1}={nan};
summarized_paired_comparisons{end,1:n_groups}=table2cell(n_count);
summarized_paired_comparisons.Properties.RowNames(end)=n_count.Properties.RowNames;
summarized_paired_comparisons=summarized_paired_comparisons([end 1:end-1],:);
try
    summarized_paired_comparisons{1,n_groups+1:end}=nan;
end