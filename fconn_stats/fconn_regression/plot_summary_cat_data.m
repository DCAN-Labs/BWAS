function plot_summary_cat_data(local_case)

%%
cohen_intervals_greather_than_values=zeros(6,1);
cohen_intervals_greather_than_names=cell(6,1);
cohen_intervals_greather_than_values(1)=.01;
cohen_intervals_greather_than_values(2)=.2;
cohen_intervals_greather_than_values(3)=.5;
cohen_intervals_greather_than_values(4)=.8;
cohen_intervals_greather_than_values(5)=1.2;
cohen_intervals_greather_than_values(6)=2;

cohen_intervals_greather_than_names{1}='very_small';
cohen_intervals_greather_than_names{2}='small';
cohen_intervals_greather_than_names{3}='medium';
cohen_intervals_greather_than_names{4}='large';
cohen_intervals_greather_than_names{5}='very_large';
cohen_intervals_greather_than_names{6}='huge';

cohen_intervals_greather_than_names{1}='vs';
cohen_intervals_greather_than_names{2}='sm';
cohen_intervals_greather_than_names{3}='med';
cohen_intervals_greather_than_names{4}='lar';
cohen_intervals_greather_than_names{5}='vl';
cohen_intervals_greather_than_names{6}='huge';

d_expanded=cohen_intervals_greather_than_values;
d_expanded(end+1)=1/0;
%%
systems=table2array(unique(local_case.table(:,1)));
n_systems=numel(systems);

p_column=local_case.p_column;
column_x=local_case.column_x;

n_effect_size=3;

X=cell(n_systems,1);
Y1=cell(n_systems,1);
Y2=cell(n_systems,n_effect_size);
ylab=cell(n_effect_size,1);

minmax_P=zeros(n_systems,2);
max_Y=zeros(n_systems,n_effect_size);

flag_atleast_small_effects_size=zeros(n_systems,1);
flag_only_positive_correlations=zeros(n_systems,1);

for i=1:n_systems
    system_mask=ismember(table2array(local_case.table(:,1)),systems{i});
    local_p=local_case.table(system_mask,p_column);
    local_p=table2array(local_p);
    Y1{i}=local_p;
    minmax_P(i,:)=[min(local_p) max(local_p)];
    
    local_x=local_case.table(system_mask,column_x);
    local_x=table2array(local_x);
    X{i}=local_x;
    n_x=size(local_x,1);
    
    local_y=zeros(n_x,n_effect_size);
    
    for j=1:n_effect_size
        local_y=local_case.table(system_mask,6+j);
        local_y=table2array(local_y);
        Y2{i,j}=local_y;
        ylab{j}=local_case.table.Properties.VariableNames{6+j}; %overwriten on i, it is ok
        max_Y(i,j)=max(local_y);
    end
    
    local_R=local_case.table(system_mask,2);
    local_R=table2array(local_R);
    flag_only_positive_correlations(i)=prod(local_R>0);
    flag_only_positive_correlations(i)=sum(local_R>0)>0;% changed to include at least one positive correlation | Jan 29, 2019
    
    local_effect=cell2mat(Y2(i,:));
    local_effect=local_effect>=cohen_intervals_greather_than_values(2);% check to include small effect size
    local_effect=local_effect>=cohen_intervals_greather_than_values(1);% changed to include very small effect size
    local_effect=local_effect>=0;% changed to avoid using effect size from excluding cases
    flag_atleast_small_effects_size(i)=sum(local_effect(:))>0;
end
%% calculate and apply mask
to_show=and(flag_atleast_small_effects_size,flag_only_positive_correlations);
to_show=find(to_show);
systems=systems(to_show,:);
X=X(to_show,:);
Y1=Y1(to_show,:);
Y2=Y2(to_show,:);
minmax_P=minmax_P(to_show,:);
max_Y=max_Y(to_show,:);
%% sort the data

[foo, ix_sorted]=sort(minmax_P(:,1),'ascend');
n_surv=size(ix_sorted,1);

ix_sorted_effect=zeros(n_surv,n_effect_size);
for j=1:n_effect_size
[foo, ix_sorted_effect(:,j)]=sort(max_Y(:,j),'descend');
end

