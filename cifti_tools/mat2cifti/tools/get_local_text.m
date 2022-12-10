function local_text = get_local_text(local_file, i, n)

[root_path filename extension]=fileparts(local_file);
local_text = [num2str(i) ' of ' num2str(n) ': adding '  filename extension];
