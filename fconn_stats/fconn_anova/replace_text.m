function edited=replace_text(original,to_find,to_replace)

n=size(original,1);
edited=original;
for i=1:n
    local_text=original{i};
    edited{i}=strrep(local_text,to_find,to_replace);
end