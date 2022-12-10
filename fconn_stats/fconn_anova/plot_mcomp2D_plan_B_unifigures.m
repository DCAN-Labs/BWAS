function plot_mcomp2D_plan_B_unifigures(parcel,options,arg1,arg2,arg3,between_design,t,to_run,within)
% function posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design,t,to_run,within)

%%
% fig_name=[stats.varnames{1} ' vs ' stats.varnames{2}];
fig_name=[arg1 '_' between_design.name];

if options.display_figures
    vis_flag='on';
else
    vis_flag='off';
end

% fig_size=[8 1 20 20];
n_parcel=size(options.resort_parcel_order,2);
% 
% if n_parcel>6
%     fig_size=[8 1 24 24];
% end


%%

% Q=table2array(ptable(:,2+(0:temp_n-1)));% section of the table that will be querried
% n_parcel=size(options.resort_parcel_order,2);
% n_parcel=size(parcel,2);

% tit=stats.grpnames{1};
%tit=unique(table2cell(m(:,1)),'stable');
tit=unique(table2array(within));% to avoid m
% xtl=table2cell(unique(m(:,3),'stable'));
% line_names=unique(table2cell(m(:,2)),'stable');% to avoid m
line_names={between_design.subgroups(:).name}';
n_lines=size(line_names,1);
% n_traces=size(xtl,1);
n_traces=n_lines;
n_traces=n_lines;
% for i=1:n_traces
%     xtl{i}=char(xtl{i});
% end
xtl=line_names;
% xtl=stats.grpnames{2};

mk='O-';

lw=3;
% pth=0.05;
kk=0;
% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
pth=0.05;
pth=options.p_th;
offset_xlim=.2;
offset_ylim=.1;
%%
if n_parcel<4
    fig_size=[8 1 8 8];
else   
    core_space_mm=0.9;% space will be used between spaces
    block_size=core_space_mm*n_lines;
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

% for hiding non-significant plots

master_t=t;


