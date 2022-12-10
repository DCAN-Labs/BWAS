function newStr = strrep_vectorized(str,old,new)

newStr=str;
n_old=size(old);
n_new=size(new);

if n_old== n_new
    for i=1:numel(old)
        newStr=strrep(newStr,old{i},new{i});
    end
end