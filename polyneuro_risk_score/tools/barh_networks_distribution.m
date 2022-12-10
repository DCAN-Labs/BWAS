function barh_networks_distribution(path_explained_variance_cifti,path_parcellation_table,varargin)
%%
%% Example
% path_explained_variance_cifti='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/testing_arena/outputs_om/basic_example/CWAS/ciftis/explained_variance.ptseries.nii';
% path_parcellation_table='/panfs/roc/groups/8/faird/shared/code/internal/utilities/polyneuro_risk_score/data/xsectional_1_outcome_pcaLutein_fconn/HCP_ColeAnticevic.csv';
% output_folder='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/testing_arena/outputs_om/basic_example/CWAS';
% barh_networks_distribution(path_explained_variance_cifti,path_parcellation_table,...
%     'output_folder',output_folder)
%% Define defaults

fs = filesep;


% Define outpur folder
output_folder=[pwd fs 'PBS'];

% Define default options
options.symmetrize=1;
user_provided_options_flag=0;
options.percentile=[.1 .2 .5 1 2 5 10 25 50 100];

% path_pvalue_cifti
path_pvalue_cifti=[];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'path_pvalue_cifti'
            path_pvalue_cifti=varargin{q+1};
            q = q+1;
            
        case 'options'
            user_provided_options_flag=1;
            options=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% identify if is pconn
ispconn=contains(path_explained_variance_cifti,'pconn.nii');
%% Move to output_folder

if ~isfolder(output_folder)
    mkdir(output_folder)
end

%% Make output folder Manhatthan and Relative contribution figures

output_folder_Manhattan_plots = [output_folder fs 'figures' fs 'Manhattan_plots'];
output_folder_RelativeContribution_plots = [output_folder fs 'figures' fs 'RelativeContribution_plots'];

if ~isfolder(output_folder_Manhattan_plots)
    mkdir(output_folder_Manhattan_plots)
end
if ~isfolder(output_folder_RelativeContribution_plots)
    mkdir(output_folder_RelativeContribution_plots)
end
%% Load explained variance

fconn = load_imaging_data(path_explained_variance_cifti);
%% Tabify imaging data

F=fconn;
if ispconn
    F=cat(3,fconn,fconn);
end

[Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(F,options);

R_Adjusted=Y{:,1};
if ispconn
    R_Adjusted=Y{1,:}';
else
    ind=[1:sz(1)]';
end
%% pre-allocate memory
n_th=numel(options.percentile)+1;
% n_features=prod(sz);
n_features=numel(R_Adjusted);
IX=zeros(n_th,n_features);

[f1 ix_in]=max(R_Adjusted);
IX(1,ix_in(1))=1;
ptiles=prctile(R_Adjusted,100-options.percentile);
for i=2:n_th
    ix_in=R_Adjusted>=ptiles(i-1);
    IX(i,:)=ix_in;
end
%% Read parcellation scheme and count functionalk network pairs
parcel=loadParcel(path_parcellation_table);
[network_names, row, col]=get_network_names(parcel,imaging_type,ind,options);
within_headers=network_names;
[u,nu,ix,nix]=find_uniques(within_headers);

%% Save table with ROI and features
save_mapping_brain_feature_ROIs(row, ...
    col,...
    network_names,...
    path_explained_variance_cifti);
%% Make colormap if 3D
if ispconn
    parcel = network_network_as_parcel(parcel,imaging_type,ind,options);
end
% if strcmp(imaging_type,'3D')
%     RGB=[166,206,227
%         31,120,180
%         178,223,138
%         51,160,44
%         251,154,153
%         227,26,28
%         253,191,111
%         255,127,0
%         202,178,214
%         106,61,154
%         255,255,153
%         177,89,40]/255;
%     shortname=u;
%     RGB=repmat(RGB,ceil(nu/size(RGB,1)),1);
%     RGB(nu+1:end,:)=[];
%     parcel=[shortname table(RGB) table(ix) table(nix)];
%     parcel.Properties.VariableNames{1}='shortname';
%     parcel.Properties.VariableNames{end}='n';
%     parcel=[shortname parcel];
%     parcel.Properties.VariableNames{1}='name';
%     parcel=table2struct(parcel);
% end
% parcel=parcel';
%% Count
C=zeros(n_th,nu);
for i=1:n_th
    local_IX=find(IX(i,:));
    for j=1:nu
        local_ix=ix{j};
        is_member=ismember(local_ix,local_IX);
        C(i,j)=sum(is_member);
    end
end
ALL=zeros(1,nu);
local_IX=1:n_features;
for j=1:nu
    local_ix=ix{j};
    is_member=ismember(local_ix,local_IX);
    ALL(1,j)=sum(is_member);
end
%% Normalize count and calculate xposition for labels
R=C./sum(C,2);
cum=cumsum(R,2);
xpos=cum-R/2;
%% Th names
th_names=cell(n_th,1);
th_names{1}='Top feature';
numstext=num2str([options.percentile]');
numstext=set_axis_label(options.percentile);
for i=2:n_th
    local_text=['top ' numstext(i-1,:) ' %'];
    th_names{i}=local_text;
end
%% Make show_contributions_using_showM(IX,parcel)
% if strcmp(imaging_type,'3D')
%     show_contributions_using_showM(IX,path_parcellation_table,options, imaging_type, ind, sz,th_names,output_folder)
% end
%% Define figure size

if strcmp(imaging_type,'2D')
    fig_wide=12;
else
    fig_wide=22;
end
fig_tall=12;
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);
%% Make the main figure
subplot('Position',[0.08 0.08 0.9 0.9])
b=barh(R,'stacked');
% if strcmp(imaging_type,'2D')
for i=1:nu
    try
        ix_parcel=find(ismember(cat(1,parcel.shortname),u{i,1}));
        b(i).FaceColor=parcel(ix_parcel).RGB;
    catch
        b(i).FaceColor=[1 1 1];
    end
end
% end
for j=1:n_th
    text(0,j,th_names{j},...
        'HorizontalAlignment','right',...
        'fontsize',9)
end
set(gca,'YDir','reverse')
%% Set limits
% set(gca,'yticklabel',th_names)
xlim([0 1])
set(gca,'xtick',[])
axis off
%% add texts
for i=1:n_th
    local_x=xpos(i,:);
    for j=1:nu
        localR=R(i,j);
        if localR>0
            %             text(local_x(j),i,num2str(localR*100,'%4.1f'),...
            %                 'fontsize',8.2,...
            %                 'color','w',...
            %                 'HorizontalAlignment','center')
            if localR<.03
                local_text=[num2str(localR*100,'%4.0f')];
            else
                local_text=[num2str(localR*100,'%4.0f') '%'];
            end
            text(local_x(j),i,local_text,...
                'fontsize',7,...
                'Rotation',30,...
                'HorizontalAlignment','center')
        end
    end
end
for j=1:nu
    offset=mod(j,2)/2;
    %     text(local_x(j),i+1-offset,u{j,1},...
    %         'fontsize',8,...
    %         'HorizontalAlignment','center',...
    %         'VerticalAlignment','top')
    %
    text(local_x(j),i+0.5,u{j,1},...
        'fontsize',7,...
        'Rotation',90,...
        'HorizontalAlignment','right',...
        'VerticalAlignment','middle')
end
title('Relative contribution of networks per threshold')

if strcmp(imaging_type,'2D')
    set(gca,'position',[.18 .1 .8 .85])
else
    set(gca,'position',[.1 .12 .89 .83])
end
%% Save
%     savefig(fig_name)
fig_name='Relative_networks_contribution';
folder_rf=output_folder_RelativeContribution_plots;
local_fig_name=fig_name;
saveas(gcf,[folder_rf filesep local_fig_name])
print([folder_rf filesep local_fig_name],'-dpng','-r300')
print([folder_rf filesep local_fig_name],'-dtiffn','-r300')

%% Do truncated version

th=0.01;
ix_filter=R(end,:)<th;
if sum(ix_filter)>1
    %
    R1=R(:,ix_filter==0);
    R2=R(:,ix_filter==1);
    R3=sum(R2,2);
    Rtrunc=[R1 R3];
    utrunc=u(ix_filter==0,:);
    utrunc{end+1,1}={['less than ' num2str(100*th,'%4.0f') '%']};
    %%
    R=Rtrunc;
    cum=cumsum(R,2);
    xpos=cum-R/2;
    u=utrunc;
    nu=numel(u);
    
    %%
    h = figure('Visible','on',...
        'Units','centimeters',...
        'PaperUnits','centimeters',...
        'Position',[8 1 fig_wide fig_tall],...
        'PaperPosition',[8 1 fig_wide fig_tall],...
        'color',fig_color);
    %% Make the main figure
    b=barh(R,'stacked');
    
    for i=1:nu
        try
            ix_parcel=find(ismember(cat(1,parcel.shortname),u{i,1}));
            b(i).FaceColor=parcel(ix_parcel).RGB;
        catch
            b(i).FaceColor=[1 1 1];
        end
    end
    for j=1:n_th
        text(0,j,th_names{j},...
            'HorizontalAlignment','right',...
            'fontsize',9)
    end
    set(gca,'YDir','reverse')
    %% Set limits
    % set(gca,'yticklabel',th_names)
    xlim([0 1])
    set(gca,'xtick',[])
    axis off
    %% add texts
    for i=1:n_th
        local_x=xpos(i,:);
        for j=1:nu
            localR=R(i,j);
            if localR>0
                %             text(local_x(j),i,num2str(localR*100,'%4.1f'),...
                %                 'fontsize',8.2,...
                %                 'color','w',...
                %                 'HorizontalAlignment','center')
                if localR<.03
                    local_text=[num2str(localR*100,'%4.0f')];
                else
                    local_text=[num2str(localR*100,'%4.0f') '%'];
                end
                text(local_x(j),i,local_text,...
                    'fontsize',7,...
                    'Rotation',30,...
                    'HorizontalAlignment','center')
            end
        end
    end
    for j=1:nu
        offset=mod(j,2)/2;
        %     text(local_x(j),i+1-offset,u{j,1},...
        %         'fontsize',8,...
        %         'HorizontalAlignment','center',...
        %         'VerticalAlignment','top')
        %
        text(local_x(j),i+0.5,u{j,1},...
            'fontsize',8,...
            'Rotation',90,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','middle')
    end
    title('Relative contribution of networks per threshold')
    
    if strcmp(imaging_type,'2D')
        set(gca,'position',[.18 .1 .8 .85])
    else
        set(gca,'position',[.1 .12 .89 .83])
    end
    %% Save
    %     savefig(fig_name)
    fig_name='Relative_networks_contribution_truncated';
    folder_rf=output_folder_RelativeContribution_plots;
    local_fig_name=fig_name;
    saveas(gcf,[folder_rf filesep local_fig_name])
    print([folder_rf filesep local_fig_name],'-dpng','-r300')
    print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
end

%%
if ~isempty(path_pvalue_cifti)
    BWAS_manhattan_plot_like(path_pvalue_cifti,...
        parcel,...
        options,...
        output_folder_Manhattan_plots,...
        ix_filter,...
        th,...
        th_names,...
        IX);
end