ix_cat=[ix_sorted ix_sorted_effect];
%% if everything survives, show no more than n_surv_limit systems
orig_n_surv=n_surv;
note=[];
n_surv_limit=5;
if n_surv>n_surv_limit
    n_surv=n_surv_limit;
    note=['truncated to ' num2str(n_surv_limit) ' out of ' num2str(orig_n_surv)];
end

%% plot the data

ylab = strrep(ylab,'mean_square_error','MSE');
ylab = strrep(ylab,'mean_absolute_error','MAE');
ylab = strrep(ylab,'mean_absolute_percent_error','MAPE');
ylab2=ylab;

%% define sorted by
sorted_by{1}='p';
for i=1:n_effect_size
    sorted_by{1+i}=ylab{i};
end
% for i=2;n_

for ijk=1:numel(sorted_by)
    
    ix_sorted=ix_cat(:,ijk);
    %% define fig name
    
    local_name=['p_corrected_flag_' num2str(local_case.p_corrected_flag) '_'];
    for i=1:length(local_case.values_sorted_by)
        local_name=[local_name local_case.labels_sorted_by{i} '_' num2str(local_case.values_sorted_by(i)) '_'];
    end
    local_name(end)=[];
    local_name=[local_name '_by_' sorted_by{ijk}];
    local_name(local_name==' ')='_';
    local_name(local_name=='.')='_';
    
    %%
    % clf
    if n_surv>0
        k=0;
        ms=12;
        delta=10;
        lw=1;
        left_color=[0 0 0];
        right_color=[231,41,138]/255;
        
        % my_color_p=[0 0 0];
        % my_color_cohen=[27,158,119;231,41,138;217,95,2]/255;
        
        %     ylab2{1}='MSE';
        %     ylab2{3}='MAE';
        %     ylab2{2}='MAPE';
        %
        lab_fontsize=8;
        tit_fontsize=10;
        
        
        chunk=4;
        if ijk>1
            fig_size=[8 1 8 n_surv*chunk];
        else
            fig_size=[8 1 20 n_surv*chunk];
        end
        vis_flag='on';
        
        fig_name=local_name;
        f = figure('Visible',vis_flag,...
            'Units','centimeters',...
            'PaperUnits','centimeters',...
            'name',fig_name,...
            'PaperPosition',fig_size,...
            'Position',fig_size,...
            'color',[1 1 1]);
        set(f,'defaultAxesColorOrder',[left_color; right_color]);
        
        for i=1:n_surv
            ii=ix_sorted(i);
            x=X{ii};
            J_ix{1}=1:3;
            J_ix{2}=1;
            J_ix{3}=2;
            J_ix{4}=3;
            for j=J_ix{ijk}
                k=k+1;
                y1=Y1{ii,:};
                y2=Y2{ii,j};
                
                if ijk==1
                subplot(n_surv,3,k);
                else
                    subplot(n_surv,1,k);
                end
                
                local_tick=find(y1== minmax_P(ii,1));
                if ijk==1
                local_text=['min p = ' num2str(minmax_P(ii,1),'%4.2s')];
                else
                    local_text=['max ES = ' num2str(max(y2),'%4.2f')];
                end
                
                yyaxis left
                plot(x,y1,'.',...
                    'markersize',ms)
                ylim([0 minmax_P(ii,2)*(1+delta/100)])
                xl=xlim;
                border=diff(xl)*delta/100;
                xl(1)=xl(1)-border;
                xl(2)=xl(2)+border;
                xlim(xl)
                ylab1=local_case.table.Properties.VariableNames{p_column};
                ylab1(ylab1=='_')=' ';
                ylabel(ylab1,...
                    'fontsize',lab_fontsize)
                hold all
                plot(xlim,[1 1]*0.05,'-k')
                text(xl(1),0.05,num2str(0.05),...
                    'fontsize',lab_fontsize,...
                    'VerticalAlignment','baseline')
                
                if ijk==1
                text(x(local_tick),y1(local_tick),'\downarrow',...
                    'fontsize',lab_fontsize+1,...
                    'fontweight','bold',...
                    'color','b',...
                    'VerticalAlignment','bottom',...
                    'HorizontalAlignment','center')
                end
                hold off
                
                %% Added to fix the problem that when p is very small it is showed factorized with the exponential next to the title making hard to read the values
                local_ytick=(get(gca,'ytick'));
                if max(local_ytick)<1e-2
                    set(gca,'yticklabel',num2str(local_ytick','%4.1s'),...
                        'fontsize',lab_fontsize-1)
                end
                
                %             h=gca;
                %             set(h,'yscale','log')
                %
                
                yyaxis right
                plot(x,y2,'.',...
                    'markersize',ms)
                
                
                ylabel(ylab2{j},...
                    'fontsize',lab_fontsize)
                
                yl=ylim;
                yl=[0 yl(2)*(1+delta/100)];
                ylim(yl)
                
                %         xl=xlim;
                
                hold all
                until=find(cohen_intervals_greather_than_values<yl(2));
                if ~isempty(until)
                    until=until(end);
                end
%                 until=until(end);
                for kk=2:until
                    plot(xl,cohen_intervals_greather_than_values([kk kk]),'--',...
                        'linewidth',lw)
                    text(xl(2),cohen_intervals_greather_than_values(kk),cohen_intervals_greather_than_names{kk},...
                        'fontsize',lab_fontsize,...
                        'color',right_color,...
                        'horizontalalignment','right',...
                        'verticalalignment','bottom')
                end
                hold off
                set(gca,'xtick',sort(x))
                if i<n_surv
                    set(gca,'xlabel',[]);
                else
                xlabel('Components',...
                    'fontsize',lab_fontsize)
                end
                
                
                tit=systems{ii};
                tit(tit=='_')=' ';
                title(tit,...
                    'fontsize',tit_fontsize)
                
                if ijk>1
                    [idontcare, local_tick]=max(y2);
%                     local_tick=find(y2== minmax_P(ii,1));
                text(x(local_tick),y2(local_tick),'\downarrow',...
                    'fontsize',lab_fontsize+1,...
                    'fontweight','bold',...
                    'color','b',...
                    'VerticalAlignment','bottom',...
                    'HorizontalAlignment','center')
                end
                
                
            end
            
            if ijk>1
                local_pos=get(gca,'position');
                local_pos(3)=.75*local_pos(3);
                set(gca,'position',local_pos)
            end
            
            pos=get(gca,'position');
            if ijk==1
            subplot('position',[(pos(1)+pos(3))*1.1 pos(2) 1-(pos(1)+pos(3))*1.1 pos(4)])
            else
                subplot('position',[.95 pos(2) .1 pos(4)])
            end
            text(.0,0.5,local_text,...
                'fontsize',tit_fontsize,...
                'rotation',90,...
                'color','b',...
                'VerticalAlignment','bottom',...
                'HorizontalAlignment','center')
            axis off
        end
        
        if ~isempty(note)
            subplot('position',[0.1 0.01 .8 .05])
            text(0.5,0.5,note,...
                'fontsize',tit_fontsize,...
                'rotation',0,...
                'VerticalAlignment','middle',...
                'HorizontalAlignment','center')
            axis off
        end
        
        
        local_fig_name=fig_name;
        f.InvertHardcopy = 'off';
        saveas(gcf,[local_fig_name])
        print([ local_fig_name],'-dpng','-r300')
        % print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
    end
end
% 
% %% define fig name
% 
% local_name=['p_corrected_flag_' num2str(local_case.p_corrected_flag) '_'];
% for i=1:length(local_case.values_sorted_by)
%     local_name=[local_name local_case.labels_sorted_by{i} '_' num2str(local_case.values_sorted_by(i)) '_'];
% end
% local_name(end)=[];
% local_name(local_name==' ')='_';
% local_name(local_name=='.')='_';
% 
% %%
% % clf
% if n_surv>0
%     k=0;
%     ms=12;
%     delta=10;
%     lw=1;
%     left_color=[0 0 0];
%     right_color=[231,41,138]/255;
%     
%     % my_color_p=[0 0 0];
%     % my_color_cohen=[27,158,119;231,41,138;217,95,2]/255;
%     
% %     ylab2{1}='MSE';
% %     ylab2{3}='MAE';
% %     ylab2{2}='MAPE';
% %     
%     lab_fontsize=8;
%     tit_fontsize=10;
%     
%     
%     chunk=4;
%     fig_size=[8 1 20 n_surv*chunk];
%     vis_flag='on';
%     
%     fig_name=local_name;
%     f = figure('Visible',vis_flag,...
%         'Units','centimeters',...
%         'PaperUnits','centimeters',...
%         'name',fig_name,...
%         'PaperPosition',fig_size,...
%         'Position',fig_size,...
%         'color',[1 1 1]);
%     set(f,'defaultAxesColorOrder',[left_color; right_color]);
%     
%     for i=1:n_surv
%         ii=ix_sorted(i);
%         x=X{ii};
%         for j=1:3
%             k=k+1;
%             y1=Y1{ii,:};
%             y2=Y2{ii,j};
%             
%             subplot(n_surv,3,k);
%             
%             local_tick=find(y1== minmax_P(ii,1));
%             local_text=['min p = ' num2str(minmax_P(ii,1),'%4.2s')];
%             
%             yyaxis left
%             plot(x,y1,'.',...
%                 'markersize',ms)
%             ylim([0 minmax_P(ii,2)*(1+delta/100)])
%             xl=xlim;
%             border=diff(xl)*delta/100;
%             xl(1)=xl(1)-border;
%             xl(2)=xl(2)+border;
%             xlim(xl)
%             ylab1=local_case.table.Properties.VariableNames{p_column};
%             ylab1(ylab1=='_')=' ';
%             ylabel(ylab1,...
%                 'fontsize',lab_fontsize)
%             hold all
%             plot(xlim,[1 1]*0.05,'-k')
%             text(xl(1),0.05,num2str(0.05),...
%                 'fontsize',lab_fontsize,...
%                 'VerticalAlignment','baseline')
%             
%             text(x(local_tick),y1(local_tick),'\downarrow',...
%                 'fontsize',lab_fontsize+1,...
%                 'fontweight','bold',...
%                 'color','b',...
%                 'VerticalAlignment','bottom',...
%                 'HorizontalAlignment','center')
%             hold off
%             
%             %% Added to fix the problem that when p is very small it is showed factorized with the exponential next to the title making hard to read the values
%             local_ytick=(get(gca,'ytick'));
%             if max(local_ytick)<1e-2
%                 set(gca,'yticklabel',num2str(local_ytick','%4.1s'),...
%                     'fontsize',lab_fontsize-1)
%             end
%             
%             %             h=gca;
%             %             set(h,'yscale','log')
%             %
%             
%             yyaxis right
%             plot(x,y2,'.',...
%                 'markersize',ms)
%             
%             
%             ylabel(ylab2{j},...
%                 'fontsize',lab_fontsize)
%             
%             yl=ylim;
%             yl=[0 yl(2)*(1+delta/100)];
%             ylim(yl)
%             
%             %         xl=xlim;
%             
%             hold all
%             until=find(cohen_intervals_greather_than_values<yl(2));
%             until=until(end);
%             for kk=2:until
%                 plot(xl,cohen_intervals_greather_than_values([kk kk]),'--',...
%                     'linewidth',lw)
%                 text(xl(2),cohen_intervals_greather_than_values(kk),cohen_intervals_greather_than_names{kk},...
%                     'fontsize',lab_fontsize,...
%                     'color',right_color,...
%                     'horizontalalignment','right',...
%                     'verticalalignment','bottom')
%             end
%             hold off
%             set(gca,'xtick',sort(x))
%             xlabel('Components',...
%                 'fontsize',lab_fontsize)
%             
%             
%             tit=systems{ii};
%             tit(tit=='_')=' ';
%             title(tit,...
%                 'fontsize',tit_fontsize)
%             
%             
%         end
%         
%         pos=get(gca,'position');
%         subplot('position',[(pos(1)+pos(3))*1.1 pos(2) 1-(pos(1)+pos(3))*1.1 pos(4)])
%         text(.0,0.5,local_text,...
%                 'fontsize',tit_fontsize,...
%                 'rotation',90,...
%                 'color','b',...
%                 'VerticalAlignment','bottom',...
%                 'HorizontalAlignment','center')
%             axis off
%     end
%     
%     if ~isempty(note)
%         subplot('position',[0.1 0.01 .8 .05])
%         text(0.5,0.5,note,...
%             'fontsize',tit_fontsize,...
%             'rotation',0,...
%             'VerticalAlignment','middle',...
%             'HorizontalAlignment','center')
%         axis off
%     end
%     
%     
%     local_fig_name=fig_name;
%     f.InvertHardcopy = 'off';
%     saveas(gcf,[local_fig_name])
%     print([ local_fig_name],'-dpng','-r300')
%     % print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
% end