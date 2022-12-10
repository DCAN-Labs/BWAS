function patch_plot_empirical_distribution(data,limit,cmap)

%% data contains the structure with the data to be visualized, size is x,y where x is the variable to be showed in the x axis and y are the number of repetitions

if nargin<3
    col_res=1024;
    cmap = gray(col_res);
    
    cmap1=[252,251,253
        239,237,245
        218,218,235
        188,189,220
        158,154,200
        128,125,186
        106,81,163
        84,39,143
        63,0,125]/255;
    cmap1=cmap1(end:-1:1,:);
    
    x1=linspace(0,1,size(cmap1,1));
    x2=linspace(0,1,col_res);
    
    cmap=zeros(col_res,3);
    for i=1:3
        
        cmap(:,i)=spline(x1,cmap1(:,i),x2);
    end
    cmap(cmap<0)=0;
    cmap(cmap>1)=1;
end

if nargin<2
    limit=25;
end
%%
[n_x_ticks,n_rep]=size(data);

before_interpolation(n_x_ticks).f=[];
before_interpolation(n_x_ticks).x=[];

min_y=1e12;
max_y=-1e12;

for i=1:n_x_ticks
    try
    [f, x]=ecdf(data(i,:));
    
    before_interpolation(i).f=f;
    before_interpolation(i).x=x;
    
    local_delta=diff(x);
    local_delta(local_delta==0)=[];
    
    if min(x)<min_y
        min_y=min(x);
    end
    
    if max(x)>max_y
        max_y=max(x);
    end

    end
end

%% interpolate data
bins=2^8;
M=zeros(n_x_ticks,bins);
xq=linspace(min_y,max_y,1024);
for i=1:n_x_ticks
    try
    local_x=before_interpolation(i).x;
    local_y=before_interpolation(i).f;
    
    [C,ia,ic] = unique(local_x);
    local_x=local_x(ia);
    local_y=local_y(ia);
    
    min_ix=find(xq>min(local_x),1);
    max_ix=find(max(local_x)<=xq,1);
    max_ix=max_ix-1;
    
    s = interp1(local_x,local_y,xq(min_ix:max_ix));
    max(s)
    M(i,min_ix:max_ix)=s;
    end

end
%%
Mscaled=abs(M-.5);
Mscaled(Mscaled<limit/100)=limit/100;
imagesc([],xq,Mscaled')
set(gca,'ydir','normal')

colormap(cmap)

h=colorbar;
set( h, 'YDir', 'reverse' );