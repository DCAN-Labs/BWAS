function new_term=compare_shaved_with_template(right_side_terms_template,local_term)

%% Shave
to_compare=shave_local_term(local_term);

%% Assign default
%%
right_side_terms_template=strtrim(right_side_terms_template);
to_compare=strtrim(to_compare);

ix=ismember(right_side_terms_template,to_compare);
ix=find(ix);
if isempty(ix)
    new_term=local_term;
else
    new_term=right_side_terms_template{ix};
end