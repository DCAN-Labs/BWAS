function scatter3_as_cube(x,y,z,S,g,color)

%% Oscar Miranda-Dominguez

% g 
%%
if nargin<4
    S=[];
end

if nargin<5
    g=[];
    
end

if nargin<6
    color=[];
end
% rename to scatter3_as_cube
patch_color=[254,230,206;229,245,224;222,235,247]/255;

%% get vectors
[X,Y,Z,xl,yl,zl,x_fake,y_fake,z_fake]=new_xyz(x,y,z);

%% get C from g
C=get_C_from_g(x,g,color);
%% plot

% plot3(X,Y,Z,'.')
% scatter3(X,Y,Z,'.')
scatter3(X,Y,Z,S,C,'filled')

xlim(xl)
ylim(yl)
zlim(zl)

xlabel('X')
ylabel('Y')
zlabel('Z')
box on
grid  on
view(-45,30)
%%
colorize_faces(xl,yl,zl,x_fake,y_fake,z_fake,patch_color);
