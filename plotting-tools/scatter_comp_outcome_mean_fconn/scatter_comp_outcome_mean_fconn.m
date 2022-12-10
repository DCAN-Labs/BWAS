function f=scatter_comp_outcome_mean_fconn(Xscores,local_y,mean_fconn,varargin)

%% Oscar Miranda-Dominguez
%%
[r, c] = size(Xscores);
%% Define defaults
% Figure size

h=8;% hight 8 cm
w=4;
fig_size=[8 1 w h];

%
up_to=1;

% save_flag
save_flag=1;
%% Read varargin

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'fig_size'
            fig_size=varargin{q+1};
            q = q+1;
            
        case 'up_to'
            up_to=varargin{q+1};
            q = q+1;
            
        case 'save_flag'
            save_flag=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
save_flag=save_flag==1;
%%
Y=[local_y mean_fconn];
ylab=cell(2,1);
ylab{1}='Outcome';
ylab{2}='Mean func. Conn.';
yl=zeros(2,2);
f=cell(up_to,1);

for i=1:up_to
    fig_name=['scatter_comp_outcome_mean_fconn_Comp_' num2str(i)];
    f{i} = figure('Units','centimeters',...
        'PaperUnits','centimeters',...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'Name',fig_name,...
        'color',[1 1 1]);
    
    X=Xscores(:,i);
    
    for j=1:2
        r=corr(X,Y(:,j));
        subplot(2,1,j)
        scatter(X,Y(:,j),'filled')
        l=lsline;
        l.Color=[1 1 1]*0;
        ylabel(ylab{j})
        title(['R = ' num2str(r,'%4.2f')])
        
        if i==1
            yl(j,:)=ylim;
        end
        
        if j==1
            xl=xlim;
            
        else
            xlim(xl)
            
        end
        xlabel(['Comp. ' num2str(i)])
        ylim(yl(j,:))
        
    end
    
    if save_flag
        f{i}.InvertHardcopy = 'off';
        saveas(gcf,fig_name)
        print(fig_name,'-dpng','-r300')
    end
    
    
end

%%
fig_size=[8 1 6 6];
for i=1:up_to
    fig_name=['scatter_comp_outcome_n_Comp_' num2str(i)];
    ff{i} = figure('Units','centimeters',...
        'PaperUnits','centimeters',...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'Name',fig_name,...
        'color',[1 1 1]);
    
    X=Xscores(:,i);
    
    for j=1
        r=corr(X,Y(:,j));
        scatter(X,Y(:,j),'filled')
        l=lsline;
        l.Color=[1 1 1]*0;
        ylabel(ylab{j})
        title(['R = ' num2str(r,'%4.2f')])
        
        if i==1
            yl(j,:)=ylim;
        end
        
        if j==1
            xl=xlim;
            
        else
            xlim(xl)
            
        end
        xlabel(['Comp. ' num2str(i)])
        ylim(yl(j,:))
        
    end
    
    if save_flag
        f{i}.InvertHardcopy = 'off';
        saveas(gcf,fig_name)
        print(fig_name,'-dpng','-r300')
    end
    
    
end