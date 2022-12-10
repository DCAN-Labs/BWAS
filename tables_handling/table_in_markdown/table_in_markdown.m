function md_table=table_in_markdown(t)
%%



data=table2cell(t);
[r,c]=size(data);
try
    headers=t.Properties.VariableNames;
catch
    headers=cell(c,1);
end

% try
%     rows=t.Row;
% catch
%     rows=cell(r,1);
% end
rows=t.Row;
if isempty(rows)
    rows=cell(r,1);
    no_rows=1;
else
    no_rows=0;
end


cat_text=cell(r+2,1);

local_text=['| | '];
if no_rows
    local_text='| ';
end
for j=1:c
    local_text=[local_text headers{j} ' | '];
end
cat_text{1}=local_text;

cat_text{2}=[repmat('| --- :',1,c+1) '|'];
if no_rows
    cat_text{2}=[repmat('| --- :',1,c) '|'];
end

for i=1:r
    local_text=['| ' rows{i} ' | '];
    if no_rows
        local_text='| ';
    end
    for j=1:c
        if isnumeric(data{i,j})
            local_text=[local_text num2format_text(data{i,j}) ' | '];
        else
            local_text=[local_text data{i,j} ' | '];
        end
    end
    cat_text{2+i}=local_text;
end

md_table=cat_text;
for i=1:r+2
    display(md_table{i})
end