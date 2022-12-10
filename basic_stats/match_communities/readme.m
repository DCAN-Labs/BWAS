%% match_communities

% Use this function to identify the closest communities

% here we assume you have 2 samples, each with a different number of
% subjects but the 2 samples have the same number of observations or
% scores. The scores should be stored as a matrix of size participants x
% scores. In addition, each participant is assigned to a given community.
% Community assignment is provided as a vector where the value of each
% element is the community each participant belongs to

% Inputs
path_scores{1}=which('scores_sample1.mat');
path_scores{2}=which('scores_sample2.mat');

path_communities{1}=which('idx_sample1.mat');
path_communities{2}=which('idx_sample2.mat');

cost_function='kolmogorov_combined';
cost_function='kolmogorov_per_score';
cost_function='median_diff';

[M,...
    matched_communities,...
    new_ix1,...
    new_ix2]=match_communities(path_scores,...
    path_communities,...
    cost_function);
matched_communities