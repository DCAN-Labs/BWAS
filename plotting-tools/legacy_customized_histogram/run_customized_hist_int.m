accuracy_reshaped = [accuracy(1,:,1) accuracy(1,:,2) accuracy(1,:,3)];
permuted_accuracy_reshaped = [permute_accuracy(1,:,1) permute_accuracy(1,:,2) permute_accuracy(1,:,3)];
accuracy_zscore=accuracy_reshaped/std(final_outcomes);
permuted_accuracy_zscore=(permuted_accuracy_reshaped/std(final_outcomes))
data(:,1)=accuracy_zscore
data(:,2)=permuted_accuracy_zscore
n_bins=21;
%% Define settings for figures 
fig_settings.wide=8; 
fig_settings.hight=8; 
fig_settings.fs_title=20; % font size title
fig_settings.fs_axis=16; % font size axis
fig_settings.fs_legend=16; % font size legend
fig_settings.n_bins=[20];% if empty it will use the sqrt of points
fig_settings.axis_color=[1 1 1]; 
fig_settings.fig_color=[1 1 1];
fig_settings.bar_color=[107,97,149;
192,171,142]/255;
fig_settings.title={'Inattentive model'};
fig_settings.xlabel='Mean absolute error (z-scored)';
fig_settings.ylabel='Frequency';
fig_settings.legend={'Observed','Permuted'};
fig_settings.extra_text={'p<.01'};
fig_settings.fs_extra_text=14;

customized_hist(data,fig_settings);
