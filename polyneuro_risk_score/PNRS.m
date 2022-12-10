function [Table_PBScores, IX, PBScores_null] = PNRS(Y,R,betas,ids,imaging_type,ind,options,varargin)

%% Oscar Miranda-Dominguz
%% Define defaults

% Assume no parcellation table is provided
parcel_set_provided_flag=0;
path_parcellation_table=[];
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'path_parcellation_table'
            path_parcellation_table=varargin{q+1};
            parcel_set_provided_flag=1;
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%% Tablify fconn
fconn=table2array(Y);
[n_subjects,n_features]=size(fconn);
%% Read parcellation scheme and count functionalk network pairs
if parcel_set_provided_flag==1
    parcel=loadParcel(path_parcellation_table);
    network_names=get_network_names(parcel,imaging_type,ind,options);
    within_headers=network_names;
    [u,nu,ix,nix]=find_uniques(within_headers);
else
    ix=[]; % added to getIX as function
end
%% pre-allocate memory
if parcel_set_provided_flag==1
    n_th=nu;
else
    n_th=numel(options.percentile)+1;
end
IX=zeros(n_th,n_features);

%% Read tstat to rank weights
abs_stat=abs(betas.tStat);

%% Read explained variance to rank weights

R_Adjusted=R.Adjusted;
%% Select the top features

IX = getIX(parcel_set_provided_flag,...
    n_th,...
    n_features,...
    R_Adjusted,...
    options,...
    ix);

%
% if parcel_set_provided_flag==1
%     for i=1:n_th
%         IX(i,ix{i})=1;
%     end
% else
%     [f1 ix_in]=max(R_Adjusted);
%     IX(1,ix_in(1))=1;
%     ptiles=prctile(R_Adjusted,100-options.percentile);
%     for i=2:n_th
%         ix_in=R_Adjusted>=ptiles(i-1);
%         IX(i,:)=ix_in;
%     end
% end


%% get PBScores
PBScores = get_PBScores(n_subjects,...
    n_th,...
    betas,...
    fconn,...
    IX);
% %% Pre-allocate memory for scores
% PBScores=nan(n_subjects,n_th);
%
% %% Estimathe the scores
%
% W=repmat([betas.Estimate]',n_subjects,1);
% P=W.*fconn;
% for i=1:n_th
%     PBScores(:,i)=sum(P(:,IX(i,:)==1),2);
% end
%% Tablify PBScores
T=array2table(PBScores);

if parcel_set_provided_flag==1
    try
        T.Properties.VariableNames=table2cell(u);
    catch
        temp=table2cell(u);
        temp=strrep(temp,' ','_');
        T.Properties.VariableNames=temp;
    end
else
    T.Properties.VariableNames{1}='Top_feature';
    numstext=set_axis_label(options.percentile);
    for i=2:n_th
        local_text=['top_' numstext(i-1,:) '_percent'];
        old=' ';
        new=num2str(0);
        local_text = strrep(local_text,old,new);
        old='.';
        new='_point_';
        local_text = strrep(local_text,old,new);
        T.Properties.VariableNames{i}=local_text;
    end
end
%%
T=[ids T];
if parcel_set_provided_flag==1
    filename='scores_by_networks.csv';
else
    filename='scores.csv';
end
filepath=[pwd filesep 'tables'];
if ~isfolder(filepath)
    mkdir(filepath)
end
writetable(T,[filepath filesep filename]);

Table_PBScores=T;
%% Visualizations

% Figure size
vis_flag='on';
fig_size=[1 1 8 12];
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

% Actual plotting
imagesc(nanzscore(PBScores));
colormap jet(256)
xlabel('Brain features'' percentile')
ylabel('Participant')
title ('Normalized Scores')
set(gca,'xtick',1:n_th);

xtl=cell(n_th,1);
if parcel_set_provided_flag==1
    xtl=table2cell(u);
else
    xtl{1}='top';
    for i=2:n_th
        xtl{i}=[num2str(options.percentile(i-1)) ' %'];
    end
end
set(gca,'xticklabel',xtl,'fontsize',8)
xtickangle(45)
try
    my_color=neg_pos_cmap();
    colormap(my_color);
end
colorbar

% Save

filename='Scores';
if parcel_set_provided_flag==1
    xtickangle(90)
    filename='Scores_by_networks';
end
local_folder=[pwd filesep 'figures' filesep 'scores'];
if ~isfolder(local_folder)
    mkdir(local_folder)
end


set(gcf,'name',filename)
saveas(gcf,[local_folder filesep filename])
print([local_folder filesep filename],'-dpng','-r300')
print([local_folder filesep filename],'-dtiffn','-r300')
%% Do null
if nargout>2
    N_null=options.N_null;
    rng shuffle
    PBScores_null=nan(n_subjects,n_th,N_null);
    for i=1:N_null
        ix_null=randperm(n_features);
        
        IX_null = getIX(parcel_set_provided_flag,...
            n_th,...
            n_features,...
            R_Adjusted(ix_null),...
            options,...
            ix);
        
        PBScores_null(:,:,i) = get_PBScores(n_subjects,...
            n_th,...
            betas,...
            fconn,...
            IX_null);
        display(['Running null ' num2str(i) ' out of ' num2str(N_null)])
    end
    local_folder=pwd;
    save([local_folder filesep 'PBScores_null.mat'],'PBScores_null');
end
%% Do it by networks if available
