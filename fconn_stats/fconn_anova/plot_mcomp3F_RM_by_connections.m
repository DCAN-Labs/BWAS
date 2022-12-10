function posthoc_3F_RM_by_connections=plot_mcomp3F_RM_by_connections(m,parcel,options,arg1,arg2,arg3,between_design,t,to_run,within,ix_to_ix,global_stats)

%%
% fig_name=[stats.varnames{1} ' vs ' stats.varnames{2}];
fig_name=[arg2 '_' arg3 '_' arg1];

if options.display_figures
    vis_flag='on';
else
    vis_flag='off';
end

fig_size=[8 1 20 20];
n_parcel=size(options.resort_parcel_order,2);

if n_parcel>6
    fig_size=[8 1 24 24];
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

% Q=table2array(ptable(:,2+(0:temp_n-1)));% section of the table that will be querried

% n_parcel=size(parcel,2);

% tit=stats.grpnames{1};
tit=unique(table2cell(m(:,1)),'stable');
xtl=table2cell(unique(m(:,3),'stable'));
line_names=unique(table2cell(m(:,2)),'stable');
n_lines=size(line_names,1);
n_traces=size(xtl,1);
for i=1:n_traces
    xtl{i}=char(xtl{i});
end

% xtl=stats.grpnames{2};

mk='O-';

lw=3;
% pth=0.05;

% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
pth=0.05;
pth=options.p_th;
offset_xlim=.2;
offset_ylim=.1;

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
ii=1:n_traces;
% p_to_store=zeros(n_x_networks,1);
p_to_store=zeros(n_x_networks,3);



RM=cell(n_x_networks,1);
IX=cell(n_x_networks,1);
all_ranovatbl=cell(n_x_networks,1);
%% Calculate uncorrected p pvalues
kk=0;
for kk=1:n_x_networks
    display(['Doing RM anova for connection ' num2str(kk) ' out of ' num2str(n_x_networks)]);
    local_within=find(ismember(table2cell(within(:,end)),tit{kk}));
    n_nn=length(local_within);
    part2=['Var1-Var' num2str(n_nn) ' '];
    part4='(local_within,:));';
    part4='(local_within,2));';
    
    local_run=[part1 part2 part3 part4];
    t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
    
    
    %% testing | chicken mode
    %         conn=cell(n_nn,1);
    %         for ijk=1:n_nn
    %             conn{ijk}=['conn_' num2str(ijk)];
    %         end
    
    n_within2=length(unique(table2array(within(local_within,2))));
    
    conn=cell(n_nn,1);
    offset=0;
    for counter=1:n_within2
        for ijk=1:n_nn/n_within2
            conn{ijk+offset}=['conn_' num2str(ijk)];
        end
        offset=offset+ijk;
    end
    
    
    tab2=cell2table(conn);
    local_table=[within(local_within,2) tab2];
    
    
    local_run=[local_run(1:end-24) 'local_table);'];
    %%
    eval(local_run);
    RM{kk}=rm;
    IX{kk}=table2array(ix_to_ix(:,local_within));
    %         ranovatbl = ranova(rm);
    %         local_p=table2array(ranovatbl(end-1,5));
    %         p_to_store(kk)=local_p;
    
    ranovatbl = ranova(rm,'WithinModel',arg3);
    all_ranovatbl{kk}=ranovatbl;
    local_p=table2array(ranovatbl([2 4 5],5));
    p_to_store(kk,:)=local_p;
    
    
end

posthoc_3F_RM_by_connections.RM=RM;
posthoc_3F_RM_by_connections.IX=IX;
posthoc_3F_RM_by_connections.tit=tit;
posthoc_3F_RM_by_connections.ranovatbl=all_ranovatbl;
%% Use FDR to correct
% p_corrected=mafdr(p_to_store);% there is something wrong with this function. Sometimes corrected values are lower than uncorrected
% [h crit_p adj_p]=fdr_bh(p_to_store);
% [sum(p_to_store<=.05) sum(p_corrected<=.05) sum(adj_p<=.05)]

[h crit_p p_corrected]=fdr_bh(p_to_store);

p_corrected1=p_to_store*0;
% p_corrected2=p_to_store*0;
for i=1:3
    [h crit_p p_corrected1(:,i)]=fdr_bh(p_to_store(:,i));
%     p_corrected2(:,i)=mafdr(p_to_store(:,i));
end
p_corrected=p_corrected1;
% if sum(p_corrected1(:,3)<p_corrected1(:,3))
%     p_corrected=p_corrected1;
% else
%     p_corrected=p_corrected2;
% end

p_uncorrected_table=array2table(p_to_store);
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

