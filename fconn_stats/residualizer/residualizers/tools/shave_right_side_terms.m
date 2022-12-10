function new_right_side_terms=shave_right_side_terms(right_side_terms,right_side_terms_template)

n=size(right_side_terms,1);
new_right_side_terms=cell(n,1);
for i=1:n
    local_term=right_side_terms{i};
    flag_potential_shave=contains( local_term , '_' );
    if flag_potential_shave
        new_term=compare_shaved_with_template(right_side_terms_template,local_term);
    else
        new_term=local_term;
    end
    new_right_side_terms{i}=new_term;
end

%%
