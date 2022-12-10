function bivariate_comparison(M1,M2,rep_null)
%% This function test whether 2 bivariate distributions are similar or not. Thos procedure can be scaled up to multivariate distributions
% The method is outlined in
% Loudin, J. D., & Miettinen, H. E. (2003). A Multivariate Method for Comparing N-dimensional Distributions, (2), 0–3.
%
% * M1 has the distribution (like rich club distribution) of group 1 or
%    control group
% M2 has the test distribution
% N indicates the number of test points to run the analysis
% rep_null indicates the number of times that fA_star will be constructed
% to test the null hypothesis
% Note, here na=numel(M1) and nb=numel(M2); (see the paper, they use na=1000, nb=50)
% extra stuff in the code /remote_home/omiranda/scratch_bivariate.m
if nargin<3
    rep_null=1000;
end
%% Determine nA and nB;
na=numel(M1);
nb=numel(M2);
na=1e5;
nb=na;
%% Fit the bivariate distribution for M1 and M2
display('Fitting the first bivariate distribution');
x1=run_fit_2d_gauss(M1);
display('Fitting the second bivariate distribution');
x2=run_fit_2d_gauss(M2);
display('First stage done');
%% Generating random points to calculate the D's
m1=x1(1);
m2=x1(2);
s1=x1(3);
s2=x1(4);
r=x1(5);
mu=[m1 m2];
sigma=[s1^2 r*s1*s2;r*s1*s2 s2^2];
yt = mvnrnd(mu,sigma,na);
display([num2str(na) ' random test points have been generated']);
%% Calculate D
fa=bivariate_score(x1,yt);
fb=bivariate_score(x2,yt);
D=fa./(fa+fb);
display('D has been calculated');
xh=linspace(0,1,na);
Fh=histc(D,xh);
F=cumsum(Fh)/na;

%%
%% Making rep_null copies of M1
display (['Making ' num2str(rep_null) ' random copies of M1 to test the null hypothesis'])
% xstar=repmat(x1,rep_null,1);
xstar=zeros(rep_null,5);
rng('shuffle');
for i=1:rep_null
    y = mvnrnd(mu,sigma,nb); %reusing sigma
    xstar(i,[1 2])=mean(y);
    xstar(i,[3 4])=std(y);
    dummy=corr(y);
    xstar(i,end)=dummy(2);
end
display('Done creating random copies of M1');
%%
%% Calculating Dstar
display('Calculating Dstar')
dummy=zeros(na,rep_null);
for i=1:rep_null
    fa_star=bivariate_score(xstar(i,:),yt);
    dummy(:,i)=fa./(fa+fa_star);
end
Dstar=mean(dummy,2);
% Dstar=mean(sort(dummy),2);
display('Dstar has been calculated');
%% Calculating cumulative distributions
display('Calculating cumulative distributions')
xh=linspace(0,1,round(na/10));
xh=linspace(0,1,41);
Fh=histc(D,xh);
F=cumsum(Fh)/na;

Fstarh=histc(Dstar,xh);
Fstar=cumsum(Fstarh)/na;
alpha=.05;
display(['K test using and alpha value of ' num2str(alpha)])
display('Null hypothesis: data come from the same continuous distribution')
% [h p k2stat] = kstest2(D,Dstar,'Alpha',alpha);%
[h p k2stat] = kstest2(D,Dstar,alpha);%
% [h p k2stat] = kstest2(D,dummy(:),alpha);%
if h==1
    display('Null hypothesis rejected')
else
    display(['No evidence to reject null hypothesis (' num2str(alpha) ' significance level)'])
end
p
display([' p-value = ' num2str(p)])

%% Debug zone
x1
x2
mean(xstar)
% whos D Dstar


%%
n=length(M1);
[X Y]=meshgrid(linspace(0,1,n));

F1=bivariate_score(x1,[X(:) Y(:)]);
F1=reshape(F1,n,n);

F2=bivariate_score(x2,[X(:) Y(:)]);
F2=reshape(F2,n,n);

figure('Name','Raw data and fit surfaces')

subplot 221
imagesc(X(1,1:end),X(1,1:end),M1)
title('Original control data')
colorbar

subplot 222
imagesc(X(1,1:end),X(1,1:end),M2)
title('Original test data')
colorbar

subplot 223
imagesc(X(1,1:end),X(1,1:end),F1)
title('Original fit data')
colorbar

subplot 224
imagesc(X(1,1:end),X(1,1:end),F2)
title('Test fit data')
colorbar
%%

figure('Name','Statistical comparison')

d=abs(F-Fstar);
ix=find(d==max(d),1);



