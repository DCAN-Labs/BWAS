function cat_summaries = make_summaries(cat_results,N)

% Oscar Miranda-Dominguez



tidyData=cat_results.tidyData;
matched_participants=cat_results.matched_participants;
column_to_group_by=cat_results.column_to_group_by;
columns_to_be_matched=cat_results.columns_to_be_matched;
matched_table=cat_results.matched_table;

if nargin<2
    N=size(matched_participants,1);
end
%%
upto_part=1:N;
matched_participants=matched_participants(upto_part,:);
%% Make histograms to show all provided data and selected participants
show_hists_provided_selected(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
f=gcf;
fig_name=['up_to_' num2str(N)];
set(f,'name',fig_name);
pos=get(f,'position');
%% Make summary stats | Univariate
univariate_table=univariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
%% Make summary stats | Bivariate
bivariate_table=bivariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)

%%
cat_summaries.tidyData=tidyData;
cat_summaries.matched_participants=matched_participants;
cat_summaries.matched_table=matched_table(1:N,:);
cat_summaries.univariate_table=univariate_table;
cat_summaries.bivariate_table=bivariate_table;
cat_summaries.N=N;