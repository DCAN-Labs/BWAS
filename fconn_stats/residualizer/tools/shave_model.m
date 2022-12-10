function [shaved_model, included_mask] = shave_model(prelim_model,updated_model)

%% Find terms on the right side
right_side_terms_template = get_right_side_terms(prelim_model);
right_side_terms = get_right_side_terms(updated_model);
%% Obtained shaved sight side terms
new_right_side_terms=shave_right_side_terms(right_side_terms,right_side_terms_template);

%% Remove + from first term
new_right_side_terms{1}=replace( new_right_side_terms{1} , '+' , '' );
%% update model
shaved_model=update_model_right_side(updated_model,new_right_side_terms);

%% 
if strcmp(right_side_terms_template{1},'+1')
    right_side_terms_template{1}='1';
end
if strcmp(new_right_side_terms{1},'+1')
    new_right_side_terms{1}='1';
end
%% Included mask
included_mask=ismember(right_side_terms_template,new_right_side_terms);