function axis_room(room)

if nargin<1
    room=10;
end

axis tight
xl=xlim;
yl=ylim;

x=[xl;yl];

r=diff(x,[],2);
delta=(room/100)*r;

for i=1:2
    x(i,1)=x(i,1)-delta(i)/2;
    x(i,2)=x(i,2)+delta(i)/2;
end

set(gca,'xlim',x(1,:))
set(gca,'ylim',x(2,:))