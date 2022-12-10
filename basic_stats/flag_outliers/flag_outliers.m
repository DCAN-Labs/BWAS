function outlier_table = flag_outliers(T,columns_to_group_by,columns_to_be_tested)
%% outliers = flag_outliers(table,columns_to_group_by);
%
% THis function takes as input a table (T) and look for outliers adfer grouping
% data using the columns specified by the second argument. OL detection is
% made using Matlab's built-in capabilities

% Input variables
%   T, table with data
%
%   columns_to_group_by, indicates the columns with variables to be used to
%   group the data by
%
%   columns_to_be_tested, indicates the columns with data to be analyzed
%% Define outlier threshold
ol_th=4;
%% Check table size
[r,c]=size(T);

%% Identify groups
n_variables=length(columns_to_group_by);
variables(n_variables).name=[];
variables(n_variables).n_values=[];
variables(n_variables).values=[];
variables(n_variables).ix=[];


for i=1:n_variables
    local_ix=columns_to_group_by(i);
    variables(i).name=T.Properties.VariableNames{local_ix};
    values=table2array(unique(T(:,local_ix)));
    n_values=size(values,1);
    variables(i).n_values=n_values;
    variables(i).values=values;
    
    ix=zeros(r,n_values);
    for j=1:n_values
        try
            ix(:,j)=ismember(table2array(T(:,local_ix)),values{j});
        catch
            ix(:,j)=ismember(table2array(T(:,local_ix)),values(j,:),'rows');
        end
    end
    variables(i).ix=ix;
end

%% Count combinations
n_values=cat(1,variables.n_values);
n_total_combinations=prod(n_values);

to_run='combined_ix=combvec(';
for i=1:n_variables %n_columns_to_sort_by:-1:1
    foo=1:n_values(i);
    foo=foo(:)';
    to_run=[to_run '[' num2str(foo) '],'];
end
to_run(end)=[];
to_run=[to_run ');'];
eval(to_run)

%% St
n_columns_to=length(columns_to_be_tested);
Z=T;
outlier_table=T;
outlier_table(:,:)=[];
outlier_table=[outlier_table table([])];

outlier_var_name='outlier_var';
outlier_table.Properties.VariableNames{end}=outlier_var_name;
for i=1:n_total_combinations
    logical_mask=ones(r,1)==1;
    for j=1:n_variables
        local_ix=combined_ix(j,i);
        local_mask=variables(j).ix(:,local_ix);
        logical_mask=and(logical_mask,local_mask) ;
    end
    local_table=T(logical_mask,:);
    %
    for j=1:n_columns_to
        k=columns_to_be_tested(j);
        try
            y=table2array(local_table(:,k));
        catch
            y=cell2mat(table2array(local_table(:,k)));
        end
        z=zscore(y);
        Z(logical_mask,k)=table(z);
        ix_outlier=isoutlier(y,'gesd');
        %
        if sum(ix_outlier)>0
%         id=table({repmat(local_table.Properties.VariableNames{columns_to_be_tested(j)},sum(ix_outlier),1)});
        id=table(repmat({local_table.Properties.VariableNames{columns_to_be_tested(j)}},sum(ix_outlier),1));
        id.Properties.VariableNames{end}=outlier_var_name;
        outlier_table=[outlier_table;[local_table(ix_outlier,:) id]];
        end
        %
        
%         for ii=1:length(ix_outlier)
%             %         outlier_table=[outlier_table(:.1:end-1)
%             %         ix_outlier
%         end
        
    end
    
end




% sorted_outlier_table=outlier_table;
% for i=1:n_variables
%     sorted_outlier_table=sortrows(sorted_outlier_table,columns_to_group_by(i));
% end