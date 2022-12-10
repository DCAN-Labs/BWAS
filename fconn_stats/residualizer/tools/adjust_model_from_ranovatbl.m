function updated_model=adjust_model_from_ranovatbl(model,ranovatbl)
%%
p_th=0.05;
row_to_include=ranovatbl.pValue<p_th;
row_names=ranovatbl.Properties.RowNames;
row_names_to_include=row_names(row_to_include);
n_significant_factors=numel(row_names_to_include);

delimiter='~';
left_side=split(model,delimiter);
left_side=[left_side{1} delimiter];

delimiter=':';
text_to_exclude=split(row_names_to_include{end},delimiter);
text_to_exclude=[':' text_to_exclude{end}];

right_side=row_names_to_include{1};

for i=2:n_significant_factors
    right_side=[right_side ' + ' row_names_to_include{i}];
end
right_side = strrep(right_side,text_to_exclude,'');

% Dealing with intercept
if contains(right_side,'(Intercept)')
    right_side = strrep(right_side,'(Intercept)',' 1');
else
    right_side=[right_side '-1'];
end

updated_model=[left_side right_side];