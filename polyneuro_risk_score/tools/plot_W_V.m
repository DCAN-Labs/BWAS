function plot_W_V(W,V,output_folder)
%% Oscar Miranda-Dominguez

%% Read output folder

if nargin<3
    output_folder=pwd;
end


%% Check/make folder

if ~isfolder(output_folder)
    mkdir(output_folder)
end

%% Define names and run
tit=cell(3,1);
tit{1}={'Weights and Explained Variance','\fontsize{9}'};
tit{2}={'Weights and Explained Variance','\fontsize{9} (sorted by \beta-weigths)'};
tit{3}={'Weights and Explained Variance','\fontsize{9} (sorted by explained variance)'};

filename=cell(3,1);
filename{1}='Weights_explainedVariance_by_brainFeature';
filename{2}='Weights_explainedVariance_by_Weight';
filename{3}='Weights_explainedVariance_by_explainedVariance';

bweight_label='\beta-weight';
do_plot_W_V(W,100*V,output_folder,tit,filename,bweight_label)


%% Repeat for absolute values

tit=cell(3,1);
tit{1}={'|Weights| and Explained Variance','\fontsize{9}'};
tit{2}={'|Weights| and Explained Variance','\fontsize{9} (sorted by |\beta-weigths|)'};
tit{3}={'|Weights| and Explained Variance','\fontsize{9} (sorted by explained variance)'};

filename=cell(3,1);
filename{1}='AbsWeights_explainedVariance_by_brainFeature';
filename{2}='AbsWeights_explainedVariance_by_Weight';
filename{3}='AbsWeights_explainedVariance_by_explainedVariance';

bweight_label='|\beta-weight|';
do_plot_W_V(abs(W),100*V,output_folder,tit,filename,bweight_label)

function do_plot_W_V(W,V,output_folder,tit,filename,bweight_label)

%
if nargin<6
    bweight_label='\beta-weight';
end
% count brain features
n=size(W,1);

% Pre allocate memory
IX=nan(3,n);
IX(1,:)=1:n;
[foo, IX(2,:)]=sort(W,'descend');
[foo, IX(3,:)]=sort(V,'descend');
clear foo



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
my_color=[230,97,1
    0 117 154]/255;

plot(W)
yl1=ylim;

plot(V)
yl2=ylim;
for i=1:3
    ix=IX(i,:);
    
    % ploting
    yyaxis left
    b=bar(W(ix),'FaceColor',my_color(1,:));
    
    yyaxis right
    plot(V(ix),'color',my_color(2,:))
    
    
    % labeling
    yyaxis left
    ylabel(bweight_label)
    
    yyaxis right
    ylabel(['% Exp. Variance \fontsize{8}(100\timesR^2)'])
    xlabel('Brain feature')
    title(tit{i})
    
    % sizing
    yyaxis left
    axis tight
    ylim(yl1)
    
    yyaxis right
    axis tight
    ylim([0 yl2(2)])
    
    
    % replaing yticklabels
    yyaxis left
    ylab=get(gca,'ytick');
    set(gca,'ytick',ylab);
    axis_label=set_axis_label(ylab);
    set(gca,'yticklabel',axis_label)
    
    yyaxis right
    ylab=get(gca,'ytick');
    set(gca,'ytick',ylab);
    axis_label=set_axis_label(ylab);
    set(gca,'yticklabel',axis_label)
    
    
% 
%     yyaxis right
%     yl=ylim;
%     ylim([0 yl(2)])
%     yl=get(gca,'ytick');
%     axis_label=set_axis_label(yl);
%     set(gca,'yticklabel',axis_label)
    
    
    
    ax = gca;
    ax.YAxis(1).Color = my_color(1,:);
    ax.YAxis(2).Color = my_color(2,:);
    
    set(gcf,'name',filename{i})
    saveas(gcf,[output_folder filesep filename{i}])
    print([output_folder filesep filename{i}],'-dpng','-r300')
    print([output_folder filesep filename{i}],'-dtiffn','-r300')
end
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
