%% This is an example to run the function get_score_sample1_in_sample2
%
% This function calculates the dispersion of sample1 using sample2 as
% reference. If sample2 is a single number, the function only cancluates
% the difference between each value in sample1 and the reference number
% used in sample2.
%
% If sample2 is a distribution, the dispersion can be calculated in 2 ways:
%
% -diff, mean and std dev of sample2 is calculated. sample1 is normalized
% using those values
%
% -prob, a probability distribution is fit based on sample2 and the
% WIP likelihood (std  dev) of sample1 based the fit of sample2 is reported

%% Here is an example using 2 random samples


r1=20;
c1=92000;
r2=80;
c2=92000;
sample1=randn(r1,c1);
sample2=rand(r2,c2);

score=get_score_sample1_in_sample2(sample1,sample2,'to_score','diff');

%%
subplot 211
imagesc(sample2);colorbar
subplot 212
imagesc(score);colorbar