p_uncorrected_table.Properties.RowNames=tit;
p_corrected_table.Properties.RowNames=tit;


posthoc_3F_RM_by_connections.p_uncorrected=p_uncorrected_table;
posthoc_3F_RM_by_connections.p_corrected=p_corrected_table;
%% Plot the trends

p_th_vector=[pth([1 1]) 1 1];% This vector define the thresholds to be used for visualization, the asked one and one
p_th_plot=[p_corrected(:,end) p_to_store(:,end) p_corrected(:,end) p_to_store(:,end)]; % to show corrected and uncorrected p_values


suffix_figure=cell(4,1);
for i=1:4
    temp_label=['_p_th_' num2str(p_th_vector(i),'%4.2f') '_corrected_flag_' num2str(rem(i,2))];
    temp_label(temp_label=='.')='_';
    suffix_figure{i}=temp_label;
end


close(f)


folder_rf='mcomp3F_RM_by_connections';
mkdir(folder_rf)
%% Excluding strongest differences
p_local=p_to_store(:,end);
[a b]=sort(p_local,'ascend');
xx=table2array(master_t(:,2:end));
within_plus_conn=within;
local_within=[];

part4='_plus_conn);';

WM2=within_plus_conn.Properties.VariableNames{2};
for i=3:size(within_plus_conn,2)
    WM2=[WM2 '*' within_plus_conn.Properties.VariableNames{i}];
end

% p=table2array(global_stats.ranovatbl_connections(end-1,5));
p=table2array(global_stats.ranovatbl_networks(end-5,5));

i_j_k=0;
display(['Running full RM test excluding strongest connections']);
display(['Run ' num2str(i_j_k) ', p = ' num2str(p,'%4.3E')])
while p<=pth
    i_j_k=i_j_k+1;
    kk=b(i_j_k);
    
    
    local_within=[local_within; find(ismember(table2cell(within(:,end)),tit{kk}))];
    x=xx;
    x(:,local_within)=[];
    within_plus_conn=within;
    within_plus_conn(local_within,:)=[];
    t=[master_t(:,1) array2table(x)];
    part2=['x1-x' num2str(size(x,2))];
    local_to_run=[part1 part2 part3 part4];
    eval(local_to_run)
    ranovatbl2 = ranova(rm,'WithinModel',WM2);
    p=table2array(ranovatbl2(end-1,5));
    display(['Run ' num2str(i_j_k) ', p = ' num2str(p,'%4.3E')])
end
i_j_k=i_j_k-1;
%%
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
p_th_plot=[p_corrected(:,end) p_to_store(:,end) p_corrected(:,end) p_to_store(:,end)]; % to show corrected and uncorrected p_values

shortnames=cell(sum(cat(1,parcel.n)),1);
for i=1:length(parcel)
    shortnames(parcel(i).ix)={parcel(i).shortname};
end

n=i_j_k;
sq=ceil(sqrt(n));

figure_counter=2;
for i_j=1:n
    kk=b(i_j);
    subplot(sq,sq,i_j)
    local_p=p_corrected(kk,3);% replaced for p_th_plot to make 4 figure
    local_p=p_th_plot(kk,figure_counter);
    local_ix=find(ismember(table2cell(m(:,1)),tit{kk}));
    min_y_plot=100;
    max_y_plot=-100;
    if local_p<=p_th_vector(figure_counter)%local_p<pth%ptable.shown(qn)
        for ijk=1:n_lines
            local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
            mm=table2array(m(local_ix(local_ix2),4));
            se=table2array(m(local_ix(local_ix2),5));
            
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
    if j==n_parcel
        xlabel(parcel(options.resort_parcel_order(i)).shortname,...
            'color',parcel(options.resort_parcel_order(i)).RGB,...
            'fontsize',fs_label)
        set(gca,'xticklabel',xtl)
    end
    
    xl=xlim;
    dxl=abs(diff(xl));
    xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
    yl=ylim;
    dyl=abs(diff(yl));
    ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
    tit_label=tit{kk};
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
    
    if and(options.show_y_scale,local_p<p_th_vector(figure_counter))
        yl=get(gca,'ytick');
        axis_label=set_axis_label(yl);
        set(gca,'yticklabel',axis_label)
    else
        set(gca,'yticklabel',[])%
    end
    
    
end


if options.save_figures
    %     savefig(fig_name)
    local_fig_name=fig_name;
    saveas(gcf,[folder_rf filesep local_fig_name])
    print([folder_rf filesep local_fig_name],'-dpng','-r300')
    print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
    if figure_counter==1
        copyfile([folder_rf filesep local_fig_name '.png'],['summary' filesep]);
    end
end


