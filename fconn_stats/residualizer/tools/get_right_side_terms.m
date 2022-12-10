function right_side_terms = get_right_side_terms(updated_model)
delimiter='~';
parts = split(updated_model,delimiter);
%%
cat_right_side=parts{2};
cat_right_side=strrep(cat_right_side,' ','');
starts_with_minus=strcmp(cat_right_side(1),'-');
starts_with_plus=strcmp(cat_right_side(1),'+');

if ~or (starts_with_minus,starts_with_plus)
    cat_right_side=['+' cat_right_side];
end

%%
delimiter2=["+","-"];
ix=regexp(cat_right_side,delimiter2);
ix=cell2mat(ix);
n_terms=numel(ix);
right_side_terms=cell(n_terms,1);
from=ix(:);
to=ix(:)-1;
to(1)=[];
to=[to;numel(cat_right_side)];
for i=1:n_terms
    right_side_terms{i}=cat_right_side(from(i):to((i)));
end

%% Look for "exclude" terms
% n=numel(right_side_terms);
% exclude_terms=[];
% delimiter3='-';
% for i=1:n
%     local_text=right_side_terms{i};
%     local_exclude=split(local_text,delimiter3);
%     exclude_terms=[exclude_terms
% end
