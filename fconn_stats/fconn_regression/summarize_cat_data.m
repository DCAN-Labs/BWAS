function summarize_cat_data(path_to_file,column_x,columns_to_sort_by,p_corrected_flag)

%%
if p_corrected_flag==1
    p_column=5;
else
    p_column=4;
end
%% read the data
catresults = to_import_cat_results(path_to_file);
[r c]=size(catresults);
%% Calculate the unique cases

n_columns_to_sort_by=numel(columns_to_sort_by);
x_axis=table2array(catresults(:,column_x));

to_sort_data=table2array(catresults(:,columns_to_sort_by));
to_sort_labels=catresults.Properties.VariableNames(columns_to_sort_by);

n_unique_sort_data=zeros(n_columns_to_sort_by,1);
unique_sort_data=cell(n_columns_to_sort_by,1);
for i=1:n_columns_to_sort_by
    unique_sort_data{i}=unique(to_sort_data(:,i));
    n_unique_sort_data(i)=numel(unique_sort_data{i});
    
end

n_total_cases=prod(n_unique_sort_data);

to_run='total_cases=combvec(';
for i=1:n_columns_to_sort_by %n_columns_to_sort_by:-1:1
    foo=unique_sort_data{i};
    foo=foo(:)';
    to_run=[to_run '[' num2str(foo) '],'];
end
to_run(end)=[];
to_run=[to_run ');'];
eval(to_run)

total_cases=total_cases';
%% save cases
% cases=cell(n_total_cases,1);

cases(n_total_cases).table=[];
cases(n_total_cases).labels_sorted_by=[];
cases(n_total_cases).values_sorted_by=[];
cases(n_total_cases).p_column=[];
cases(n_total_cases).column_x=[];
cases(n_total_cases).p_corrected_flag=[];

for i=1:n_total_cases
    local_mask=ones(r,1);
    for j=1:n_columns_to_sort_by
        meet_mask=(ismember(to_sort_data(:,j),total_cases(i,j)));
        local_mask=and(local_mask,meet_mask);
    end
    cases(i).table=catresults(local_mask,:);
    cases(i).labels_sorted_by=to_sort_labels;
    cases(i).values_sorted_by=total_cases(i,:);
    cases(i).p_column=p_column;
    cases(i).column_x=column_x;
    cases(i).p_corrected_flag=p_corrected_flag;
end
%% Plot the results

for k=1:n_total_cases
    local_case=cases(k);
    plot_summary_cat_data(local_case)

end