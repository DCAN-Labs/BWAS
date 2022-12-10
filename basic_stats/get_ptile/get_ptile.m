function ptile=get_ptile(expirical_data,observation)

[f,p] = ecdf(expirical_data);
f=100*f;

local_ix=find(p>=observation,1);
if ~isempty(local_ix)
    ptile=f(local_ix);
else
    ptile=nan;
end

% plot(f,p)