function [h,T] = explained_variance_plot(explained_variance,varargin)

%% Oscar Miranda-Dominguez
% First line of code

%% Inputs
% explained_variance:A matrix of size traces X component/variance

%% Define defaults
% Figure size
[r, c] = size(explained_variance);
h=8;% hight 8 cm
w=2+2*(r-1);
fig_size=[8 1 w h];

% save_flag
save_flag=1;

% preffix for naming the figures
tit_preffix='';
%% Read varargin

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'fig_size'
            fig_size=varargin{q+1};
            q = q+1;
            
        case 'save_flag'
            save_flag=varargin{q+1};
            q = q+1;
            
        case 'tit_preffix'
            tit_preffix=varargin{q+1};
            q = q+1;
        
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

save_flag=save_flag==1;
%%


b=cell(r,1);
%% Define size of the figure
fig_name=[tit_preffix 'explained_variance'];
f = figure('Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'Name',fig_name,...
    'color',[1 1 1]);
%% Define colormap

%%
clf

BW=.2;
fs=8;
for i=1:r
    Y=explained_variance(i,:);
    cumm=cumsum(Y);
    if cumm(end)<=0.8
        up_to=numel(cumm);
    else
    up_to=find(cumm>.8,1);
    end
    Y=[Y;Y*nan];
    X=[i;nan];
    
    
    b{i}=bar(X,Y,'stacked');
    b{i}(1).BarWidth=BW;
    
    if i==1
        hold all
    end
    for j=1:c
        b{i}(j).FaceColor=1-explained_variance(i,j)*[1 1 1];
        if j<=up_to
            text(r-BW/2,cumm(j),[num2str(100*cumm(j),'%4.1f') ' %'] ,...
                'HorizontalAlignment','right',...
                'VerticalAlignment','bottom',...
                'fontsize',fs)
        end
    end
    
    
    
    if i==r
        hold off
    end
    
end

line([0 0],[0 1],'color',[1 1 1]*.7,...
    'linewidth',.1)
for i=.2:.2:1
    text(0,i,num2str(100*i),...
        'fontsize',fs-1,...
        'HorizontalAlignment','right',...
        'VerticalAlignment','middle',...
        'fontsize',fs-1)
end
axis off
xlim([0 r+BW]);
set(gca,'xtick',1:r)
set(gca,'xticklabel',[])
h=gcf;

if save_flag
    h.InvertHardcopy = 'off';
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
end
%%
%%
if nargout>1
    T=table([1:c]',100*explained_variance',100*cumm');
    T.Properties.VariableNames{1}='Components';
    T.Properties.VariableNames{2}='Explained_variance';
    T.Properties.VariableNames{3}='Cummulative_Explained_variance';
end