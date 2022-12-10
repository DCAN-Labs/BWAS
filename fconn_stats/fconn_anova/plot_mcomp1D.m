function plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,p_th,options)

n_sp=size(m,1)-1;

lw=3;
% tse=1.96;%95%
% tse=1.15;%75%
tse=options.bar_lengh_times_standard_error;
fslab=10;
if nargin<7
    p_th=.05;
end

%%
ptext=num2str(p_th,'%4.2f');
ptext(ptext=='.')='_';
fig_name=[Var_name '_p_th_' ptext '_ver1'];

if options.display_figures
    vis_flag='on';
else
    vis_flag='off';
end

fig_size=[8 1 16 16];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
fs_axis=9; %size of fonts in plots
fs_title=12;%size of fonts in title
fs_legend=10;
fs_label=9;
counter=0;

if n_sp<5
    for ip=1:n_sp
        for jp=ip:n_sp
            ix=[ip jp+1];
            k=sub2ind([n_sp n_sp],ip,jp);
            counter=counter+1;
            
            subplot(n_sp,n_sp,k)
            p=results(counter,end);
            ptit=[];
            if p<p_th
                line([1 1],[m(ix(1),1)+tse*m(ix(1),2);m(ix(1),1)-tse*m(ix(1),2)],...
                    'color',mycolor(ix(1),:),...
                    'linewidth',lw)
                line([2 2],[m(ix(2),1)+tse*m(ix(2),2);m(ix(2),1)-tse*m(ix(2),2)],...
                    'color',mycolor(ix(2),:),...
                    'linewidth',lw)
                xlim([.5 2.5])
                hold all
                plot(1,m(ix(1),1),'O','color',mycolor(ix(1),:),...
                    'LineWidth',lw,...
                    'MarkerSize',6,...
                    'MarkerEdgeColor',mycolor(ix(1),:),...
                    'MarkerFaceColor',[1 1 1])
                plot(2,m(ix(2),1),'O','color',mycolor(ix(2),:),...
                    'LineWidth',lw,...
                    'MarkerSize',6,...
                    'MarkerEdgeColor',mycolor(ix(2),:),...
                    'MarkerFaceColor',[1 1 1])
                set(gca,'xtick',[1 2])
                set(gca,'xticklabel',Grp_name([ix(1) ix(2)]))
                ptit=['p = ' num2str(p,'%4.2e')];
                if p<1e-6
                    ptit=['p < 1e-6'];
                end
                title(ptit)
            else
                box on
                set(gca,'xticklabel',[])
                set(gca,'yticklabel',[])
                %                 axis off
            end
            %set(gca,'ytick',[])
            if ip==1
                yl=['Comparing ' Grp_name{ix(2)}];
                yl=[Grp_name{ix(2)}];
                ylabel(yl,'fontsize',fslab)
            end
            if jp==n_sp
                xl=['versus ' Grp_name{ix(1)}];
                xl=[Grp_name{ix(1)}];
                xlabel(xl,'fontsize',fslab)
            end
            box on
            
            if and(options.show_y_scale,p<p_th)
                yl=get(gca,'ytick');
                axis_label=set_axis_label(yl);
                set(gca,'yticklabel',axis_label)
            else
                set(gca,'yticklabel',[])%
            end
            
            %             M(counter)=p;
            %             MM(k)=p;
            %             MMM(jp,ip)=p;
            [ip jp];
            %         pause
            
        end
        
        
    end
    if options.save_figures
        %     savefig(fig_name);
        saveas(gcf,fig_name)
    end
else
    close (f)
end

%%
fig_name=[Var_name '_p_th_' ptext '_ver2'];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
counter=0;
p=results(:,end);
pscale=logspace(log10(p_th),-6,63);
P=nan(n_sp);
M=ones(n_sp,n_sp,3);

my_color2=[1 1 1;jet(63)];
foo=summer(63);
my_color2=[1 1 1;foo(end:-1:1,:)];
my_color2(end,:)=[0 0 0];

cx=0;
cy=0;
xtl=cell(n_sp,1);
for ip=1:n_sp
    for jp=ip:n_sp
        counter=counter+1;
        p=results(counter,end);
        local_ix=find(p>pscale,1);
        if isempty(local_ix)
            local_ix=64;
        end
        P(jp,ip)=p;
        M(jp,ip,:)=my_color2(local_ix,:);
        
        ix=[ip jp+1];
        if ip==1
            cy=cy+1;
            ytl{cy}=Grp_name{ix(2)};
        end
        if jp==n_sp
            cx=cx+1;
            xtl{cx}=Grp_name{ix(1)};
        end
        %             [ip jp]
        %         pause
        
        
    end
end
subplot (4,4,[2 12])
imagesc(M)
axis square
box off
set(gca,'xtick',1:n_sp)
set(gca,'xticklabel',xtl)
set(gca,'XTickLabelRotation',90,...
    'fontsize',fs_label)
xlabel('versus')

set(gca,'ytick',1:n_sp)
set(gca,'yticklabel',ytl)
ylabel('Comparing')
axis square
box on
title(Var_name,'fontsize',fs_title)

subplot (20,4,[78 80])

temp=zeros(1,64,3);
temp(1,:,:)=my_color2;
imagesc(temp)
xlabel('p value')

% Original scale up to Oct 27
if p_th<.1
    local_ticks=zeros(6,1);
    local_ticks(1)=1;
    local_ticks(end)=64;
    tl=cell(6,1);
    tl{1}=['> ' num2str(p_th)];
    tl{end}='< 1e-6';
    for ii=2:5
        local_ticks(ii)=find(10^(-ii)>pscale,1);
        tl{ii}=['1e-' num2str(ii)];
    end
