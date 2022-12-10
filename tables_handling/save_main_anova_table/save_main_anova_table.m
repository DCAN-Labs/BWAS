function save_main_anova_table(main_table, filename)

if nargin<2
    filename='main_anova_table.csv';
end

%% Oscar Miranda-Dominguez
% First line of code: July 13, 2020
% Use this function to save an anova_table as csv
T=main_table;
[n_rows, n_col]=size(T);

for i=4:n_col
    temp=table2array(T(:,i));
    temp(3:3:end)=nan;
    temp=table(temp);
    temp.Properties.VariableNames{1}=main_table.Properties.VariableNames{i};
    T(:,i)=[];
    T=[T(:,1:i-1) temp T(:,i:end)];
end

%%

for i=1:n_rows
    row_name=T.Properties.RowNames{i};
    row_name = strrep(row_name,'Error(','Error ');
    row_name = strrep(row_name,'(','');
    row_name = strrep(row_name,')','');
    row_name = strrep(row_name,':',' and ');
    T.Properties.RowNames{i}=row_name;
    
end


writetable(T,filename,'WriteRowNames',true)
% main_table.Properties.RowNames