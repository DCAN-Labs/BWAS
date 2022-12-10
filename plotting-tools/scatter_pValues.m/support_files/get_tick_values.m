function [tick_values th_names]=get_tick_values(p,options)
n_th=numel(options.percentile)+1;

% n_features=prod(sz);
n_features=numel(p);
tick_values=[max(p) prctile(p,100-options.percentile)];

%% Th names
th_names=cell(n_th,1);
th_names{1}='Top feature';
numstext=num2str([options.percentile]');
numstext=set_axis_label(options.percentile);
for i=2:n_th
    local_text=['top ' numstext(i-1,:) ' %'];
    th_names{i}=local_text;
end