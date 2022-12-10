function [cat_results, cat_summaries] = summary_stats_from_table(tidyData,column_to_group_by,columns_to_be_matched)

%%Oscar Miranda-Dominguez

%% This function visualize uni and bi-variate stats from unmatched data

%%
matched_participants=[];
%% Make histograms to show all provided data and selected participants
show_hists_provided_selected(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
f=gcf;
fig_name=['all' ];
set(f,'name',fig_name);
pos=get(f,'position');
%% Make summary stats | Univariate
univariate_table=univariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
%% Make summary stats | Bivariate
bivariate_table=bivariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
%%
%% cat results
cat_results.tidyData=tidyData;
cat_results.matched_table=[];
cat_results.matched_participants=[];
cat_results.column_to_group_by=column_to_group_by;
cat_results.columns_to_be_matched=columns_to_be_matched;

%%
cat_summaries.tidyData=tidyData;
cat_summaries.matched_participants=[];
cat_summaries.matched_table=[];
cat_summaries.univariate_table=univariate_table;
cat_summaries.bivariate_table=bivariate_table;
cat_summaries.N=[];