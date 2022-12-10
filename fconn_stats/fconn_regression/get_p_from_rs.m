function p=get_p_from_rs(r1,r2,n1,n2,tails)

%r1, correlation 1
%r2, correlation 2,
%n1, sample size 1
% n2, sample size 2
%tails, only takes 1 or 2

if nargin<5
    tails=2;
end


z1=atanh(r1);
z2=atanh(r2);

Z_obs=(z1-z2)/sqrt((1/(n1-3))+(1/(n2-3)));

switch tails
    case 1
        p=1*normcdf(-abs(Z_obs));% one side/tail
        
    case 2
        p=2*normcdf(-abs(Z_obs));% two side/tail
end

%% sometimes lead to p=0. Adding this for numerical stability
% Originally set to 1e-6. Not a good decision since sometimes calculated p values are less than 1e-16 so this affects sorting

if p==0
%    p=1e-16;% O
	p=realmin;
end
