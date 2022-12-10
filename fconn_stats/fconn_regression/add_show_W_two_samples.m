function add_show_W_two_samples(path_csv)
% 1. Open file
% 1. Read columns
% 1. Select 4kjinmohgv cvbbbbbbbbcf
% path_csv='C:\Users\oscar\Downloads\output_optimized_fconn_regression_Gordon\scout\cat_results_samples_1_2.csv';
%%
T=readtable(path_csv);
%%
% Find headers with mae
mae_header={'min_mae','mae_2_samples'};
IX_mae_header=find_ix_in_header(T,mae_header);
mae_names={'sample 1','sample 2'};
% Assign values
X=T{:,IX_mae_header(1)};
Y=T{:,IX_mae_header(2)};
networks=T.Row;
%% Select p_value
p_value_header={'p_uncorrected_mae_2_samples','p_uncorrected_R'};
suffix_name{1}='_P_colorcoded_mae';
suffix_name{2}='_P_colorcoded_R';
IX_P=find_ix_in_header(T,p_value_header);
p=T{:,IX_P};
%%
[filepath,name,ext] = fileparts(path_csv);
for i=1:2
    W=summary_scatter_color_coded_by_p(X,Y,p(:,i),mae_names,filepath,suffix_name{i});
end
% p=
%%

% W=summary_scatter(X,Y,p,mae_names,filepath);

%% Append weights and save data
try
    new_T=[T table(W)];
    new_T=[new_T table([1:numel(W)]')];
    new_T.Properties.VariableNames{end}='Rank_by_weight';
    new_T.Properties.RowNames=new_T.Row;
    
catch
    new_T=T;% This happens when reruning the code so the table already has W
end
try
new_T.Properties.RowNames=T{:,1};
catch
    new_T.Properties.RowNames=cellstr(num2str(T{:,1}));
end
new_T(:,1)=[]; %To  remove row names
mae_header={'min_mae'};
IX_mae_header=find_ix_in_header(new_T,mae_header);
new_T=sortrows(new_T,IX_mae_header(1),'ascend');

% Save
writetable(new_T,path_csv,'WriteRowNames',true)
%% Make summary table

headers_to_include{1}='min_comp';
headers_to_include{2}='min_mae';
headers_to_include{3}='d';
headers_to_include{4}='mae_2_samples';
headers_to_include{5}='p_uncorrected_mae_2_samples';
headers_to_include{6}='R_alt';
headers_to_include{7}='p_uncorrected_R';
headers_to_include{8}='W';
IX=find_ix_in_header(new_T,headers_to_include);
summary_T=new_T(:,IX(~isnan(IX)));
summary_T.Properties.RowNames=new_T.Properties.RowNames;
new_names{1}='components';
new_names{2}='mae_sample_1';
new_names{3}='effect_size_cohen_d';
new_names{4}='mae_sample_2';
new_names{5}='p_mae_sample_2';
new_names{6}='R_sample_2';
new_names{7}='p_R_sample_2';
new_names{8}='Weights';

summary_T=rename_table_header(summary_T,headers_to_include,new_names);

% save
summary_T_filename=path_csv;
old='cat_results_samples_1_2';
new='summary_2_samples';
summary_T_filename=strrep(summary_T_filename,old,new);
writetable(summary_T,summary_T_filename,'WriteRowNames',true);

% do nothing since that row already exist
%%