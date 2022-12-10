function plot_P_V(P,V,output_folder,my_color_ix)

%% Oscar Miranda-Dominguez
% First line of code: Nov 26, 2021

%% Read output folder

if nargin<3
    output_folder=pwd;
end
%%
my_color=[140,81,10
    53,151,143]/255;% 1 color per trace

if nargin<4
    my_color_ix=1:2;
end

my_color=my_color(my_color_ix,:);


%% Check/make folder

if ~isfolder(output_folder)
    mkdir(output_folder)
end


%% Define names and run
tit={'\it{p}\rm\bf-value and Explained Variance','\fontsize{9}'};



filename=cell(2,1);
filename{1}='pValue_Variance_by_brainFeature';
filename{2}='logpValue_Variance_by_brainFeature';

pValue_label=cell(2,2);
pValue_label{1,1}='Within sample \it{p}\rm-value';
pValue_label{1,2}='';
pValue_label{2,1}='Within sample \it{p}\rm-value';
pValue_label{2,2}='(log scale)';


do_plot_P_V(P,100*V,output_folder,tit,filename{1},pValue_label(1,:),my_color)
do_plot_P_V(-log10(P),100*V,output_folder,tit,filename{2},pValue_label(2,:),my_color)

function do_plot_P_V(P,V,output_folder,tit,filename,pValue_label,my_color)


% count brain features
n=size(P,1);

% Pre allocate memory

n_traces=size(V,2);


%% Define parameters for figure
vis_flag='on';
fig_size=[1 1 8 6];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

%% Define colors

subplot('position',[0.16 .25 0.7 0.6]);
plot(P(1),V(1,1),'.',...
    'color',my_color(1,:))
hold all
for i=2:n_traces
    plot(P(1),V(1,i),'.',...
    'color',my_color(i,:))
    plot(P,V(:,i),'.',...
        'color',my_color(i,:))
end
plot(P,V(:,1),'.',...
        'color',my_color(1,:))
hold off


yl=ylim;
axis tight
ylim(yl);
if max(P)<=1
    xlim([0 1])
end
if n_traces==2
    leg=legend('Within sample','Between sample',...
        'location','best');
end

title(tit)
xlabel(pValue_label)


ylabel(['% Exp. Variance \fontsize{8}(100\timesR^2)'])
ylab=get(gca,'ytick');
set(gca,'ytick',ylab);
axis_label=set_axis_label(ylab);
set(gca,'yticklabel',axis_label)

%% Adding hist
yt=get(gca,'ytick');
pos=get(gca,'position');

%
pos2=pos;
pos2(1)=pos(1)+pos(3);
pos2(3)=0.9*(1-pos2(1));
subplot('position',pos2);

%
labs=repmat((1:n_traces),size(V,1),1);
labs=arrayfun(@num2str, labs(:));
T=table(labs,V(:));
use_median_instead_of_mean_flag=1;
dotted_line_flag=0;
show_text_flag=0;
skinny_plot(T,my_color,...
    'yl',yl,...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'dotted_line_flag',dotted_line_flag,...
    'show_text_flag',show_text_flag)
ylim(yl)
set(gca,'ytick',yt)
set(gca,'yticklabel',[])
set(gca,'xtick',[]);
title('')
ylabel('')
box on
%%
set(gcf,'name',filename)
saveas(gcf,[output_folder filesep filename])
print([output_folder filesep filename],'-dpng','-r300')
print([output_folder filesep filename],'-dtiffn','-r300')

%%
%
% %% For future work
% xl=xlim;
% yyaxis left
% ax.XScale='log';
% set(gca,'xtick',10.^[0:floor(log10(xl(2)))])
% which neg_log10_max_P
%
% path_brain_feature='/panfs/roc/groups/4/miran045/shared/projects/ABCD_neurocog/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ARM1/case2_yes_covariates_g1/tables/brain_feature.csv';
% path_Rsquared='/panfs/roc/groups/4/miran045/shared/projects/ABCD_neurocog/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ARM1/case2_yes_covariates_g1/tables/Rsquared.csv';
% output_folder='/panfs/roc/groups/4/miran045/shared/projects/ABCD_neurocog/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ARM1/case2_yes_covariates_g1';
% %%
% T = readtable(path_brain_feature);
% W=T.Estimate;
% pValues=T.pValue;
%
% T = readtable(path_Rsquared);
% V=T.Adjusted;
% cd(output_folder)
%
%
% n_th=numel(options.percentile)+1;
% % n_features=prod(sz);
% R_Adjusted=V;
% n_features=numel(R_Adjusted);
% IX=zeros(n_th,n_features);
%
% [f1 ix_in]=max(R_Adjusted);
% IX(1,ix_in(1))=1;
% ptiles=prctile(R_Adjusted,100-options.percentile);
% for i=2:n_th
%     ix_in=R_Adjusted>=ptiles(i-1);
%     IX(i,:)=ix_in;
% end
%
%
% neg_log10_max_P = get_lines_neg_log10_max_P(IX,...
%     pValues,...
%     options)
%
%
% plot_W_V(W,V)
