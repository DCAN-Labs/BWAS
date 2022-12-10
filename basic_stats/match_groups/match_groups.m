function [cat_results, cat_summaries] = match_groups(tidyData,column_to_group_by,columns_to_be_matched,p_upto)
% outliers_table = match_groups(tidyData,column_to_group_by,columns_to_be_matched)

% column_to_group_by=1;
% columns_to_be_matched=[2 3];
% columns_to_be_matched=[2 3 4];
%%
if nargin<4
    p_upto=0.05;
end
%% Assign index from tidy table to each group
% The cell ix_all has as many elements as groups are. The index within each
% cell corresponds to the index in the tudyTable


labels=table2cell((tidyData(:,column_to_group_by)));
groups=unique(labels);
n_groups=size(groups,1);
ix_all=cell(n_groups,1);
n_subjects=zeros(n_groups,1);
for i=1:n_groups
    ix_all{i}=find(ismember(labels,groups{i}));
    n_subjects(i)=numel(ix_all{i});
end
%% Read data and normalize regardless of label assignment
X=table2array(tidyData(:,columns_to_be_matched));
mu=nanmean(X);
sigma=nanstd(X);
Z=(X-mu)./sigma;
%% Calculate the distance matrix
%
% * First a multidimensional distance object will be made. 
% * The number of dimensions is determined by the number of groups. 
% * The number of elements per dimension is determined by the number of
% participants per group.
% * Then the euclidian distance is calculated for each pair of participants
% from different groups
% * the euclidian distance is made based on the variables to be matched

% This is for 2 groups. TO be expanded
distance=zeros(n_subjects');
for i=1:n_subjects(1)
    ix1=ix_all{1}(i);
    x1=Z(ix1,:);
    for j=1:n_subjects(2)
        ix2=ix_all{2}(j);
        x2=Z(ix2,:);
        distance(i,j)=norm(x1-x2);
    end
end
% To optimize calculation of distance
% IX_text='IX=combvec('
% for i=1:n_groups
%     text_V=['V' num2str(i) '=ix_all{' num2str(i) '};'];
%     eval(text_V);
%     
%     IX_text=[IX_text 'V' num2str(i) '(:)'', '];
% end
% IX_text(end-1:end)=[];
% IX_text=[IX_text ');'];
% eval(IX_text)
%% Find closest matches
n_matches=min(n_subjects);
matched_participants=zeros(n_matches,n_groups);
truncated_distance=distance;
for i=1:n_matches
    [indices, truncated_distance]=get_min_index(truncated_distance);
    local_min_ix=cell2mat(indices)';
    for j=1:n_groups
        matched_participants(i,j)=ix_all{j}(local_min_ix(j));
    end
%     matched_participants(i,:)=cell2mat(indices)';
end

%% Report results as a table
matched_table=match_table(tidyData,matched_participants,groups);

%% Add limiting p-value to the matched_table
[matched_table, ix_p_0_05]=add_limiting_p(matched_table,tidyData,matched_participants,column_to_group_by,columns_to_be_matched);

%%

p=matched_table{:,end-2};
ix_p_0_05=max(find(p>p_upto));
%% cat results
cat_results.tidyData=tidyData;
cat_results.matched_table=matched_table;
cat_results.matched_participants=matched_participants;
cat_results.column_to_group_by=column_to_group_by;
cat_results.columns_to_be_matched=columns_to_be_matched;

%% make summaries and figure for the all matched participants
% cat_summaries_all = make_summaries(cat_results);

%% make summaries and figure for comparisons with p>0.05
figure
cat_summaries = make_summaries(cat_results,ix_p_0_05);

%%
N=size(matched_participants,1);
fb{1}=['there are at least' num2str(N) ' participants per group.'];
fb{2}=['If you include up to ' num2str(ix_p_0_05) ' sorted matched participants,'];
fb{3}=['the groups can be considered balanced, since the min p-value is ' num2str(table2array(matched_table(ix_p_0_05,end-2)))];

disp(fb')

%% combine summaries for output
% cat_summaries=[cat_summaries_all;cat_summaries];

%% Sections below were combined in the function make_summaries

% %% Make histograms to show all provided data and selected participants
% show_hists_provided_selected(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
% f=gcf;
% fig_name=['all_ie_' num2str(n_matches)];
% set(f,'name',fig_name);
% pos=get(f,'position');
% %% Make summary stats | Univariate
% univariate_table=univariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
% %% Make summary stats | Bivariate
% bivariate_table=bivariate_summary(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
% %% Make histograms to show up to ix_p_0_05
% fig_name=['up_to_' num2str(ix_p_0_05)];
% 
% f2=figure('name',fig_name,...
%     'Position',pos)
% 
% upto_part=1:ix_p_0_05;
% show_hists_provided_selected(tidyData,matched_participants(upto_part,:),column_to_group_by,columns_to_be_matched)
% %% Make summary stats | Univariate | ix_p_0_05
% univariate_table=univariate_summary(tidyData,matched_participants(upto_part,:),column_to_group_by,columns_to_be_matched)
% %% Make summary stats | Bivariate | ix_p_0_05
% bivariate_table=bivariate_summary(tidyData,matched_participants(upto_part,:),column_to_group_by,columns_to_be_matched)
