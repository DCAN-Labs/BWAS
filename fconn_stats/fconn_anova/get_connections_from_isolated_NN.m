function connections_from_isolated_NN=get_connections_from_isolated_NN (local_table,rm_backup,within,master_t, part1, part3, ix_to_ix, arg1, arg3,global_stats,tit,folder_rf,n_lines, line_names,tse,between_design,mk,lw,offset_xlim,offset_ylim,conn_ix)

TIT=table2array(unique(local_table(:,conn_ix)));

TIT=unique((table2array(local_table(:,conn_ix))),'stable');
%%
n_x_connections=length(TIT);

KK=0;
for KK=1:n_x_connections
    display(['Doing RM anova for connection ' num2str(KK) ' out of ' num2str(n_x_connections)]);
    LOCAL_WITHIN=find(ismember(table2cell(within(:,end)),TIT{KK}));
    N_NN=length(LOCAL_WITHIN);
    PART2=['Var1-Var' num2str(N_NN) ' '];
    PART4='(LOCAL_WITHIN,:));';
    PART4='(LOCAL_WITHIN,2));';
    
    LOCAL_RUN=[part1 PART2 part3 PART4];
    t=[master_t(:,1) array2table(table2array(master_t(:,[1+LOCAL_WITHIN(:)'])))];
    
    
    %% testing | chicken mode
    %         conn=cell(N_NN,1);
    %         for ijk=1:N_NN
    %             conn{ijk}=['conn_' num2str(ijk)];
    %         end
    
    n_within2=length(unique(table2array(within(LOCAL_WITHIN,2))));
    
    conn=cell(N_NN,1);
    offset=0;
    for counter=1:n_within2
        for ijk=1:N_NN/n_within2
            conn{ijk+offset}=['conn_' num2str(ijk)];
        end
        offset=offset+ijk;
    end
    
    
    tab2=cell2table(conn);
    LOCAL_TABLE=[within(LOCAL_WITHIN,2) tab2];
    
    
    LOCAL_RUN=[LOCAL_RUN(1:end-24) 'LOCAL_TABLE);'];
    %%
    eval(LOCAL_RUN);
    RM2{KK}=rm;
    IX2{KK}=table2array(ix_to_ix(:,LOCAL_WITHIN));
    %         ranovatbl = ranova(rm);
    %         local_p=table2array(ranovatbl(end-1,5));
    %         p_to_store(KK)=local_p;
    
    ranovatbl = ranova(rm,'WithinModel',arg3);
    all_ranovatbl2{KK}=ranovatbl;
    local_p2=table2array(ranovatbl([2 4 5],5));
    p_to_store2(KK,:)=local_p2;
    
    
end
%%

connections_from_isolated_NN.RM=RM2;
connections_from_isolated_NN.IX=IX2;
connections_from_isolated_NN.tit=TIT;
connections_from_isolated_NN.ranovatbl=all_ranovatbl2;
%%

p_corrected1=p_to_store2*0;
p_corrected2=p_to_store2*0;
for i=1:3
    [h crit_p p_corrected1(:,i)]=fdr_bh(p_to_store2(:,i));
%     p_corrected2(:,i)=mafdr(p_to_store2(:,i));
end
p_corrected=p_corrected1;
%%
p_uncorrected_table=array2table(p_to_store2);
p_corrected_table=array2table(p_corrected);
local_names=ranovatbl.Properties.RowNames([2 4 5]);
for ij=1:length(local_names)-1
    to_fix=local_names{ij};
    to_fix(to_fix==':')='_';
    to_fix(to_fix=='(')='';
    to_fix(to_fix==')')='';
    if strfind(to_fix,'Intercept')
        to_fix(1:10)=[];
    end
    local_names{ij}=[arg1 '_' to_fix];
end
ij =ij+1;
to_fix=local_names{ij};
to_fix(to_fix==':')='_';
to_fix(to_fix=='(')='';
to_fix(to_fix==')')='';
if strfind(to_fix,'Intercept')
    to_fix(1:10)=[];
end
local_names{ij}=[to_fix '_' arg1];

p_uncorrected_table.Properties.VariableNames=local_names;
p_corrected_table.Properties.VariableNames=local_names;

p_uncorrected_table.Properties.RowNames=TIT;
p_corrected_table.Properties.RowNames=TIT;


connections_from_isolated_NN.p_uncorrected=p_uncorrected_table;
connections_from_isolated_NN.p_corrected=p_corrected_table;
%%
rm=global_stats.posthoc_3F_RM_by_networks.RM{1};
rm=rm_backup;
parcel=global_stats.parcel;
i=1;
arg1=rm.WithinFactorNames{3};
arg3=rm.WithinFactorNames{2};
arg2=rm.BetweenFactorNames{1};
options=global_stats.options;
m=margmean(rm,{arg1 arg2 arg3 });

%%
pth=global_stats.options.p_th;

p_local=p_to_store2(:,end);% uncorrected
% p_local=p_corrected(:,end);% corrected
[a b]=sort(p_local,'ascend');
i_j_k=sum(a<pth);
n=i_j_k;

xtl=table2array(unique(local_table(:,2)));

if n>0
    
    if global_stats.options.display_figures
        vis_flag='on';
    else
        vis_flag='off';
    end
    
    fig_name=tit;
    fig_name(fig_name==' ')='_';
    fig_size=[8 1 20 20];
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
    p_th_vector=[pth([1 1]) 1 1];% This vector define the thresholds to be used for visualization, the asked one and one
    p_th_plot=[p_corrected(:,end) p_to_store2(:,end) p_corrected(:,end) p_to_store2(:,end)]; % to show uncorrected and uncorrected p_values
    
    shortnames=cell(sum(cat(1,parcel.n)),1);
    for i=1:length(parcel)
        shortnames(parcel(i).ix)={parcel(i).shortname};
    end
    
    
    sq=ceil(sqrt(n));
    
    figure_counter=4;
    for i_j=1:n
        kk=b(i_j);
        subplot(sq,sq,i_j)
        local_p=p_corrected(kk,3);% replaced for p_th_plot to make 4 figure
        local_p=p_th_plot(kk,figure_counter);
        local_ix=find(ismember(table2cell(m(:,1)),TIT{kk}));
        min_y_plot=100;
        max_y_plot=-100;
        if local_p<=p_th_vector(figure_counter)%local_p<pth%ptable.shown(qn)
            for ijk=1:n_lines
                local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
                mm=table2array(m(local_ix(local_ix2),4));
                se=table2array(m(local_ix(local_ix2),5));
                
                n_traces=size(mm,1);
                ii=1:n_traces;
                line([ii;ii],[mm+tse*se mm-tse*se]',...
                    'color',between_design.subgroups(ijk).color,...
                    'linewidth',lw)
                
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
                
                hold all
                plot(ii,mm,mk,'color',between_design.subgroups(ijk).color,...
                    'LineWidth',lw,...
                    'MarkerSize',6,...
                    'MarkerEdgeColor',between_design.subgroups(ijk).color,...
                    'MarkerFaceColor',[1 1 1])
                
            end
            hold off
            delta=diff([min_y_plot max_y_plot])*.25;
            min_y_plot=min_y_plot-delta;
            ylim([min_y_plot max_y_plot])
            
        end
        box on
        xlim([1 n_traces]);
        set(gca,'xtick',ii)
        set(gca,'xticklabel',[])
        if i==1
            ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                'color',parcel(options.resort_parcel_order(j)).RGB,...
                'fontsize',fs_label)
        end
%         if j==n_parcel
%             xlabel(parcel(options.resort_parcel_order(i)).shortname,...
%                 'color',parcel(options.resort_parcel_order(i)).RGB,...
%                 'fontsize',fs_label)
%             set(gca,'xticklabel',xtl)
%         end
        
        xl=xlim;
        dxl=abs(diff(xl));
        xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
        yl=ylim;
        dyl=abs(diff(yl));
        ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
        tit_label=TIT{kk};
        ix=str2num(tit_label(6:end));
        foo=table2array(ix_to_ix(:,ix));
        tit_label(tit_label=='_')=' ';
        tit_labelcat{1}=tit_label;
        tit_labelcat{2}=['ROIs: ' num2str(foo(1)) ' and ' num2str(foo(2))];
        tit_labelcat{3}=['Networks: ' shortnames{foo(1)} ' and ' shortnames{foo(2)}];
        
        title(tit_labelcat,...
            'fontsize',fs_title)
        if and(local_p<p_th_vector(figure_counter),options.show_p_value)
            text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
                'Fontsize',fs_title,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
            
        end
        set(gca,'xticklabel',xtl)
        
        if and(options.show_y_scale,local_p<p_th_vector(figure_counter))
            yl=get(gca,'ytick');
            axis_label=set_axis_label(yl);
            set(gca,'yticklabel',axis_label)
        else
            set(gca,'yticklabel',[])%
        end
        
        
    end
    
    %%
    if options.save_figures
        %     savefig(fig_name)
        local_fig_name=fig_name;
        saveas(gcf,[folder_rf filesep local_fig_name])
        print([folder_rf filesep local_fig_name],'-dpng','-r300')
%         print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
        if figure_counter==1
            copyfile([folder_rf filesep local_fig_name '.png'],['summary' filesep]);
        end
    end
    
    
end