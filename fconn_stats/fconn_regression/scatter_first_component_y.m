function scatter_first_component_y(Xscores,labels,local_y,y_color,varargin)


%% Reading extra arguments if provided

pctvar_provided_flag=0;
Features_provided_flag=0;

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'pctvar'
            PCTVAR=varargin{q+1};
            pctvar_provided_flag=1;
            q = q+1;
            
        case 'features'
            Features=varargin{q+1};
            Features_provided_flag=1;
            q = q+1;
            
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

pctvar_provided_flag=pctvar_provided_flag==1;
Features_provided_flag=Features_provided_flag==1;
%%

n=size(labels,1);
local_P=zeros(n,1);

R=zeros(n,1);
% R_null=zeros(n,1);
% n_alt_null=zeros(n,2);

p_unc=zeros(n,1);

tails=2;
h1=local_y;
for k=1:n
    
    h2=Xscores{k}(:,1);
    [R(k), p_unc(k)]=corr(h1(:),h2(:));
    
end

[b ix]=sort(R,'descend');
% [b ix]=sort(p_unc,'ascend');
%% Correct for multiple comparisons
[foo foo p_cor]=fdr_bh(p_unc);

%% make summary table

R_table=table(labels(ix),R(ix),p_unc(ix),p_cor(ix));
R_table.Properties.VariableNames{1}='Network_Network';
R_table.Properties.VariableNames{2}='R';
R_table.Properties.VariableNames{3}='p_uncorrected';
R_table.Properties.VariableNames{4}='p_corrected';

writetable(R_table,['R_first_component.csv'])
%%
local_dir='scatter_first_component';
mkdir(local_dir);
cd (local_dir)

fig_size=[8 8 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
y=h1;
species=table2array(y_color(:,1));
my_color=table2array(y_color(:,2:end));
my_color=unique(my_color,'rows','stable');
linecolor='k';
linewidth=1.5;
for k=1:n
    if R(ix(k))>0
        
        x=Xscores{ix(k)}(:,1);
        
        scatter(x,y)
        yl=ylim;
        ix_in=and(~isnan(x),~isnan(y));
        h=lsline;
        xline=h.XData;
        yline=h.YData;
        %     R=zeros(2,1);
        %     p=zeros(2,1);
        %     corr_type=cell(2,1);
        %     corr_type{1}='Pearson';
        %     corr_type{2}='Spearman';
        %
        %     for ii=1:2
        %         [R(ii), p(ii)]=corr(x(ix_in),y(ix_in),'Type',corr_type{ii});
        %     end
        
        
        
        scatterhist(x,y,'Group',species,'Kernel','on',...
            'color',my_color,...
            'LineStyle',{'-','-','-'},...
            'LineWidth',[2,2,2],...
            'Marker','...',...
            'MarkerSize',[1 1 1]*20);
        % lsline
        line(xline,yline,...
            'color',linecolor,...
            'linewidth',linewidth)
        box off
        ylim(yl)
        try
            leg_text=cellstr(unique(species,'stable','rows'));
            
        catch
            leg_text=unique(species,'stable','rows');
        end
        
        leg=legend(leg_text);
        set(leg,'box','off')
        leg_pos=get(leg,'position');
        leg_pos(1:2)=0;
        set(leg,'position',leg_pos);
        
        %%
        
        % R_text=['R_p=' num2str(R(1),'%4.2f') ', p=' num2str(p(1),'%4.2f') ', R_s= ' num2str(R(2),'%4.2f') ', p=' num2str(p(2),'%4.2f')];
        %         R_text=['R_S_p_e_a_r_m_a_n = ' num2str(R(2),'%4.2f') ', p = ' num2str(p(2),'%4.3f')];
        %         if p(2)<0.01
        %             R_text=['R_S_p_e_a_r_m_a_n = ' num2str(R(2),'%4.2f') ', p=' num2str(p(2),'%4.3s')];
        %         end
        %         axlim = get(gca, 'XLim');                                           % Get ‘XLim’ Vector
        %         aylim = get(gca, 'YLim');
        %
        %         x_txt = min(axlim) + diff(axlim)*leg_pos(1) + 0.05*diff(axlim);      % Set ‘x’-Coordinate Of Text Object
        %         y_txt = max(aylim)*.95 + diff(aylim)*leg_pos(2) - 0.01*diff(aylim);      % Set ‘y’-Coordinate Of Text Object
        %         %     text(x_txt, y_txt, R_text,'fontsize',8)
        %
        %
        %         y_alt_obv_pred=[Y{ix(k)}.alt.observed Y{ix(k)}.alt.predicted];
        %         y_null_obv_pred=[Y{ix(k)}.null.observed Y{ix(k)}.null.predicted];
        %
        %         h1=y_alt_obv_pred(:,1:end/2);
        %         h2=y_alt_obv_pred(:,end/2+1:end);
        %
        %         h1_null=y_null_obv_pred(:,1:end/2);
        %         h2_null=y_null_obv_pred(:,end/2+1:end);
        
        
        
        p_to_show(1)=p_unc(ix(k));
        p_to_show(2)=p_cor(ix(k));
        
        to_append_fig_name{1}='p_uncorrected';
        to_append_fig_name{2}='p_corrected';
        
        for ijk=1:2
            
            fig_name=[num2str(k) '_R_' labels{ix(k)} '_' to_append_fig_name{ijk}];
            fig_name(fig_name==' ')='_';
            set(f,'name',fig_name);
            
            local_p=p_to_show(ijk);
            local_p_text=num2str(local_p,'%4.3f');
            if local_p<1e-2
                local_p_text=num2str(local_p,'%4.1s');
            end
            if local_p<1e-6
                local_p_text='<1e-6';
            end
            title({labels{ix(k)},['\fontsize{8} R = ' num2str(R(ix(k)),'%2.2f'),', p = ' local_p_text]},...
                'Units', 'normalized', 'Position', [0.5, 1, 0])
            %             tit=[labels{ix(k)} '| \fontsize{8} R = ' num2str(R(ix(k)),'%2.2f'),', p = ' local_p_text];
            %             title(tit)
            
            
            
            
            %         title({labels{ix(k)},['R = ' num2str(R(ix(k)),'%2.4f')]})
            xlabel('First component')
            ylabel('Outcome')
            %     hold all
            %     scatter(y_null_obv_pred(:,1),y_null_obv_pred(:,2))
            %     lsline
            %     hold off
            f.InvertHardcopy = 'off';
            %     print(fig_name,'-dtiffn','-r300')
            saveas(gcf,fig_name)
            print(fig_name,'-dpng','-r300')
        end
        
        
    end
end

if pctvar_provided_flag
    for k=1:n
        if R(ix(k))>0
            tit_preffix=[labels{ix(k)} '_'];
            explained_variance=PCTVAR{ix(k)}(end,:);
            [h,T]=explained_variance_plot(explained_variance,...
                'tit_preffix',tit_preffix);
            
        end
    end
end

cd ..