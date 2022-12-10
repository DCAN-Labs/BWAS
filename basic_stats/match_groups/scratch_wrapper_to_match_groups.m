N=3;
n=[200 213 225]; % define how many participants per groups
% n=[3 2 2]; % define how many participants per groups
% n=[5000 2000 3000]; % define how many participants per groups
unique_labels{1}='Group A';
unique_labels{2}='Group B';
unique_labels{3}='Group C';
unique_labels{3}='Group B';

offset=[0 -10 -10];
offset=[0 -10 -10]*0;

offset2=[-1 1 0];

y=[];
z=[];
labels=[];
for i=1:N
    y=[y; randn(n(i),1)+offset(i)];
    z=[z; rand(n(i),1)+offset2(i)];
    labels=[labels; repmat(unique_labels{i},n(i),1)];
end

T=table(labels,y,z);
tidyData=T

%%

offset=[0 0 0];
offset2=[0 0 0]*0;

offset3=[0 0 0];

y=[];
z=[];
v=[];
labels=[];
for i=1:N
    y=[y; randn(n(i),1)+offset(i)];
    z=[z; rand(n(i),1)+offset2(i)];
    v=[v; rand(n(i),1)+offset3(i)];
    labels=[labels; repmat(unique_labels{i},n(i),1)];
end

T=table(labels,y,z, v);
tidyData=T
column_to_group_by=1;
columns_to_be_matched=[2 3 4];
%% this is only to be used by Oscar 
clear
clc
Dictionary_filename='C:\Users\Oscar\Box Sync\Dictionary_FOG_foo.csv';
tidyData_filename='C:\Users\Oscar\Box Sync\FOG_foo.csv';
[tidyData, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);


tidyData=tidyData(:,[1 2 3 6 7])
column_to_group_by=2;
columns_to_be_matched=[2 3];
columns_to_be_matched=[3 4 5];
%%
[cat_results, cat_summaries] = match_groups(tidyData,column_to_group_by,columns_to_be_matched);

%% make summaries with fewer participants
up_to=12
extra_cat_summaries = make_summaries(cat_results,up_to);
extra_cat_summaries.matched_table
%% for more than 2 groups

cat_results.tidyData=tidyData;
cat_results.matched_participants=matched_participants;
cat_results.column_to_group_by=column_to_group_by;
cat_results.columns_to_be_matched=columns_to_be_matched;
%%


cat_summaries(2).tidyData=[];
cat_summaries(2).matched_participants=[];
cat_summaries(2).matched_table=[];
cat_summaries(2).univariate_table=[];
cat_summaries(2).bivariate_table=[];
cat_summaries(2).N=[];