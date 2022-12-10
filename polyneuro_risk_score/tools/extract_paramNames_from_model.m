function paramNames=extract_paramNames_from_model(model)
%%
delimiter='~';
paramNames=split(model,delimiter);
paramNames=paramNames(1);
paramNames=[paramNames ;get_right_side_terms(model)];

old='+';
new='';
paramNames = strrep(paramNames,old,new);

old='-';
new='';
paramNames = strrep(paramNames,old,new);

old=' ';
new='';
paramNames = strrep(paramNames,old,new);

to_kill=strcmp(paramNames,'1');
paramNames(to_kill)=[];


to_kill=strcmp(paramNames,1);
paramNames(to_kill)=[];