subplot 121
stairs(xh,Fstarh,'linewidth',2,'color',[0 .5 0])
hold all
stairs(xh,Fh,'linewidth',2,'color',[1 0 0])
hold off
grid
legend('D^*','D',2)
title('Distribution of D and D^*')
dummy=get(gca,'xtick');
dummy=num2str(dummy','%4.1f');
set(gca,'xticklabel',dummy)

subplot 122
plot(xh,Fstar,'linewidth',2,'color',[0 .5 0])
hold all
plot(xh,F,'linewidth',2,'color',[1 0 0])
line(xh([ix ix]),[F(ix) Fstar(ix)],...
    'color','k',...
    'linewidth',2,...
    'LineStyle','-')
hold off
grid
legend('F^*','F','d',2)
tit{1}='Cumulative distributions';
tit{2}=[' p-value = ' num2str(p)];
title(tit)
dummy=get(gca,'xtick');
dummy=num2str(dummy','%4.1f');
set(gca,'xticklabel',dummy)

dummy=get(gca,'ytick');
dummy=num2str(dummy','%4.1f');
set(gca,'yticklabel',dummy)

%% Ploting Raw data and fits
cmin=min([min(M1(:)) min(M2(:))]);
cmax=max([max(M1(:)) max(M2(:))]);

xtl{1}='High';
xtl{2}='Low';



f1=figure('Name','Raw data and fit',...
    'Color',[1 1 1],...
    'Units','centimeters',...
    'position',[1 1 17.8 16]);
n=length(M1);
[X Y]=meshgrid(linspace(0,1,n));

tightplot(3,3,1)
% subplot 241
% surf(X,Y,M1,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
% % daspect([5 5 1])
% axis tight
% zlim([0 1])
% view(120,60)


bar3c(X(1,1:end),M1)
% % daspect([5 5 1])
axis tight
view(30,30)
% camlight('right')
% axis off
title('Control',...
    'Fontsize',14,...
    'Fontweight','bold')
zlabel('Raw',...
    'Fontsize',12,...
    'Fontweight','normal')
% colorbar
caxis([cmin cmax])
xl=get(gca,'xlim');
yl=get(gca,'ylim');
set(gca,'xTick',xl([1 end]),...
    'xTicklabel',xtl,...
    'yTick',yl([1 end]),...
    'yticklabel',xtl)
cmap1=colormap;
dummy=get(gca,'ztick');
dummy=num2str(dummy','%4.1f');
set(gca,'zticklabel',dummy)
xlabel('Degree',...
    'Fontsize',12,...
    'Fontweight','normal')
% ylabel('Degree',...
%     'Fontsize',12,...
%     'Fontweight','normal')




tightplot(3,3,2)
% subplot 242
% surf(X,Y,M2,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
% % daspect([5 5 1])
% axis tight
% view(120,60)
% camlight left
bar3c(X(1,1:end),M2)
% % daspect([5 5 1])
axis tight
view(30,30)

% camlight('right')
% axis off
title('Test',...
    'Fontsize',14,...
    'Fontweight','bold')
caxis([cmin cmax])
xl=get(gca,'xlim');
yl=get(gca,'ylim');
% set(gca,'xTick',xl([1 end]),...
%     'xTicklabel',xtl,...
%     'yTick',yl([1 end]),...
%     'yticklabel',xtl)
set(gca,'xTick',[],...
    'yTick',[])

dummy=get(gca,'ztick');
dummy=num2str(dummy','%4.1f');
set(gca,'zticklabel',dummy)

% colorbar





% colorbar

% subplot 245
tightplot(3,3,4)
% surf(X,Y,F1,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
bar3c(X(1,1:end),F1)
% % daspect([5 5 1])
axis tight
view(30,30)
% camlight('right')
% axis off
zlabel('Fit',...
    'Fontsize',12,...
    'Fontweight','normal')
% colorbar
caxis([cmin cmax])
xl=get(gca,'xlim');
yl=get(gca,'ylim');
% set(gca,'xTick',xl([1 end]),...
%     'xTicklabel',xtl,...
%     'yTick',yl([1 end]),...
%     'yticklabel',xtl)
set(gca,'xTick',[],...
    'yTick',[])

dummy=get(gca,'ztick');
dummy=num2str(dummy','%4.1f');
set(gca,'zticklabel',dummy)



% subplot 246
tightplot(3,3,5)
% surf(X,Y,F2,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
% daspect([5 5 1])
bar3c(X(1,1:end),F2)
axis tight
view(30,30)
% camlight('right')
% axis off
% colorbar
caxis([cmin cmax])
xl=get(gca,'xlim');
yl=get(gca,'ylim');
% set(gca,'xTick',xl([1 end]),...
%     'xTicklabel',xtl,...
%     'yTick',yl([1 end]),...
%     'yticklabel',xtl)
set(gca,'xTick',[],...
    'yTick',[])

% xlabel('Degree',...
%     'Fontsize',12,...
%     'Fontweight','bold')
% ylabel('Degree',...
%     'Fontsize',12,...
%     'Fontweight','bold')
dummy=get(gca,'ztick');
dummy=num2str(dummy','%4.1f');
set(gca,'zticklabel',dummy)


% 
% subplot 243
tightplot(3,3,3)
DM=M1-M2;
DF=F1-F2;


cmin2=min([min(DM(:)) min(DF(:))]);
cmax2=max([max(DM(:)) max(DF(:))]);

% surf(X,Y,DM,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
% % daspect([5 5 1])
% axis tight
% view(120,60)
% camlight left
bar3c(X(1,1:end),DM)
% % daspect([5 5 1])
axis tight
view(30,30)

% camlight('right')
% axis off
title('Diff',...
    'Fontsize',14,...
    'Fontweight','bold')
caxis([cmin2 cmax2])
cmap2=colormap;
xl=get(gca,'xlim');
yl=get(gca,'ylim');
zl=get(gca,'zlim');
% set(gca,'xTick',xl([1 end]),...
%     'xTicklabel',xtl,...
%     'yTick',yl([1 end]),...
%     'yticklabel',xtl)
set(gca,'xTick',[],...
    'yTick',[])
dummy=get(gca,'ztick');
sd=significant_digits(dummy);
prec=['%4.', num2str(sd), 'f'];
dummy=num2str(dummy',prec);
% dummy=num2str(dummy','%4.1f');
set(gca,'ztick',str2num(dummy),...
    'zticklabel',dummy)

% subplot 247
tightplot(3,3,6)
% surf(X,Y,F2,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong')
% daspect([5 5 1])
bar3c(DF)
axis tight
view(30,30)
% camlight('right')
% axis off
% title('Diff. fit data')
% colorbar
caxis([cmin2 cmax2])
xl=get(gca,'xlim');
yl=get(gca,'ylim');
% set(gca,'xTick',xl([1 end]),...
%     'xTicklabel',xtl,...
%     'yTick',yl([1 end]),...
%     'yticklabel',xtl)
% xlabel('Degree',...
%     'Fontsize',12,...
%     'Fontweight','bold')
% ylabel('Degree',...
%     'Fontsize',12,...
%     'Fontweight','bold')
set(gca,'xTick',[],...
    'yTick',[])

dummy=get(gca,'ztick');
sd=significant_digits(dummy);
prec=['%4.', num2str(sd), 'f'];
dummy=num2str(dummy',prec);
% dummy=num2str(dummy','%4.1f');
set(gca,'ztick',str2num(dummy),...
    'zticklabel',dummy)

% dummy=num2str(dummy','%4.1f');
% set(gca,'zticklabel',dummy)




tightplot (3,2,5)
% tightplot(5,4,8)
stairs(xh,Fstarh,'linewidth',2,'color',[0 .5 0])
hold all
stairs(xh,Fh,'linewidth',2,'color',[1 0 0])
hold off
grid
yl=get(gca,'ylim');
% legend('D^*','D',2)
text(0.1,yl(2)*.9,{'\color[rgb]{0 .5 0}D^*','\color[rgb]{1 0 0}D'},...
    'VerticalAlignment','top',...
    'HorizontalAlignment','left')
% title({'Distributions of','D and D^*'})
% title({'Distributions of D and D^*'})
title('Distributions of D and D^*',...
    'Fontsize',14,...
    'Fontweight','bold')
% set(gca,'xtick',0:.2:1)
dummy=get(gca,'xtick');
dummy=num2str(dummy','%4.1f');
set(gca,'xticklabel',dummy)
ylabel('Count')
set(gca,'linewidth',2)


tightplot (3,2,6)
% subplot 326
% tightplot(5,4,20)
plot(xh,Fstar,'linewidth',2,'color',[0 .5 0])
hold all
plot(xh,F,'linewidth',2,'color',[1 0 0])

line(xh([ix ix]),[F(ix) Fstar(ix)],...
    'color','k',...
    'linewidth',2,...
    'LineStyle','-')
% text(0.1,1,{'\color[rgb]{0 .5 0}F','\color[rgb]{1 0 0}F^*','\color[rgb]{0 0 0}d'},...
%     'VerticalAlignment','top',...
%     'HorizontalAlignment','left')
hold off
grid
leg=legend('F^*','F','d',2);
set(leg,'box','off')

% tit{1}='Cumulative distributions';
% tit{2}=[' p-value = ' num2str(p)];
% title({'Cumulative', 'distributions'})
title(tit,...
    'Fontsize',14,...
    'Fontweight','bold')

% set(gca,'xtick',0:.2:1)
dummy=get(gca,'xtick');
dummy=num2str(dummy','%4.1f');
set(gca,'xticklabel',dummy)

dummy=get(gca,'ytick');
dummy=num2str(dummy','%4.1f');
set(gca,'yticklabel',dummy)
ylabel('Prob.')
set(gca,'linewidth',2)
