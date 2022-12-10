function skinny_limits=get_skinny_limits(Tnorm)
% values=Ttall_norm{:,end};
% values=values(:);
% skinny_limits=prctile(values, [.5 99.5]);

%%
values=Tnorm{:,3:end};
values=prctile(values, [.5 99.5]);
skinny_limits=[min(values(:)) max(values(:))];

scale10=1*skinny_limits;
s=sign(scale10);
scale10=ceil(abs(scale10));
scaledown=scale10/1;
skinny_limits=scaledown.*s;