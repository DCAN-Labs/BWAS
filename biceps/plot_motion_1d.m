function plot_motion_1d(FD,n,FD_TR,time_min)
[r c]=size(FD);
if r==n
    FD=FD';
end
raw_FD=FD;
th_min=floor(time_min*60/FD_TR);
FD(FD<=th_min)=0;
FD_sorted=FD;
ticks=size(FD,1);
fds=linspace(0,0.5,ticks);

survivors=sum(FD>0,2);
neighbors=(-3:3)*.5; %lapsed time in minutes
n_neighbors=length(neighbors);
ths=time_min+neighbors;
%%

% subplot('position',[0.1100    0.5300    0.3900    0.3700])
subplot 221
% subplot('position',[.1 .6 .85 .35])
stairs(fds,survivors)
grid on
axis tight
ylabel(['Survivors (@ ' num2str(time_min) ' min)'])
xlabel('FD')

% subplot('position',[0.1100    0.1300    0.3900    0.3700])
subplot 223
% plot(fds,y)
ix_s=survivors>0;

dummy_FD=FD;

y=zeros(ticks,5);
% y=prctile(FD,[0 25 50 75 100],2)*FD_TR/60;
FD_sorted(FD_sorted==0)=nan;
y(ix_s>0,:)=prctile(FD_sorted(ix_s,:),[0 25 50 75 100],2)*FD_TR/60;
% patch([fds fds(end:-1:1)],[y(:,1)' y(end:-1:1,5)'],'red')
% hold on

% plot(fds(ix_s),FD_sorted(ix_s,:)*FD_TR/60,'.b')
% % hold off
% xlabel('FD')
% ylabel('Time (min)')
% set(gca,'ydir','reverse')
% % axis tight
% xlim([min(fds) max(fds)])
% ylim([0 max(FD_sorted(:))*FD_TR/60])
% set(gca,'xticklabel',[])
% set(gca,'xaxisLocation','top')
% grid on
%% WIP
% line([fds; fds]',[y(:,1) y(:,end)]','color','b')

%%
plot(fds,y(:,3),'r+')
line([fds; fds],[y(:,1) y(:,end)]','color','b','linestyle','-')
line([fds; fds],[y(:,2) y(:,end-1)]','color','b','linewidth',3)
hold on
plot(fds,y(:,3),'r+')
hold off
xlabel('FD')
ylabel({['Reamining time (minutes)'],['having at least ' num2str(time_min) ' min)']})
set(gca,'ydir','reverse')
% axis tight
xlim([min(fds) max(fds)])
ylim([0 max(FD_sorted(:))*FD_TR/60])
% set(gca,'xticklabel',[])
% set(gca,'xaxisLocation','top')
grid on



% tightplot (1,2,2)
% [b ix]=sort(sum(FD==0),'descend');
% subplot 122
% mask=zeros([size(FD_sorted(:,ix)') 3]);
% imagesc(fds,1:n,mask)
% 
% hold on
% h=imagesc(fds,1:n,FD_sorted(:,ix)');
% hold off
% set(h,'AlphaData',FD_sorted(:,ix)'>0)
% set(gca,'ydir','normal')
% xlabel('FD')
% ylabel('Participant')
% colormap(autumn(256));
% colormap(1-cool(256));
% % colormap=colormap(
% hcb=colorbar;
% set(get(hcb,'Title'),'String','Frames')
% set(gca,'yaxisLocation','right')
subplot 222
% subplot('position',[.1 .6 .85 .35])
% stairs(fds,survivors,'linewidth',4)
SV=zeros(ticks,n_neighbors);

for i=1:n_neighbors
    th_min=floor(ths((i))*60/FD_TR);
    dummy=raw_FD;
    dummy(dummy<=th_min)=0;
    SV(:,i)=sum(dummy>0,2);
end

stairs(fds,SV)
hold on
stairs(fds,survivors,'color',[0 0 0],'linewidth',2)
hold off
legend([num2str(ths','%4.1f') repmat(' min',n_neighbors,1)],'location','southeast')
axis tight
grid on
xlabel('FD')
ylabel('Survivors')
%%
subplot 224
stairs(fds,SV-repmat(survivors,1,n_neighbors))
hold on
stairs(fds,survivors*0,'linewidth',2,'color',[0 0 0])
hold off
legend([num2str(ths','%4.1f') repmat(' min',n_neighbors,1)])
%     'Position',[0.7783 0.1264 0.1119 0.1101])
grid on
ylabel('Earned participants')
set(gca,'xtick',fds(1:10:end))
% set(gca,'xticklabel',survivors(1:10:end))
% set(gca,'xticklabel',[])\
xlabel('Baseline survivors and FD')
xlim([fds(1) fds(end)])
text(fds(1:10:end),0*fds(1:10:end),num2str(survivors(1:10:end)),...
    'HorizontalAlignment','center')
