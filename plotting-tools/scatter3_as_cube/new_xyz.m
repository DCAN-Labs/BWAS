function [X,Y,Z,xl,yl,zl,x_fake,y_fake,z_fake]=new_xyz(x,y,z)

%% Reshape
x=x(:);
y=y(:);
z=z(:);
n=size(x,1);

%% get limits
xy_lims=get_limits(x,y);
xz_lims=get_limits(x,z);
yz_lims=get_limits(y,z);

xl=[xy_lims(1,:);xz_lims(1,:)];
xl=mean(xl);

yl=[xy_lims(2,:);yz_lims(1,:)];
yl=mean(yl);

zl=[xz_lims(2,:);yz_lims(2,:)];
zl=mean(zl);

x_fake=max(xl);
y_fake=max(yl);
z_fake=min(zl);

x_fake=ones(n,1)*x_fake;
y_fake=ones(n,1)*y_fake;
z_fake=ones(n,1)*z_fake;

xyz=[x y z_fake;x y_fake z;x_fake y z];
X=xyz(:,1);
Y=xyz(:,2);
Z=xyz(:,3);