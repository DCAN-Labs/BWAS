function my_color=neg_pos_cmap(varargin)

%% Oscar Miranda-Dominguez


pos_color=[247,252,253
    229,245,249
    204,236,230
    153,216,201
    102,194,164
    65,174,118
    35,139,69
    0,109,44
    0,68,27]/255;

neg_color=[247,244,249
    231,225,239
    212,185,218
    201,148,199
    223,101,176
    231,41,138
    206,18,86
    152,0,67
    103,0,31]/255;


th=0;
%% Read optional arguments

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'pos_color'
            pos_color=varargin{q+1};
            q = q+1;
            
        case 'neg_color'
            neg_color=varargin{q+1};
            q = q+1;
            
        case 'th'
            th=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
%% Count positive and negative values

orig_map=colormap;
n_orig_map=size(orig_map,1);
minmax=caxis;
ranked_data=linspace(minmax(1),minmax(2),n_orig_map);
n_neg=sum(ranked_data<th);
n_pos=sum(ranked_data>=th);

%% Interpolate positive and negative colors
neg_map=get_local_color(neg_color,n_neg);
neg_map(1,:)=1;
pos_map=get_local_color(pos_color,n_pos);
%% Force zero to be white
pos_map(1,:)=1;
%% Concatenate and export output
my_color=[neg_map(end:-1:1,:);pos_map];
colormap(my_color);


function cmap=get_local_color(local_color,n_points)
cmap=nan(n_points,3);
x=1:size(local_color,1);
xq=linspace(1,size(local_color,1),n_points);
for i=1:3
    cmap(:,i)=interp1(x,local_color(:,i),xq);
end
cmap(cmap<0)=0;
cmap(cmap>1)=1;
