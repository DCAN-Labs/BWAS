function local_model=reuse_model_from_rmanova(model,i)

%% Split on ~
delimiter='~';
parts = split(model,delimiter);

%% Replace using provided feature
new=['Y' num2str(i) ' '];
local_model=strrep(model,parts{1},new);