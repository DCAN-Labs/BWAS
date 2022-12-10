function model=get_default_residualizer_model(ind,T_column_names_for_id,T_column_names_for_between,T_column_names_for_within)

n_between=numel (T_column_names_for_between);
bet_text=T_column_names_for_between{1};
for i=2:n_between
    bet_text=[bet_text ' + ' T_column_names_for_between{i}];
end

% First try
model=['Y1-Y' num2str(numel(ind)) ' ~ 1 + ' bet_text];

% % Add intercept
% model=[model ' + 1'];