else
    local_ticks=zeros(7,1);
    local_ticks(1)=1;
    local_ticks(end)=64;
    tl=cell(7,1);
    tl{1}=['> ' num2str(p_th)];
    
    tl=cell(7,1);
    tl{1}=['> ' num2str(p_th)];
    tl{end}='< 1e-6';
    for ii=1:5
        local_ticks(ii+1)=find(10^(-ii)>pscale,1);
        tl{ii+1}=['1e-' num2str(ii)];
    end
end

try
    set(gca,'xtick',local_ticks)
    set(gca,'xticklabel',tl)
    set(gca,'ytick',[])
end

if options.save_figures
    %     savefig(fig_name)
    f.InvertHardcopy = 'off';
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
    print(fig_name,'-dtiffn','-r300')
end
%     text(1,1,tl(1),'VerticalAlignment','middle')
%%
% clf
% counter=0;
%
%
% if n_sp<5
%     for ip=1:n_sp
%         for jp=ip:n_sp
%             ix=[ip jp+1];
%             k=sub2ind([n_sp n_sp],ip,jp);
%             counter=counter+1;
%
%             subplot(n_sp,n_sp,k)
%             p=results(counter,end);
%             if p<p_th
%                 line([1 1],[m(ix(1),1)+tse*m(ix(1),2);m(ix(1),1)-tse*m(ix(1),2)],...
%                     'color',mycolor(ix(1),:),...
%                     'linewidth',lw)
%                 line([2 2],[m(ix(2),1)+tse*m(ix(2),2);m(ix(2),1)-tse*m(ix(2),2)],...
%                     'color',mycolor(ix(2),:),...
%                     'linewidth',lw)
%                 xlim([.5 2.5])
%                 hold all
%                 plot(1,m(ix(1),1),'O','color',mycolor(ix(1),:),...
%                     'LineWidth',lw,...
%                     'MarkerSize',6,...
%                     'MarkerEdgeColor',mycolor(ix(1),:),...
%                     'MarkerFaceColor',[1 1 1])
%                 plot(2,m(ix(2),1),'O','color',mycolor(ix(2),:),...
%                     'LineWidth',lw,...
%                     'MarkerSize',6,...
%                     'MarkerEdgeColor',mycolor(ix(2),:),...
%                     'MarkerFaceColor',[1 1 1])
%                 set(gca,'xtick',[1 2])
%                 set(gca,'xticklabel',Grp_name([ix(1) ix(2)]))
%                 set(gca,'ytick',[])
%                 if ip==1
%                     yl=['Comparing ' Grp_name{ix(2)}];
%                     ylabel(yl,'fontsize',fslab)
%                 end
%                 if jp==n_sp
%                     xl=['versus ' Grp_name{ix(1)}];
%                     xlabel(xl,'fontsize',fslab)
%                 end
%                 box on
%             end
%
%
%             ptit=['p = ' num2str(p,'%4.2f')];
%             if p<1e-6
%                 ptit=['p < 1e-6'];
%             end
%             title(ptit)
%             %             M(counter)=p;
%             %             MM(k)=p;
%             %             MMM(jp,ip)=p;
%             [ip jp]
%             %         pause
%
%         end
%
%
%     end
% else
%     counter=0;
%     p=results(:,end);
%     pscale=logspace(log10(p_th),-6,63);
%     P=nan(n_sp);
%     M=ones(n_sp,n_sp,3);
%
%     my_color2=[1 1 1;jet(63)];
%     foo=summer(63);
%     my_color2=[1 1 1;foo(end:-1:1,:)];
%     my_color2(end,:)=[0 0 0];
%
%     cx=0;
%     cy=0;
%     xtl=cell(n_sp,1);
%     for ip=1:n_sp
%         for jp=ip:n_sp
%             counter=counter+1;
%             p=results(counter,end);
%             local_ix=find(p>pscale,1);
%             if isempty(local_ix)
%                 local_ix=64;
%             end
%             P(jp,ip)=p;
%             M(jp,ip,:)=my_color2(local_ix,:);
%
%             ix=[ip jp+1];
%             if ip==1
%                 cy=cy+1;
%                 ytl{cy}=Grp_name{ix(2)};
%             end
%             if jp==n_sp
%                 cx=cx+1;
%                 xtl{cx}=Grp_name{ix(1)};
%             end
% %             [ip jp]
%             %         pause
%
%
%         end
%     end
%     subplot (4,4,[2 12])
%     imagesc(M)
%     axis square
%     box off
%     set(gca,'xtick',1:n_sp)
%     set(gca,'xticklabel',xtl)
%     set(gca,'XTickLabelRotation',90,...
%         'fontsize',fs_label)
%     xlabel('versus')
%
%     set(gca,'ytick',1:n_sp)
%     set(gca,'yticklabel',ytl)
%     ylabel('Comparing')
%     axis square
%     box on
%     title(Var_name,'fontsize',fs_title)
%
%     subplot (20,4,[78 80])
%
%     temp=zeros(1,64,3);
%     temp(1,:,:)=my_color2;
%     imagesc(temp)
%     xlabel('p value')
%
%     local_ticks=zeros(6,1);
%     local_ticks(1)=1;
%     local_ticks(end)=64;
%     tl=cell(6,1);
%     tl{1}=['> ' num2str(p_th)];
%     tl{end}='< 1e-6';
%     for ii=2:5
%         local_ticks(ii)=find(10^(-ii)>pscale,1);
%         tl{ii}=['1e-' num2str(ii)];
%     end
%     set(gca,'xtick',local_ticks)
%     set(gca,'xticklabel',tl)
%     set(gca,'ytick',[])
% %     text(1,1,tl(1),'VerticalAlignment','middle')
%
%
% end
%
