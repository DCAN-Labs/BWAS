
%% Load data
cd /mnt/max/shared/code/internal/utilities/OSCAR_WIP/basic_stats/transform_scores
load('y.mat')

ix=1;
y_model=yt(:,ix);
y_pred=yp(:,ix);

%%
n_model=size(y_model,1);
n_pred=size(y_pred,1);

my_color=[repmat([215,25,28]/255,n_model,1);repmat([44,123,182]/255,n_pred,1)];
labels=[repmat({'model'},n_model,1);repmat({'predict'},n_pred,1)];

group_color_assignment_table=[table(labels) array2table(my_color)];
z_model=zscore(y_model);
z_pred=zscore(y_pred);

y=[y_model;y_pred];
z=[z_model;z_pred];

[f, f2]=show_normalization(y,z,group_color_assignment_table)
%%
t=table(labels,y)
skinny_plot(t,[],'ol_flag',1)
%%

% clf
x{1}=y_model;
x{2}=y_pred;
  options.shown_as='box';
%   options.shown_as='curve';
  options.shown_as='stairs';
  options.shown_as='contour';

% custom_hist(y_model,options)
custom_hist(x,options)
legend('Model','Pred')