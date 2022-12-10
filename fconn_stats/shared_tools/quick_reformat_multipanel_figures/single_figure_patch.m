%% Read figure content

% First load the figure
clear
ch=get(gcf,'children');
n=size(ch,1);
n_sq=ceil(sqrt(n))
n_networks=n_sq;

s=cell(n,1);
k=0;

for k=1:n
    s{k}=subplot(n_networks,n_networks,k);
end
%%

%%
fig_title=s{k}.Title.String;

fig_name=fig_title(1);
fig_name=fig_name{:};
fig_name(fig_name==' ')='_';

local_ix=find(fig_name==')');
fig_name=fig_name(local_ix+2:end);

vis_flag='on';

fig_size=[8 8  4 4];% cm
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

copyobj(s{k},f)
delta=0.2;
% set(gca,'position',[delta delta 1-2*delta 1-2*delta])
%


BottomSpace = .12;
TopSpace = 0.2;
LeftSpace=0.2;
RightSpace=0.05;
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
xl=xlim;
set(gca,'xlim',[0 xl(2)])
%%
k=0;

for k=1:n
    
    fig_title=s{k}.Title.String;
    
    fig_name=fig_title(1);
    fig_name=fig_name{:};
    fig_name(fig_name==' ')='_';
    
    local_ix=find(fig_name==')');
    fig_name=fig_name(local_ix+2:end);
    
    vis_flag='on';
    clf
    copyobj(s{k},f)
    
    %         set(gca,'position',[delta delta 1-2*delta 1-2*delta])
    set(gca,'position',[delta delta/2 1-1.5*delta 1-1.5*delta])
    set(gca,'position',p)
    
    xl=xlim;
    set(gca,'xlim',[0 xl(2)])
    title(fig_title{2})
    
    set(f,'name',fig_name)
    f.InvertHardcopy = 'off';
    print(fig_name,'-dtiffn','-r300')
end


