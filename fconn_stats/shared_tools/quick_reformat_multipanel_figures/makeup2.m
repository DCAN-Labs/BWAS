%% Read figure content

% First load the figure
clear
n_networks=13;

s=cell(n_networks^2,1);
k=0;
for i=1:n_networks
    for j=i:n_networks
        
        k=sub2ind([n_networks n_networks],i,j);
        s{k}=subplot(n_networks,n_networks,k);
        %         set(gca,'ytick',[])
        
    end
end
%%
fig_name=s{k}.Title.String;
fig_name=fig_name{:};
fig_name(fig_name==' ')='_';
vis_flag='on';

fig_size=[8 8 3 3];% cm
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

copyobj(s{k},f)
delta=0.2;
set(gca,'position',[delta delta 1-2*delta 1-2*delta])
%%


BottomSpace = .05;
TopSpace = 0.25;
LeftSpace=0.32;
RightSpace=0.12;
hight=1;
R=1;
C=1;
BetweenV=0;
BetweenH=0;

k=ones(2,1);
rsel = mod(ceil(k(1)/C-1),R);
csel = mod(k(1)-1,C);
H = (1 - TopSpace-BottomSpace - BetweenV*(R-1))/R;H;
W = (1 - LeftSpace-RightSpace - BetweenH*(C-1))/C;W=W*(diff(k)+1);
B = BottomSpace + (R - rsel -1)*(H+BetweenV);
L = LeftSpace + csel*(W/(diff(k)+1)+BetweenH);

p = [L B W H*hight];
set(gca,'position',p)
%%
k=0;
for i=1:n_networks
    for j=i:n_networks
        
        k=sub2ind([n_networks n_networks],i,j);
        
        fig_name=s{k}.Title.String;
        fig_name=fig_name{:};
        fig_name(fig_name==' ')='_';
        vis_flag='on';
        clf
        copyobj(s{k},f)
        
%         set(gca,'position',[delta delta 1-2*delta 1-2*delta])
        set(gca,'position',[delta delta/2 1-1.5*delta 1-1.5*delta])
        set(gca,'position',p)
        
        set(f,'name',fig_name)
        f.InvertHardcopy = 'off';
        print(fig_name,'-dtiffn','-r300')
%         saveas(f,fig_name,'tiff')
        
    end
end