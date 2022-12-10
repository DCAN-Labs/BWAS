function report_used_terms(n,T_included_terms,original_terms,output_folder)

%% Make output folder
suffix='summary_used_terms_mass_univariate';
fs=filesep;
save_folder=[output_folder fs suffix];
if ~isfolder(save_folder)
    mkdir(save_folder)
end
%%
old='+';
new='plus_';
original_terms=strrep(original_terms,old,new);
old='-';
new='minus_';
original_terms=strrep(original_terms,old,new);
T=array2table(T_included_terms);
T.Properties.VariableNames=original_terms;
%%
sum_percent_usage=100*sum(T_included_terms)/n;
sum_percent_usage=array2table(sum_percent_usage);
sum_percent_usage.Properties.VariableNames=original_terms;
%%
sum_percent_usage=100*sum(T_included_terms)/n;
sum_percent_usage=array2table(sum_percent_usage');
sum_percent_usage.Properties.RowNames=original_terms;
sum_percent_usage.Properties.VariableNames{1}='Percent_times_used';
%% Save tables
writetable(T,[save_folder fs 'used_terms.csv']);
writetable(sum_percent_usage,[save_folder fs 'summarry_used_terms.csv'],'WriteRowNames',true);
disp(sum_percent_usage)