function [T, Y] = read_ys(path_pred_results)

%% load the data
load(path_pred_results,'Y')

y_real=Y{1}.alt.observed;
y_real=y_real(:);
y_pred=Y{1}.alt.predicted;
y_pred=y_pred(:);

%%
T=table(y_real,y_pred);