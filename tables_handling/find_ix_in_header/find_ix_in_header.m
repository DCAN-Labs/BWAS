function IX=find_ix_in_header(T,header_names)

if ~iscell(header_names)
    header_names=cellstr(header_names);
end

n_header_names=numel(header_names);
all=T.Properties.VariableNames;

IX=nan(n_header_names,1);

for i=1:n_header_names
    try
        local_value=find(ismember(all,header_names{i}));
        
    catch
        local_value=find(ismember(all,header_names(i,:)));
    end
    if isempty(local_value)
        IX(i)=nan;
    else
        IX(i)=local_value;
    end
end