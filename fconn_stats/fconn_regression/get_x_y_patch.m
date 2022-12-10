function ix=get_x_y_patch(xi,zone)


ix=zeros(2,1);
for j=1:2
    foo=xi-zone(j);
    foo=abs(foo);
    [b, ix(j)]=min(foo);   
end

ix=ix(1):ix(2);