function ciftify_sum_betaweights(path_betaweights_cifti,...
    path_explained_variance_cifti,...
    path_pvalue_cifti,...
    options,...
    output_folder,...
    varargin)
%% Preamble

% path_betaweights_cifti='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ABCD/case2_yes_covariates_g1/ciftis/brain_feature/brain_feature_Estimate.pconn.nii';
% path_explained_variance_cifti='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ABCD/case2_yes_covariates_g1/ciftis/explained_variance.pconn.nii';
% path_pvalue_cifti='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ABCD/case2_yes_covariates_g1/ciftis/brain_feature/brain_feature_pValue.pconn.nii';
% path_options=[];
% output_folder='/panfs/roc/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/make_BWAS/Gordon/FD_0_20_time_08_mins_all/BWAS_ABCD/case2_yes_covariates_g1/ciftis/brain_feature';
% ciftify_sum_betaweights(path_betaweights_cifti,...
%     path_explained_variance_cifti,...
%     path_pvalue_cifti,...
%     options,...
%     output_folder)
%%

%%
parcel_set_provided_flag=0;
%% Read extra options, if provided
path_parcellation_table=[];
v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        
        case 'path_parcellation_table'
            path_parcellation_table=varargin{q+1};
            parcel_set_provided_flag=1;
            q = q+1;
            
        case 'path_roi_table'
            path_roi_table=varargin{q+1};
            q = q+1;
            
        case 'path_correlations_by_networks'
            path_correlations_by_networks=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

%%
fs=filesep;
%% Load beta weights

betas=cifti2mat(path_betaweights_cifti);
%% load explained variance

V=cifti2mat(path_explained_variance_cifti);
%% Read p-values

p=cifti2mat(path_pvalue_cifti);

%% Pre-allocate variables

if parcel_set_provided_flag==1
    T_networks=readtable(path_correlations_by_networks);
    nu=size(T_networks,1);
    n_th=nu;
else
    n_th=numel(options.percentile)+1;
end

n_rois=size(betas);
IX_p=zeros(n_rois(1),n_rois(2),n_th);
IX_V=zeros(n_rois(1),n_rois(2),n_th);
%%
if parcel_set_provided_flag==1
    T_rois=readtable(path_roi_table);
    [network_names, IX_networks, IX_cummulative, IX_cummulative_reversed]=encode_rois_as_IX(T_networks,T_rois,IX_p);
    
    
else
    %% Identify IX from explained variance
    
    f1=max(V,[],'all');
    local_ix=V==f1;
    IX_V(:,:,1)=local_ix;
    ptiles=prctile(V(:),100-options.percentile);
    for i=2:n_th
        local_ix=V>=ptiles(i-1);
        IX_V(:,:,i)=local_ix;
    end
    IX_V=IX_V==1;
    %% Filter beta-weights by th
    
    f1=min(p,[],'all');
    local_ix=p==f1;
    IX_p(:,:,1)=local_ix;
    ptiles=prctile(p(:),options.percentile);
    for i=2:n_th
        local_ix=p<=ptiles(i-1);
        IX_p(:,:,i)=local_ix;
    end
    IX_p=IX_p==1;
end
%% Uncomment for validation
% i=0;
% i=i+1;[sum(sum(IX_V(:,:,i))) sum(sum(IX_p(:,:,i))) ]
% i=i+1;sum(sum(squeeze(IX_V(:,:,i))==squeeze(IX_p(:,:,i))))
%%
if parcel_set_provided_flag==1
    sum_betas_networks=zeros(n_rois(1),n_th);
    sum_betas_cummulative=zeros(n_rois(1),n_th);
    sum_betas_cummulative_reversed=zeros(n_rois(1),n_th);
    
    for i=1:n_th
        p1=betas.*IX_networks(:,:,i);
        p2=betas.*IX_cummulative(:,:,i);
        p3=betas.*IX_cummulative_reversed(:,:,i);
        
        if size(IX_networks,2)==1
            sum_betas_networks(:,i)=p1;
            sum_betas_cummulative(:,i)=p2;
            sum_betas_cummulative_reversed(:,i)=p3;
        else
            sum_betas_networks(:,i)=nansum(abs(p1));
            sum_betas_cummulative(:,i)=nansum(abs(p2));
            sum_betas_cummulative_reversed(:,i)=nansum(abs(p3));
        end
        
    end
    sum_betas=cell(3,1);
    sum_betas{1}=sum_betas_networks;
    sum_betas{2}=sum_betas_cummulative;
    sum_betas{3}=sum_betas_cummulative_reversed;
else
    %% Sum beta-weights
    sum_betas_V=zeros(n_rois(1),n_th);
    for i=1:n_th
        sum_betas_V(:,i)=nansum(abs(betas.*IX_V(:,:,i)));
    end
    
    %% Sum beta-weights
    sum_betas_p=zeros(n_rois(1),n_th);
    for i=1:n_th
        sum_betas_p(:,i)=nansum(abs(betas.*IX_p(:,:,i)),2);
    end
end
%% Save cifti

%% define extension

[filepath,name,ext] = fileparts(path_betaweights_cifti);

if_then={'.pconn.nii','.ptseries.nii';...
    '.ptseries.nii','.ptseries.nii';...
    '.dconn.nii','.dtseries.nii';...
    '.dtseries.nii','.dtseries.nii'};
for i=1:size(if_then,1)
    if contains(path_betaweights_cifti,if_then{i,1})
        ext=if_then{i,2};
    end
end
%%

if parcel_set_provided_flag==1
    clear local_output_folder
    local_output_folder{1}=[output_folder fs 'by_networks'];
    local_output_folder{2}=[output_folder fs 'by_networks_cummulative'];
    local_output_folder{3}=[output_folder fs 'by_networks_cummulative_reversed'];
    
    for j=1:numel(local_output_folder)
        if ~isdir(local_output_folder{j})
            mkdir(local_output_folder{j})
        end
        sum_betas_V=sum_betas{j};
        for i=1:n_th
            if j==numel(local_output_folder)
                filename1=[local_output_folder{j} fs num2str(i) '_' 'sum_betas_' network_names{end+1-i} ext];
            else
                filename1=[local_output_folder{j} fs num2str(i) '_' 'sum_betas_' network_names{i} ext];
            end
            filename1 = strrep( filename1 , ' ' , '_' );
            mat2cifti(sum_betas_V(:,i),filename1);
        end
        
    end
    
else
    %% Suffix
    suffix=th_names_to_suffix(options);
    %%
    
    %%
    method_1='explained_variance';
    method_2='p_value';
    local_output_folder=[output_folder fs 'sum_betas_by_th'];
    if ~isdir(local_output_folder)
        mkdir(local_output_folder)
    end
    
    for i=1:n_th
        filename1=[local_output_folder fs 'sum_betas_' method_1 '_' suffix{i} ext];
        mat2cifti(sum_betas_V(:,i),filename1);
        
        filename2=[local_output_folder fs 'sum_betas_' method_2 '_' suffix{i} ext];
        mat2cifti(sum_betas_p(:,i),filename2);
    end
end