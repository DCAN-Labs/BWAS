function colorize_faces(xl,yl,zl,x_fake,y_fake,z_fake,my_color)

fa=.4;
if nargin<7
    my_color=[254,230,206;229,245,224;222,235,247]/255;
end

xy_color=my_color(1,:);
yz_color=my_color(2,:);
xz_color=my_color(3,:);

%% xy patch

% xy_color=[254,230,206]/255;
xx=xl([1 2 2 1]);
yy=yl([1 1 2 2]);
zz=z_fake([1 1 1 1])';
patch(xx',yy',zz',xy_color,'FaceAlpha',fa)
%% yz patch

% yz_color=[229,245,224]/255;
xx=x_fake([1 1 1 1])';
yy=yl([1 2 2 1]);
zz=zl([1 1 2 2]);


patch(xx',yy',zz',yz_color,'FaceAlpha',fa)
%% xz patch
% xz_color=[222,235,247]/255;

xx=xl([1 2 2 1]);
yy=y_fake([1 1 1 1])';
zz=zl([1 1 2 2]);
patch(xx',yy',zz',xz_color,'FaceAlpha',fa)