function [sum_stats, metrics]=summarize_data(R)


%% sum_stats=summarize_data(R)


%% Oscar Miranda-Dominguez
% First line of code: March 2nd, 2020

%% Calculated values:
% - min
% - max
% - mean
% - median
% - std deviation
% - percentile 25
% - percentile 75

%%
n=size(R,2);

sum_stats=zeros(9,n);
sum_stats(1,:)=nanmin(R);
sum_stats(2,:)=nanmax(R);
sum_stats(3,:)=nanmean(R);
sum_stats(4,:)=nanmedian(R);
sum_stats(5,:)=nanstd(R);
sum_stats(6,:)=prctile(R,25);
sum_stats(7,:)=prctile(R,75);
sum_stats(8,:)=prctile(R,2.5);
sum_stats(9,:)=prctile(R,97.5);

metrics=cell(9,1);
i=0;
i=i+1;metrics{i}='min';
i=i+1;metrics{i}='max';
i=i+1;metrics{i}='mean';
i=i+1;metrics{i}='median';
i=i+1;metrics{i}='std. dev.';
i=i+1;metrics{i}='percentile 25';
i=i+1;metrics{i}='percentile 75';
i=i+1;metrics{i}='percentile 2.5';
i=i+1;metrics{i}='percentile 97.5';