part1=to_run(1:find(to_run=='''',1));

part3=to_run(find(to_run=='~',1):end-2);


% part1=[to_run(1:2) '1' to_run(3:12)];
% part2='(ix_p,:)';
% part3=to_run(13:22);
% part4=to_run(32:end);
% local_run=[part1 part2 part3 part4];

% n_x_networks=size(stats.grpnames{1},1);
n_x_networks=size(tit,1);
p_to_store=zeros(n_x_networks,1);
RM=cell(n_x_networks,1);
all_ranovatbl=cell(n_x_networks,1);

ii=1:n_traces;
for i=1:n_parcel
    for j=i:n_parcel
        k=sub2ind([n_parcel n_parcel],i,j);
        subplot(n_parcel,n_parcel,k)
        
        kk=kk+1;
        tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
        
        local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
        
        
        
        n_nn=length(local_within);
        part2=['Var1-Var' num2str(n_nn) ' '];
%         part4='(local_within,:));';
%         part4='(local_within,2));';
%         local_run=[part1 part2 part3 part4];
        
        foo=array2table(ones(n_nn,1));
        foo.Properties.VariableNames={'Time'};
        
        t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
        
        
        part_new=[part3(1:end-6) 'foo);'];
        local_run=[part1 part2 part_new];
        eval(local_run);
        ranovatbl = ranova(rm,'WithinModel','Time');
        local_p=table2array(ranovatbl([5],5));
        
        
        p_to_store(kk)=local_p;
        RM{kk}=rm;
        all_ranovatbl{kk}=ranovatbl;
%         data=table2array(master_t(:,[1+local_within(:)']));
        
%         if strcmp(between_design.name,arg2)
%             grouping=repmat(table2array(master_t(:,1)),1,size(data,2));
%         end
%         
%         if strcmp(between_design.name,arg3)
%             grouping=repmat(table2array(within(local_within,2))',size(data,1),1);
%         end
%         
%         [local_p,tbl,stats] = anovan(data(:),{grouping(:)},'display','off');
%          p_to_store(kk)=local_p;
        
    end
end

posthoc_mcomp2D_planB.RM=RM;

posthoc_mcomp2D_planB.tit=tit;
posthoc_mcomp2D_planB.ranovatbl=all_ranovatbl;
%% Use FDR to correct
% p_corrected=mafdr(p_to_store);% there is something wrong with this function. Sometimes corrected values are lower than uncorrected
% [h crit_p adj_p]=fdr_bh(p_to_store);
% [sum(p_to_store<=.05) sum(p_corrected<=.05) sum(adj_p<=.05)]
[h crit_p p_corrected]=fdr_bh(p_to_store);

p_corrected1=p_to_store*0;
p_corrected2=p_to_store*0;
for i=1:1
    [h crit_p p_corrected1(:,i)]=fdr_bh(p_to_store(:,i));
    p_corrected2(:,i)=mafdr(p_to_store(:,i));
end
p_corrected=p_corrected1;
% if sum(p_corrected1(:,3)<p_corrected1(:,3))
%     p_corrected=p_corrected1;
% else
%     p_corrected=p_corrected2;
% end

p_uncorrected_table=array2table(p_to_store);
p_corrected_table=array2table(p_corrected);


p_uncorrected_table.Properties.VariableNames={arg2};
p_corrected_table.Properties.VariableNames={arg2};

p_uncorrected_table.Properties.RowNames=tit;
p_corrected_table.Properties.RowNames=tit;


posthoc_mcomp2D_planB.p_uncorrected=p_uncorrected_table;
posthoc_mcomp2D_planB.p_corrected=p_corrected_table;
%%
%%

p_th_vector=[pth([1 1]) 1 1];% This vector define the thresholds to be used for visualization, the asked one and one
p_th_plot=[p_corrected(:,end) p_to_store(:,end) p_corrected(:,end) p_to_store(:,end)]; % to show corrected and uncorrected p_values


suffix_figure=cell(4,1);
for i=1:4
    temp_label=['_p_th_' num2str(p_th_vector(i),'%4.2f') '_corrected_flag_' num2str(rem(i,2))];
    temp_label(temp_label=='.')='_';
    suffix_figure{i}=temp_label;
end


close(f)


folder_rf=['mcomp2D_planB_' arg2];
mkdir(folder_rf)

for figure_counter=1
    
    
    kk=0;
    for i=1:n_parcel
        for j=i:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
            
            
            kk=kk+1;
            tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
            
            local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
            
            
            
            n_nn=length(local_within);
            
            %%
            m=margmean(RM{kk},arg2);
            
            % to resort m
            M=m;
            for counter=1:n_traces
                local_ix=find(ismember(table2array(m(:,1)),between_design.subgroups(counter).name));
                M(counter,:)=m(local_ix,:);
            end
            m=M;
            
            mm=table2array(m(:,2));
            se=table2array(m(:,3));
            
            min_y_plot=100;
            max_y_plot=-100;
            
            local_p=p_th_plot(kk,figure_counter);
            pth=p_th_vector(figure_counter);
            if local_p<p_th_vector(figure_counter)%ptable.shown(qn)
                
                fig_size_sub=[1 1 8 8];
                sub_local_fig_name=tit{kk};
                
                sub_f = figure('Visible',vis_flag,...
                    'Units','centimeters',...
                    'PaperUnits','centimeters',...
                    'name',sub_local_fig_name,...
                    'PaperPosition',fig_size_sub,...
                    'Position',fig_size_sub,...
                    'color',[1 1 1]);
                plot(ii,mm,'w');
                hold all
                for ijk=1:n_traces%n_lines
                    
                    line([ijk;ijk],[mm(ijk)+tse*se(ijk) mm(ijk)-tse*se(ijk)]',...
                        'color',between_design.subgroups(ijk).color,...
                        'linewidth',lw)
                    plot(ijk,mm(ijk),mk,...
                        'color',between_design.subgroups(ijk).color,...
                        'MarkerSize',6,...
                        'linewidth',lw)
                    plot(ijk,mm(ijk),mk,...
                        'color','w',...
                        'MarkerSize',2,...
                        'linewidth',lw)
                end
                hold off
                foo1=([mm+tse*se mm-tse*se]);
                foo1=min(foo1(:));
                if foo1<min_y_plot
                    min_y_plot=foo1;
                end
                
                foo2=([mm+tse*se mm-tse*se]);
                foo2=max(foo2(:));
                if foo2>max_y_plot
                    max_y_plot=foo2;
                end
                
                delta=diff([min_y_plot max_y_plot])*.25;
                min_y_plot=min_y_plot-delta;
                ylim([min_y_plot max_y_plot])
                
                %             end
                box on
                xlim([1 n_traces]);
                set(gca,'xtick',ii)
                set(gca,'xticklabel',[])
                
                ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                    'color',parcel(options.resort_parcel_order(j)).RGB,...
                    'fontsize',fs_label)
                
                
                xtl=table2cell(unique(m(:,1),'stable'));
                xlabel(parcel(options.resort_parcel_order(i)).shortname,...
                    'color',parcel(options.resort_parcel_order(i)).RGB,...
                    'fontsize',fs_label)
                set(gca,'xticklabel',xtl)
                
                
                xl=xlim;
                dxl=abs(diff(xl));
                xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
                yl=ylim;
                dyl=abs(diff(yl));
                ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
                title(tit(kk),...
                    'fontsize',fs_title)
                if and(local_p<pth,options.show_p_value)
                    text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
                        'Fontsize',fs_title,...
                        'HorizontalAlignment','center',...
                        'VerticalAlignment','bottom')
                    
                end
                
                if and(options.show_y_scale,local_p<pth)
                    yl=get(gca,'ytick');
                    axis_label=set_axis_label(yl);
                    set(gca,'yticklabel',axis_label)
                else
                    set(gca,'yticklabel',[])%
                end
                
                if options.save_figures
                    
                    local_fig_name=sub_local_fig_name;
                    local_fig_name(local_fig_name==' ')='_';
                    f.InvertHardcopy = 'off';
                    %     savefig(fig_name)
                    saveas(gcf,[folder_rf filesep local_fig_name])
                    print([folder_rf filesep local_fig_name],'-dpng','-r300')
                    print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
                    if figure_counter==1
                        copyfile([folder_rf filesep local_fig_name '.png'],['summary' filesep]);
                    end
                end
                
                
                
            end
        end
        
        
        
    end % added
end