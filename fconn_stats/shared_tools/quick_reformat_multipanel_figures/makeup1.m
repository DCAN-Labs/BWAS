%% Read figure content

% First load the figure
clear

s=cell(n_networks^2,1);
k=0;
for i=1:n_networks
    for j=i:n_networks
        
        k=sub2ind([n_networks n_networks],i,j);
        s{k}=subplot(n_networks,n_networks,k);
        set(gca,'ytick',[])
        
    end
end
%% Define settings for the subplots

BottomSpace = 0.0600;
TopSpace = 0.02;
LeftSpace=0.03;
RightSpace=0.02;
BetweenH=0.015;
BetweenV=0.02;

R=n_networks;
C=n_networks;

hight=1;

k=0;
for i=1:n_networks
    for j=i:n_networks
        
        k=sub2ind([n_networks n_networks],i,j);
        ii=zeros(2,1);
        ii(:)=k;
        k=ii;
        
        
        hight=1;
        
        
        rsel = mod(ceil(k(1)/C-1),R);
        csel = mod(k(1)-1,C);
        H = (1 - TopSpace-BottomSpace - BetweenV*(R-1))/R;H;
        W = (1 - LeftSpace-RightSpace - BetweenH*(C-1))/C;W=W*(diff(k)+1);
        B = BottomSpace + (R - rsel -1)*(H+BetweenV);
        L = LeftSpace + csel*(W/(diff(k)+1)+BetweenH);
        
        p = [L B W H*hight];
        
        
        set(s{k(1)},'position',p);
        
        s{k(1)}.XAxis.FontSize=7;
        
        s{k(1)}.Title.FontSize=6;
        s{k(1)}.XLabel.FontSize=s{k(1)}.YLabel.FontSize;
        
        
    end
end