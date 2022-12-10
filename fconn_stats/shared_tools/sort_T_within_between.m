function resorted_T = sort_T_within_between(T,T_column_names_for_within,T_column_names_for_between,T_column_names_for_id)
%%
headers=T.Properties.VariableNames;

if ~iscell(T_column_names_for_within)
    if ~isempty(T_column_names_for_within)
        T_column_names_for_within=cellstr(T_column_names_for_within);
    end
end

if ~iscell(T_column_names_for_between)
    if ~isempty(T_column_names_for_between)
        T_column_names_for_between=cellstr(T_column_names_for_between);
    end
end

try
    ix_header=find(ismember(headers,T_column_names_for_within{1}));
catch
    ix_header=find(ismember(headers,T_column_names_for_between{1}));
end

% Get id to sort

try
    ix_id=find_ix_in_header(T,T_column_names_for_id{1});
catch
    ix_id=find_ix_in_header(T,'id');
end

resorted_T=sortrows(T,[ix_header ix_id]);