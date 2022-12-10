function model=get_default_model(T_column_names_for_outcome,T_column_names_for_id,T_column_names_for_between,T_column_names_for_within)

n_between=numel (T_column_names_for_between);
bet_text=T_column_names_for_between{1};
for i=2:n_between
    bet_text=[bet_text ' + ' T_column_names_for_between{i}];
end

% First try
model=[T_column_names_for_outcome{1} ' ~ ' bet_text];

% add section for neuroimaging data
model=[model '+ brain_feature'];

% Remove intercept
model=[model ' - 1'];