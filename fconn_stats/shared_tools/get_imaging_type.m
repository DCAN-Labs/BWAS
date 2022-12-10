function [imaging_type, sz] = get_imaging_type(fconn)

%%
[r,c,h]=size(fconn);
if h==1
    n=c;
    imaging_type='2D';
else
    n=r;
    imaging_type='3D'; 
end
sz=[r c];