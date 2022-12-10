function data=data_as_cell(orig_data)

if ~iscell(orig_data)
    orig_data=cellstr(orig_data);
end

n=size(orig_data,1);

data=cell(n,1);
for i=1:n
    data{i}=strtrim(orig_data{i});
end