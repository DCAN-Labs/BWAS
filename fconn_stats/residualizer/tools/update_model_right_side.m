function new_model=update_model_right_side(updated_model,new_right_side_terms)

%% 
delimiter='~';
% parts = split(updated_model,delimiter);
left_side=split(updated_model,delimiter);
left_side=[left_side{1} delimiter];

%%
% left_side=parts{1};

right_side=[' ' strtrim(new_right_side_terms{1})];
for i=2:size(new_right_side_terms,1)
    
    right_side=[ right_side ' ' new_right_side_terms{i}(1) ' ' new_right_side_terms{i}(2:end)];
end

new_model=[left_side right_side];