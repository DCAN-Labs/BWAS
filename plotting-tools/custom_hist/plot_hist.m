function plot_hist(x_hist,y_hist,options,C,xl)

dx=mean(diff(x_hist));
x=x_hist;
% x=[x(1)-dx; x(:); x(end)+dx];
x=[xl(1); x(:); xl(end)];
y=[0; y_hist(:); 0];

if x(2)==x(1)
    x(2)=[];
    y(2)=[];
end

if x(end)==x(end-1)
    x(end)=[];
    y(end)=[];
end

n_points=1e4;
xx=linspace(x(1),x(end),n_points);
% yy=spline(x,y,xx);
yy=pchip(x,y,xx);
% yy=makima(x,y,xx);
yy(yy<0)=0;
switch options.shown_as
    case 'box'
        edgecolor=C;%
        
        bar(x_hist,y_hist,1,...
            'FaceAlpha',options.alpha,...
            'EdgeColor',C,...
            'FaceColor',C,...
            'LineWidth',options.LineWidth)
    case 'curve'
        area(xx,yy,0,...
            'FaceAlpha',options.alpha,...
            'FaceColor',C,...
            'LineWidth',options.LineWidth)        
        
    case 'stairs'
        stairs(x,y,...
            'color',C,...
            'LineWidth',options.LineWidth)
        
    case 'contour'
        
        plot(xx,yy,...
            'color',C,...
            'LineWidth',options.LineWidth)
        
end

xlim(xl)