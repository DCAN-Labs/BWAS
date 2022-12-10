function has_variance_flag = has_variance_file(cousin_file)


[ filepath , name , ext ] = fileparts(cousin_file);
old='_mask';
new='_timeseries_variance';
name = strrep( name , old , new );
var_file=[filepath filesep name '.txt'];
has_variance_flag=isfile(var_file);