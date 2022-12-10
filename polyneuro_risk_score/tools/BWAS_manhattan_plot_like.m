function BWAS_manhattan_plot_like(path_pvalue_cifti,...
        parcel,...
        options,...
        output_folder,...
        ix_filter,...
        th,...
        th_names,...
        IX)
%% Load p-Values variance

pValues_raw = load_imaging_data(path_pvalue_cifti);



%% Tabify imaging data

ispconn=contains(path_pvalue_cifti,'pconn.nii');
P=pValues_raw;
if ispconn
    P=cat(3,pValues_raw,pValues_raw);
end

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(P,options);

pValues=Y{:,1};
if ispconn
    pValues=Y{1,:}';
end

%% Calculate values to show lines in manhattan plots
neg_log10_max_P = get_lines_neg_log10_max_P(IX,...
    pValues,...
    options);
%% Read indices
[x, ix_cat, C,ix_tick,xlab,networks] = parcel_to_ix_sorted(parcel);
y=-log10(pValues(ix_cat));
sz=(y-min(y));
sz=sz/max(sz);
% min_max=[1 50];
% sz=min_max(2)*sz+min_max(1);
min_max=[2 8];
sz=min_max(2)*sz+min_max(1);
sz=sz.^2;

%%
%% Define figure size

if strcmp(imaging_type,'2D')
    fig_wide=12;
    
else
    fig_wide=22;
end
fig_tall=8;
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);

%%
my_color=C(ix_cat,:);
P=table(x(:),y(:),sz(:),my_color,networks(ix_cat));
P.Properties.VariableNames{1}='x';
P.Properties.VariableNames{2}='y';
P.Properties.VariableNames{3}='sz';
P.Properties.VariableNames{4}='my_color';
P.Properties.VariableNames{5}='networks';
subplot('Position',[0.06 0.25 0.86 0.73])
if strcmp(imaging_type,'2D')
    subplot('Position',[0.08 0.25 0.84 0.65])
end
scatter(x,y,sz,my_color,'filled')
yl =ylim;
% Making sure first value in the yaxis is zero
if yl(1)>0
    yl(1)=0;
end
axis tight
ylim(yl)
set(gca,'xtick',ix_tick)
set(gca,'xticklabel',xlab,'XTickLabelRotation',90,'fontsize',8)
add_th_lines_y_axis(neg_log10_max_P,...
    th_names)
ylabel('-log_{10}(P)')
box on


yticks=get(gca,'ytick');
set(gca,'ytick',yticks);
axis_label=set_axis_label(yticks);
set(gca,'yticklabel',axis_label)
%% Save
%     savefig(fig_name)
fig_name='BWAS_manhattan_plot_like';
folder_rf=output_folder;
local_fig_name=fig_name;
saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
print([folder_rf filesep local_fig_name],'-dtiffn','-r300')

%% Resize/optimize for visualization

%% Define figure size | a few per plot

% if strcmp(imaging_type,'2D')
%     fig_wide=12;
% else
%     fig_wide=12;
% end
% fig_tall=6;
% 
% fig_color='w';
% h = figure('Visible','on',...
%     'Units','centimeters',...
%     'PaperUnits','centimeters',...
%     'Position',[8 1 fig_wide fig_tall],...
%     'PaperPosition',[8 1 fig_wide fig_tall],...
%     'color',fig_color);
% 
% 
% n_per_row=10;
% total_networks=numel(xlab);
% rows=ceil(total_networks/n_per_row);
% from_to=[1:n_per_row:n_per_row*rows;n_per_row:n_per_row:n_per_row*rows];
% from_to(end)=total_networks;
% 
% N=cat(1,parcel.n);
% N=cumsum(N);
% offset=0;
% for i=1:rows
%     %     subplot(rows,1,i);
%     local_ix=from_to(1,i):from_to(2,i);
%     to_filter=xlab(local_ix);
%     local_ix_table=find(ismember(P.networks,to_filter));
%     local_table=P(local_ix_table,:);
%     local_x=local_table.x;
%     local_y=local_table.y;
%     local_sz=local_table.sz;
%     local_my_color=local_table.my_color;
%     subplot('Position',[0.08 0.30 0.8 0.66])
%     scatter(local_x,local_y,local_sz,local_my_color,'filled')
%     axis tight
%     ylim(yl)
%     ylabel('-log_{10}(P)')
%     set(gca,'xtick',ix_tick(local_ix))
%     set(gca,'xticklabel',xlab(local_ix),'XTickLabelRotation',90,'fontsize',7)
%     add_th_lines_y_axis(neg_log10_max_P,...
%         th_names)
%     
%     box on
%     
%     yticks=get(gca,'ytick');
%     axis_label=set_axis_label(yticks);
%     set(gca,'yticklabel',axis_label)
%     
%     
%     fig_name=['BWAS_manhattan_plot_v2_' num2str(i) '_out_of_' num2str(rows)];
%     folder_rf=output_folder;
%     local_fig_name=fig_name;
%     saveas(gcf,[folder_rf filesep local_fig_name])
%     print([folder_rf filesep local_fig_name],'-dpng','-r300')
%     print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
% end

