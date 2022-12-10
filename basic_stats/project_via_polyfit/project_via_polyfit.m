function y2=project_via_polyfit(x1,y1,x2,order)



ix1_out=or(isnan(x1),isnan(y1));
ix1_in=~ix1_out;

p = polyfit(x1(ix1_in),y1(ix1_in),order);


ix2_out=isnan(x2);
ix2_in=~ix2_out;
y2=nan(size(x2));
y2(ix2_in)=polyval(p,x2(ix2_in));