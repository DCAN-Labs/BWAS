function [y,T, top_features, max_exp_variance] = read_top_score(path_scores,path_correlation)

%% Use this function to read the scores from the top predictors
%% Example data
% path_scores='C:\Users\oscar\Google Drive\Manuscripts\BWAS_EF\scores_emo_dysreg.csv';
% path_correlation='C:\Users\oscar\Google Drive\Manuscripts\BWAS_EF\correlations_emo_dysreg.csv';

%% Read scores data

t=readtable(path_scores);

%% Select highest explained variance

top=readtable(path_correlation);
header_names='exp_variance';
IX=find_ix_in_header(top,header_names);

exp_variance=top{:,IX};
[max_exp_variance ix_top]=max(exp_variance);
top_features=top{ix_top,1};

text=strsplit(top_features{1},'%');
text=strrep( text{1} , 'top ' , '' );
if contains(text,' ')
    text=strrep( text , ' ' , '' );
else
    num=str2num(text);
    text=num2str(num,'%05.1f');
    text=strrep( text , '.' , '_point_' );
end
all_headers=t.Properties.VariableNames;
ix_header=find(contains(lower(all_headers),lower(text)));
y=t{:,ix_header};
T=t(:,[1 ix_header]);



% text_for_t=strrep( top_features , ' ' , '_' );
% text_for_t=strrep( text_for_t , '.' , '_point_' );
% text_for_t=strrep( text_for_t , '%' , '_percent' )



