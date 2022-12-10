%% Readme

% This function is a wrapper to the tool aoctool
%
% It extracts the stats to test for the effect of the interaction in
% different groups

load carsmall

%% See the analysis as done by matlab
[h,atab,ctab,stats] = aoctool(Weight,MPG,Model_Year);
%% This function extract the values

[R, pR, df, SS, MS, F, p]=test_slopes(Weight,MPG,Model_Year)