function suffix=th_names_to_suffix(options)

n_th=numel(options.percentile)+1;
th_names=cell(n_th,1);
suffix=cell(n_th,1);
th_names{1}='Top feature';
numstext=num2str([options.percentile]');
numstext=set_axis_label(options.percentile);
replace_old_new={'%','percent'};
for i=2:n_th
    local_text=['top ' numstext(i-1,:) ' %'];
    th_names{i}=local_text;
end
for i=1:n_th
    suffix{i}=title2filename(th_names(i),'replace_old_new',replace_old_new);
end