%% Tall
% fig_wide=12;
% if strcmp(imaging_type,'2D')
%     fig_tall=12;
% else
%     fig_tall=22;
% end
% 
% fig_color='w';
% h = figure('Visible','on',...
%     'Units','centimeters',...
%     'PaperUnits','centimeters',...
%     'Position',[8 1 fig_wide fig_tall],...
%     'PaperPosition',[8 1 fig_wide fig_tall],...
%     'color',fig_color);
% scatter(y,x,sz,my_color,'filled')
% xl =xlim;
% axis tight
% add_th_lines_y_axis(neg_log10_max_P,...
%     th_names)
% xlabel('-log_{10}(P)')
% set(gca,'ytick',ix_tick)
% set(gca,'yticklabel',xlab,'YTickLabelRotation',0,'fontsize',8)
% set(gca,'YDir','reverse')
% 
% xlim(xl)
% box on
% 
% xticks=get(gca,'xtick');
% axis_label=set_axis_label(xticks);
% set(gca,'xticklabel',axis_label)
% 
% 
% 
% fig_name='BWAS_manhattan_plot_v3';
% folder_rf=output_folder;
% local_fig_name=fig_name;
% saveas(gcf,[folder_rf filesep local_fig_name])
% print([folder_rf filesep local_fig_name],'-dpng','-r300')
% print([folder_rf filesep local_fig_name],'-dtiffn','-r300')

%% Make truncated
if strcmp(imaging_type,'2D')
    fig_wide=12;
    
else
    fig_wide=22;
end
fig_tall=8;
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);




total_networks=numel(xlab);


N=cat(1,parcel.n);
N=cumsum(N);
offset=0;

% BIG NETWORKS
local_ix=find(ix_filter==0);
to_filter=xlab(local_ix);
local_ix_table=find(ismember(P.networks,to_filter));
local_table=P(local_ix_table,:);
local_x=local_table.x;
local_x=1:numel(local_x);
local_y=local_table.y;
local_sz=local_table.sz;
local_my_color=local_table.my_color;


% SMALL NETWORKS TO BE ANONIMIZED
local_ixB=find(ix_filter==1);
to_filterB=xlab(local_ixB);
local_ix_tableB=find(ismember(P.networks,to_filterB));
local_tableB=P(local_ix_tableB,:);
local_xB=local_tableB.x;
local_xB=1:numel(local_xB);
local_xB=local_xB+local_x(end);
local_yB=local_tableB.y;
local_szB=local_tableB.sz;
local_my_colorB=local_tableB.my_color;
local_my_colorB(:)=.7;

% FOR TICKS
N=cat(1,parcel.n);
ix_tick=[N(local_ix) ; numel(local_xB)];
offset=ix_tick/2;
ix_tick=cumsum(ix_tick)-offset;
subplot('Position',[0.06 0.25 0.86 0.73])
if strcmp(imaging_type,'2D')
    subplot('Position',[0.08 0.25 0.86 0.65])
end

% merged
merged_x=[local_x local_xB];
merged_y=[local_y; local_yB];
merged_sz=[local_sz; local_szB];
merged_color=[local_my_color;local_my_colorB];
merged_xlab=xlab(local_ix);
merged_xlab(end+1)={['less than ' num2str(100*th,'%4.0f') '%']};

scatter(merged_x,merged_y,merged_sz,merged_color,'filled')
axis tight
ylim(yl)
add_th_lines_y_axis(neg_log10_max_P,...
    th_names)
ylabel('-log_{10}(P)')
set(gca,'xtick',ix_tick)
set(gca,'xticklabel',merged_xlab,'XTickLabelRotation',90,'fontsize',8)


box on

yticks=get(gca,'ytick');
set(gca,'ytick',yticks);
axis_label=set_axis_label(yticks);
set(gca,'yticklabel',axis_label)


fig_name=['BWAS_manhattan_plot_truncated'];
folder_rf=output_folder;
local_fig_name=fig_name;
saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
print([folder_rf filesep local_fig_name],'-dtiffn','-r300')


