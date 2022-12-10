function make_save_tables(labels,stat_data,stat_name,column_names)
%% Oscar Miranda Dominguez


for i=1:length(column_names)
    if strcmp(column_names{i},'mse')
        column_names{i}='mean_square_error';
    end
    
    if strcmp(column_names{i},'mae')
        column_names{i}='mean_absolute_error';
    end
    
    if strcmp(column_names{i},'mape')
        column_names{i}='mean_absolute_percent_error';
    end
    
end

for i=1:length(labels)
    foo=labels{i};
    foo(foo==' ')='_';
    labels{i}=foo;
end


T=array2table(stat_data);
T.Properties.VariableNames=column_names;

T=[cell2table(labels) T];
writetable(T,[stat_name '.csv'])