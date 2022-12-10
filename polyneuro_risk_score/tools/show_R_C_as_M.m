function show_R_C_as_M(T,tit)


%%
M=T{:,:};
n=size(M,1);
parcel(n).name=[];
parcel(n).shortname=[];
parcel(n).ix=[];
parcel(n).n=[];

for i=1:n
    parcel(i).name=T.Properties.VariableNames{i};
    parcel(i).shortname=T.Properties.VariableNames{i};
    parcel(i).ix=i;
    parcel(i).n=1;
end

%%
force_diag_to_be_zero_flag=0;
delta=0;
clims=get_ptiles_M(M,delta);

H=showM(M,...
    'parcel',parcel,...
    'line_color',[0 0 0],...
    'line_width',1,...
    'fs_axis',10,...
    'fig_wide',7,...
    'one_side_labels',1,...
    'clims',clims,...
    'force_diag_to_be_zero_flag',force_diag_to_be_zero_flag,...
    'fig_tall',8,...
    'half','low');

%%
imagesc(M,clims)
set(gca,'xtick',1:n)
set(gca,'ytick',1:n)
set(gca,'xticklabel',cat(1,parcel.shortname))
set(gca,'yticklabel',cat(1,parcel.shortname))
xtickangle(90)
xl=xlim;
yl=ylim;
for i=xl(1):xl(end)-1
    j=i;
    line(xl,[j j],'color','k')
    line([j j],yl,'color','k')
end

patch(xl([1 2 2 ]),yl([1 2 1]),'w')
line(xl,yl([1 1]),'color','w')
line(xl([2 2]),yl,'color','w')
box off
if ~isempty(tit)
    set(gca,'position',[0.1500    0.2500    0.720    0.650])
    tit=downsize_fontsize_additionall_rows(tit,10);
    t=title(tit);
end