%% BIG NETWORKS
if strcmp(imaging_type,'2D')
    fig_wide=12;
    
else
    fig_wide=22;
end
fig_tall=8;
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);




total_networks=numel(xlab);


N=cat(1,parcel.n);
N=cumsum(N);
offset=0;

% BIG NETWORKS
local_ix=find(ix_filter==0);
to_filter=xlab(local_ix);
local_ix_table=find(ismember(P.networks,to_filter));
local_table=P(local_ix_table,:);
local_x=local_table.x;
local_x=1:numel(local_x);
local_y=local_table.y;
local_sz=local_table.sz;
local_my_color=local_table.my_color;

% FOR TICKS
N=cat(1,parcel.n);
ix_tick=[N(local_ix) ];
offset=ix_tick/2;
ix_tick=cumsum(ix_tick)-offset;
subplot('Position',[0.06 0.25 0.86 0.68])
if strcmp(imaging_type,'2D')
    subplot('Position',[0.08 0.25 0.86 0.65])
end

% merged
merged_x=[local_x ];
merged_y=[local_y; ];
merged_sz=[local_sz; ];
merged_color=[local_my_color;];
merged_xlab=xlab(local_ix);

scatter(merged_x,merged_y,merged_sz,merged_color,'filled')
axis tight
ylim(yl)
add_th_lines_y_axis(neg_log10_max_P,...
    th_names)
ylabel('-log_{10}(P)')
set(gca,'xtick',ix_tick)
set(gca,'xticklabel',merged_xlab,'XTickLabelRotation',90,'fontsize',8)


box on

yticks=get(gca,'ytick');
set(gca,'ytick',yticks);
axis_label=set_axis_label(yticks);
set(gca,'yticklabel',axis_label)
title(['Networks with \geq ' num2str(100*th) ' % of the total count of connections'])

fig_name=['BWAS_manhattan_plot_networks_covering_more_than_' num2str(100*th) '_percent'];
folder_rf=output_folder;
local_fig_name=fig_name;
saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
print([folder_rf filesep local_fig_name],'-dtiffn','-r300')

%% SMALL NETWORKS
if strcmp(imaging_type,'2D')
    fig_wide=12;
    
else
    fig_wide=22;
end
fig_tall=8;
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);




total_networks=numel(xlab);


N=cat(1,parcel.n);
N=cumsum(N);
offset=0;

% SMALL NETWORKS
local_ix=find(ix_filter==1);
to_filter=xlab(local_ix);
local_ix_table=find(ismember(P.networks,to_filter));
local_table=P(local_ix_table,:);
local_x=local_table.x;
local_x=1:numel(local_x);
local_y=local_table.y;
local_sz=local_table.sz;
local_my_color=local_table.my_color;

% FOR TICKS
N=cat(1,parcel.n);
ix_tick=[N(local_ix) ];
offset=ix_tick/2;
ix_tick=cumsum(ix_tick)-offset;
subplot('Position',[0.06 0.25 0.86 0.68])
if strcmp(imaging_type,'2D')
    subplot('Position',[0.08 0.25 0.86 0.65])
end

% merged
merged_x=[local_x ];
merged_y=[local_y; ];
merged_sz=[local_sz; ];
merged_color=[local_my_color;];
merged_xlab=xlab(local_ix);

scatter(merged_x,merged_y,merged_sz,merged_color,'filled')
axis tight
ylim(yl)
add_th_lines_y_axis(neg_log10_max_P,...
    th_names)
ylabel('-log_{10}(P)')
set(gca,'xtick',ix_tick)
set(gca,'xticklabel',merged_xlab,'XTickLabelRotation',90,'fontsize',8)
set(gca,'xticklabel',1:numel(ix_tick))


box on

yticks=get(gca,'ytick');
set(gca,'ytick',yticks);
axis_label=set_axis_label(yticks);
set(gca,'yticklabel',axis_label)
title(['Networks with < ' num2str(100*th) ' % of the total count of connections'])

fig_name=['BWAS_manhattan_plot_networks_covering_less_than_' num2str(100*th) '_percent'];
folder_rf=output_folder;
local_fig_name=fig_name;
saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
print([folder_rf filesep local_fig_name],'-dtiffn','-r300')

T=table([1:numel(ix_tick)]',merged_xlab);
T.Properties.VariableNames{1}='index';
T.Properties.VariableNames{2}='name';
filename=[folder_rf filesep local_fig_name '.csv'];
writetable(T,filename)