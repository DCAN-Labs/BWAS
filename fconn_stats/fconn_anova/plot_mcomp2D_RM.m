function sig_text=plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,between_design)
%% Make plot table
no_time_colorcoded=0;
ginfo(1).names={between_design(1).subgroups.name}';

% ginfo(1).names={between_design(1).subgroups.name}';
ginfo(1).n=size(ginfo(1).names,1);


ncases=2.^nchoosek(ginfo(1).n,2);% base 2 because for each comparison there are 2 possible outcomes: significant or not significant. nchoosek(ginfo(1).n,2) calculates how many pair comparisons can be made
foo=nchoosek(ginfo(1).names,2);% made for temp saving
temp_n=size(foo,1);
arms_comp=cell(temp_n,1);


for i=1:temp_n
    arms_comp{i}=[foo{i,1} '_' foo{i,2}];
end

dummy=dec2bin(0:ncases-1);% code each comparison as significant or not
cases=zeros(size(dummy));
for i=1:size(cases,2)
    cases(:,i)=str2num(dummy(:,i));
end

bg_color=zeros(ncases,3);

if no_time_colorcoded
    if strcmpi('Time',stats.varnames{2})
        gen_bg=ones(temp_n,3);
        %     gen_bg(end,:)=0;
        %     repmat(linspace(1,0,temp_n)',1,3);
    end
else
    gen_bg=repmat(linspace(1,0,temp_n)',1,3);
    
end

% gen_bg=repmat(linspace(1,0,temp_n)',1,3);

for i=0:temp_n-2
    foo=sum(cases,2)'==i;
    bg_color(foo,:)=repmat(gen_bg(i+1,:),sum(foo),1);
end
bg_color(end,:)=gen_bg(end,:);

temp_ix=find(sum(cases,2)==temp_n-1);
j=0;
try
for i=1:temp_n
    j=j+1;
    bg_color(temp_ix(i),:)=between_design(1).subgroups(end-j+1).color;
end
end
bg_color(end,:)=gen_bg(end,:);
% ln_color=repmat([0 0 0],ncases,1);
ln_color=repmat([0 0 0],ncases,1);

if no_time_colorcoded
    if strcmpi('Time',stats.varnames{2})
    else
%         ln_color([1 end],:)=1;
    end
else
    ln_color([1 end],:)=1;
end

if ginfo(1).n>3
    bg_color(:)=1;
    ln_color(:)=0;
end

varnames={'Number' arms_comp{:} 'shown', 'ln_color' 'bg_color'};

shown=[1:ncases]'>1;
%
part1=['ptable=table([1:ncases]'','];
part2=[];
for i=1:temp_n
    part2=[part2 'cases(:,' num2str(i) '), '];
end
part3=['shown,ln_color,bg_color,''VariableNames'',varnames);'];
to_run=[part1 part2 part3 ];
eval(to_run)
%%
Q=table2array(ptable(:,2+(0:temp_n-1)));% section of the table that will be querried
n_parcel=size(options.resort_parcel_order,2);
% n_parcel=size(parcel,2);

%%
fig_name=[stats.varnames{1} '_vs_' stats.varnames{2}];

if options.display_figures
    vis_flag='on';
else
    vis_flag='off';
end


if n_parcel<4
    fig_size=[8 1 12 12];
else   
    core_space_mm=0.9;% space will be used between spaces
    block_size=core_space_mm*temp_n;
    sq=n_parcel*(block_size+core_space_mm);    
    fig_size=[8 1 sq sq];
end

f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
fs_axis=9; %size of fonts in plots
fs_title=7;%size of fonts in title
fs_legend=10;
fs_label=12;
%%



tit=stats.grpnames{1};
xtl=stats.grpnames{2};

if strcmpi('Time',stats.varnames{2})
    mk='O-';
else
    mk='O';
end

lw=3;
pth=0.05;
pth=options.p_th;
% pth=.1;
kk=0;
% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;

offset_xlim=.2;
offset_ylim=.1;

n_traces=size(xtl,1);
n_x_networks=size(stats.grpnames{1},1);

sig_text=cell(n_x_networks,1);
ii=1:n_traces;
for i=1:n_parcel
    for j=i:n_parcel
        k=sub2ind([n_parcel n_parcel],i,j);
        subplot(n_parcel,n_parcel,k)
        
        
        
%         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
        local_ix=zeros(1,n_traces);
        kk=kk+1;
        for ij=1:n_traces
            dummy=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' xtl{ij}];
            local_ix(ij)=find(ismember(gnames,dummy));
        end
        
        
        
        qp=zeros(1,temp_n);
        to_display=cell(temp_n,1);
        for k=1:temp_n
            unfold_arm=arms_comp{k};
            p1=unfold_arm(1:floor(end/2));
            p2=unfold_arm(ceil(end/2)+1:end);
            
            P1=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p1];
            P2=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p2];
            
            ix1=find(ismember(gnames,P1));
            ix2=find(ismember(gnames,P2));
            %             ix3=find(and(results(:,1)==ix1,results(:,2)==ix2));
            ix3=and(results(:,1)==ix1,results(:,2)==ix2);
            qp(k)=results(ix3,end);
            to_display{k}=['p = ' num2str(qp(k),'%4.2s') ' ' P1 ' ' P2];
        end
        qp=qp<pth;
        
        qn=ismember(Q,qp,'rows');
        if ptable.shown(qn)
            mm=m(local_ix,1);
%             'color',parcel(options.resort_parcel_order(i)).RGB,...
%                 'fontsize',12
            se=m(local_ix,2);
            
%             annotation('textbox',get(gca,'position'),'BackgroundColor',ptable.bg_color(qn,:));
            line([ii;ii],[mm+tse*se mm-tse*se]','color',ptable.ln_color(qn,:),'linewidth',lw)
            hold all
            
            plot(ii,mm,mk,'color',ptable.ln_color(qn,:),...
                'LineWidth',lw,...
                'MarkerSize',6,...
                'MarkerEdgeColor',ptable.ln_color(qn,:),...
                'MarkerFaceColor',ptable.bg_color(qn,:))
            set(gca,'color',ptable.bg_color(qn,:))
            try
            display(to_display(qp))
            sig_text{kk}=to_display(qp);
            end
            hold off
        else
%             plot(ii,ii*0,'color',ptable.bg_color(qn,:))
            plot(ii,ii*0,'color',get(gca,'color'))
        end
        box on
        set(gca,'xtick',ii)
        set(gca,'xticklabel',[])
        if i==1
            ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                'color',parcel(options.resort_parcel_order(j)).RGB,...
                'fontsize',fs_label)
        end
        if j==n_parcel
            xlabel(parcel(options.resort_parcel_order(i)).shortname,...
                'color',parcel(options.resort_parcel_order(i)).RGB,...
                'fontsize',fs_label)
            set(gca,'xticklabel',xtl)
        end
        xlim([0 n_traces+1]);
        %         title(ginfo(2).names(kk))
        
        
        
        
        
        axis tight
        xl=xlim;
        dxl=abs(diff(xl));
        xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
        yl=ylim;
        dyl=abs(diff(yl));
        ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
        title(tit(kk),...
            'fontsize',fs_title)
        
        
        
        %          xlim([0 n_traces+1]);
        if and(options.show_y_scale,sum(qp))
            yl=get(gca,'ytick');
            axis_label=set_axis_label(yl);
            set(gca,'yticklabel',axis_label)
        else
            set(gca,'yticklabel',[])%
        end
    end
end

%% Adding legend
subplot (n_parcel,n_parcel,n_parcel)
pos=get(gca,'position');
axis off
delta=.03;
fs=10;

if ginfo(1).n==3
dim=[pos(1) pos(2)+pos(4)-delta pos(3) delta];

text_legend=cell(5,1);

text_legend{1}=['All groups are distinct'];
for i=1:3
    dummy=1:3;
    dummy=dummy~=i;
    dummy=find(dummy);
    text_legend{i+1}=['\bf{' between_design.subgroups(i).name '}\rm differs from ' between_design.subgroups(dummy(1)).name ' and ' between_design.subgroups(dummy(2)).name];
    text_legend{i+1}=[between_design.subgroups(i).name ' differs from ' between_design.subgroups(dummy(1)).name ' and ' between_design.subgroups(dummy(2)).name];
end
text_legend{end}='Just 1 pair is distinct';
tl=0;
for i=1:5
    tl=get_size_text(text_legend{i},tl,fs);
end
tl=tl*1.15;
dim=[pos(1)+pos(3)-tl pos(2)+pos(4)-delta  tl delta];

% anchor=.6;
% dim=[anchor pos(2)+pos(4)-delta pos(3)+pos(1)-anchor delta];
% t=['All groups are distinct'];


annotation('textbox',dim,'String',text_legend{1},'verticalalignment','middle','BackgroundColor',ptable.bg_color(end,:),'color','w','fontsize',fs);
dim(2)=dim(2)-delta;
for i=1:3
%     dummy=1:3;
%     dummy=dummy~=i;
%     dummy=find(dummy);
%     t=[between_design.subgroups(i).name ' differs from ' between_design.subgroups(dummy(1)).name ' and ' between_design.subgroups(dummy(2)).name];
    annotation('textbox',dim,'String',text_legend{1+i},'verticalalignment','middle','BackgroundColor',between_design.subgroups(i).color,'fontsize',fs);
    dim(2)=dim(2)-delta;
end
% t=['Just 1 pair is distinct'];
annotation('textbox',dim,'String',text_legend{end},'verticalalignment','middle','BackgroundColor',ptable.bg_color(2,:),'fontsize',fs);

dim(2)=dim(2)-delta;
annotation('textbox',dim,'String',['(p > ' num2str(pth,'%4.2f') ')'],'verticalalignment','middle','BackgroundColor','w','fontsize',fs);


else
    dim=[pos(1) pos(2)+pos(4)-delta pos(3) delta*3];
    text_legend={['Shown if at least one pair of marginal means are distinct (p < ' num2str(pth,'%4.2f') ')']};
    try
    annotation('textbox',dim,'String',text_legend,'verticalalignment','top','BackgroundColor',ptable.bg_color(2,:),'fontsize',fs,'edgecolor','w','color','w');
    end
end
if options.save_figures
%     savefig(fig_name)
    fig_name=[fig_name '_plan_A'];
    f.InvertHardcopy = 'off';
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
    print(fig_name,'-dtiffn','-r300')
    copyfile([fig_name '.png'],['summary' filesep]);
end

function tl=get_size_text(t,tl,fs)

ui=uicontrol('Style', 'text',...
    'String',t,...
    'fontsize',fs,...
    'visible','off');
set(ui,'units','normalized')
temp=get(ui,'Extent');
if temp(3)>tl
    tl=temp(3);
end
%% WIP adding color boxes
% POS=get(gca,'position');
% POS(4)=POS(2)*.5;
% POS(2)=POS(2)*.1;
%
% subplot('position',POS)
% box on
% set(gca,'color',parcel(options.resort_parcel_order(i)).RGB)
%
% text(mean(xlim),mean(ylim),parcel(options.resort_parcel_order(i)).shortname,...
%     'HorizontalAlignment','center',...
%     'fontsize',12)
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])
