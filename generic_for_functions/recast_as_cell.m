function key_as_cell=recast_as_cell(key)

key_as_cell=key;
if ~iscell(key)
    try
        key_as_cell=cellstr(key);
    catch
        key_as_cell=num2cell(key);
    end
end