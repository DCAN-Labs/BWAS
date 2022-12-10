function neg_log10_max_P = get_lines_neg_log10_max_P(IX,...
    pValues,...
    options)


%%

n_th=size(options.percentile,2)+1;

neg_log10_max_P=zeros(n_th,1);


for i=1:n_th
    local_p=pValues(IX(i,:)==1);
    max_local_p=max(local_p);
    neg_log10_max_P(i)=-log10(max_local_p);
end