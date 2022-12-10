function [cwas_estimates, PBScores_by_networks] = BWAS (model,...
    demographics_Table,...
    ids,...
    fconn,...
    imaging_type,...
    ind,...
    sz,...
    options,...
    path_parcellation_table)


n=size(fconn,2);
switch imaging_type
    case '2D'
        cifti_ext='.ptseries.nii';
        
    case '3D'
        cifti_ext='.pconn.nii';
end

% LME=cell(n,1);

%% Define folder to save files
fs=filesep;
tables_folder=[pwd fs 'tables'];
ciftis_folder=[pwd fs 'ciftis'];

if ~isfolder(tables_folder)
    mkdir(tables_folder)
end

if ~isfolder(ciftis_folder)
    mkdir(ciftis_folder)
end
%% Scout for pre-allocation
i=1;

% Read brain data
brain_feature=fconn(:,i);

% Make local table to run the test
T=[demographics_Table table(brain_feature)];

% built T using only needed elements
paramNames=extract_paramNames_from_model(model);
local_ix=find_ix_in_header(T,paramNames);
local_ix(isnan(local_ix))=[];
T=T(:,local_ix);

% Run the test
% See :https://www.mathworks.com/help/stats/linearmixedmodel-class.html for
% more details
lme=fitlme(T,model,...
    'FitMethod','REML');

% Pre-allocate memory for R
local_Rsquared=lme.Rsquared;
% recalculating explained variance as r.^2
local_Rsquared.Ordinary=nan;
local_Rsquared.Adjusted=corr(T{:,1},lme.fitted, 'rows','complete').^2;
fields_Rsquared = fieldnames(local_Rsquared);
n_fields_Rsquared=numel(fields_Rsquared);
Rsquared=nan(n,n_fields_Rsquared);


% Pre-allocate memory for coefficients
CoefficientNames=lme.CoefficientNames;
NumEstimatedCoefficients=lme.NumEstimatedCoefficients;

CoefficientStatsNames=lme.Coefficients.Properties.VarNames;
NumCoefficientStatsNames=numel(CoefficientStatsNames);

stats_Tables=cell(NumEstimatedCoefficients,1);
M=nan(NumEstimatedCoefficients,n,NumCoefficientStatsNames-1);

% pre-allocate memory for LME
% temp{1}=lme;
% LME=repmat(temp,n,1);
%% Run for real
for i=1:n
    
    % Read brain data
    brain_feature=fconn(:,i);
    
    % Make local table to run the test
    T=[demographics_Table table(brain_feature)];
    
    % built T using only needed elements
    paramNames=extract_paramNames_from_model(model);
    local_ix=find_ix_in_header(T,paramNames);
    local_ix(isnan(local_ix))=[];
    T=T(:,local_ix);
    
    % Run the test
    lme=fitlme(T,model,...
        'FitMethod','REML');
    
    % Read explained variance
    % https://www.mathworks.com/help/stats/linearmixedmodel-class.html
%     local_Rsquared=lme.Rsquared;
%     for j=1:n_fields_Rsquared
%         eval(['Rsquared(' num2str(i) ',' num2str(j) ') = local_Rsquared.' fields_Rsquared{ j} ';'])
%     end
    
    % recalculating explained variance as r.^2
    Rsquared(i,1)=nan;
    Rsquared(i,2)=corr(T{:,1},lme.fitted, 'rows','complete').^2;

    
    % Read numbers for tables
    local_T=lme.Coefficients;
    M(:,i,:)=double(local_T(:,2:end));
    
    % save lmes
    %     LME{i}=lme;
    ['n = ' num2str(i) '; ptile= ' num2format_text(100*i/n) '%']
end


%% Make Stats tables
for i=1:NumEstimatedCoefficients
    local_T=squeeze(M(i,:,:));
    local_T=[table(repmat(CoefficientNames{i},n,1)) array2table(local_T)];
    local_T.Properties.VariableNames=CoefficientStatsNames;
    local_T=[table([1:n]') local_T];
    local_T.Properties.VariableNames{1}='index';
    stats_Tables{i}=local_T;
    
    filename=[tables_folder fs CoefficientNames{i} '.csv'];
    filename = strrep( filename , '(' , '' );
    filename = strrep( filename , ')' , '' );
    writetable(local_T,filename)
    
    % keep Weight for figure
    if strcmp(CoefficientNames{i},'brain_feature')
        W=local_T.Estimate;
        P=local_T.pValue;
    end
end

%% Format Rsquared table
Rsquared=array2table(Rsquared);
Rsquared.Properties.VariableNames=fields_Rsquared;
Rsquared=[table([1:n]') Rsquared];
Rsquared.Properties.VariableNames{1}='index';
filename=[tables_folder fs 'Rsquared.csv'];
filename = strrep( filename , '(' , '' );
filename = strrep( filename , ')' , '' );
writetable(Rsquared,filename)
V=Rsquared{:,end};
% Keep vaiance for scatter plot
%% Get scores by network
PBScores_by_networks=[];
if ~isempty(path_parcellation_table)
    Y=fconn;
    Y=array2table(Y);
    
    % Load beta weigths
    old='Rsquared.csv';
    new='brain_feature.csv';
    path_betaweights = strrep(filename,old,new);
    betas=readtable(path_betaweights);
    
    [PBScores_by_networks, IX_networks] = PNRS(Y,...
        Rsquared,...
        betas,...
        ids,...
        imaging_type,...
        ind,...
        options,...
        'path_parcellation_table',path_parcellation_table);
    % delete the scores figures
    try
        delete([pwd fs 'figures' fs 'scores' fs '*'])
        rmdir([pwd fs 'figures' fs 'scores'])
    end
end
%% Plot weight and variance
plot_W_V_output_folder=[pwd fs 'figures' fs 'Weights_ExplainedVariance'];
plot_W_V(W,V,plot_W_V_output_folder);
%% Plot pValues and variance
plot_P_V_output_folder=[pwd fs 'figures' fs 'pValues_ExplainedVariance'];
plot_P_V(P,V,plot_P_V_output_folder);
%% Wrap to export
cwas_estimates.Rsquared=Rsquared;
% cwas_estimates.LME=LME;
cwas_estimates.stats_Tables=stats_Tables;
%% Make ciftis
try
    to_ciftify{1}='Estimate';
    to_ciftify{2}='tStat';
    to_ciftify{3}='pValue';
    n_to_ciftify=numel(to_ciftify);
    
    for i=1:NumEstimatedCoefficients
        local_folder=[ciftis_folder fs CoefficientNames{i}];
        local_folder = strrep( local_folder , '(' , '' );
        local_folder = strrep( local_folder , ')' , '' );
        
        
        if ~isfolder(local_folder)
            mkdir(local_folder)
        end
        
        local_T=stats_Tables{i};
        
        for j=1:n_to_ciftify
            
            IX=find_ix_in_header(local_T,to_ciftify{j});
            local_data=local_T{:,IX};
            local_data = table2fconn(local_data(:)',options, imaging_type, ind, sz);
            
            if size(local_data,1)>50000 % I could not figure out a better way to identify dense versus parcellated stuff
                cifti_ext(2)='d';
            end
            
            filename=[CoefficientNames{i} '_' to_ciftify{j} cifti_ext];
            filename = strrep( filename , '(' , '' );
            filename = strrep( filename , ')' , '' );
            mat2cifti(local_data,[local_folder fs filename]);
        end
        
        
        
    end
    
    % Explained variance ciftis
    filename=['rois_sorted_by_explaining_variance' cifti_ext];
    filename = strrep( filename , '(' , '' );
    filename = strrep( filename , ')' , '' );
    [B, ix]=sort(Rsquared{:,end},'descend');
    local_data=nan(n,1);
    local_data(ix)=1:n;
    local_data_copy=local_data;
    local_data = table2fconn(local_data(:)',options, imaging_type, ind, sz);
    mat2cifti(local_data,[ciftis_folder fs filename]);
    
    filename=['normalized_rank_by_explaining_variance' cifti_ext];
    filename = strrep( filename , '(' , '' );
    filename = strrep( filename , ')' , '' );
    local_data=local_data_copy;
    local_data=local_data/n;
    local_data = table2fconn(local_data(:)',options, imaging_type, ind, sz);
    mat2cifti(local_data,[ciftis_folder fs filename]);
    
    filename=['explained_variance' cifti_ext];
    filename = strrep( filename , '(' , '' );
    filename = strrep( filename , ')' , '' );
    local_data=Rsquared{:,end};
    local_data = table2fconn(local_data(:)',options, imaging_type, ind, sz);
    mat2cifti(local_data,[ciftis_folder fs filename]);
    
end

%% Adding prcile ciftis

output_folder=[ciftis_folder fs 'brain_feature' ];
% path_betaweights_cifti=strtrim(ls([output_folder fs 'brain_feature_Estimate.*.nii']));
depth=0;
path_betaweights_cifti=get_path_to_file(output_folder,depth,'brain_feature_Estimate.*.nii');
path_betaweights_cifti=path_betaweights_cifti{1};


% local_path_explained_variance_cifti=strtrim(ls([ciftis_folder fs 'explained_variance.*.nii']));
local_path_explained_variance_cifti=get_path_to_file(ciftis_folder,depth,'explained_variance.*.nii');
local_path_explained_variance_cifti=local_path_explained_variance_cifti{1};

output_folder=[ciftis_folder fs 'brain_feature' ];
% local_path_pvalue_cifti=strtrim(ls([output_folder fs 'brain_feature_pValue.*.nii']));
local_path_pvalue_cifti=get_path_to_file(output_folder,depth,'brain_feature_pValue.*.nii');
local_path_pvalue_cifti=local_path_pvalue_cifti{1};

ciftify_sum_betaweights(path_betaweights_cifti,...
    local_path_explained_variance_cifti,...
    local_path_pvalue_cifti,...
    options,...
    output_folder)

%% Run barh_networks_distribution
if ~isempty(path_parcellation_table)
    
    local_output_folder=pwd;
    barh_networks_distribution(local_path_explained_variance_cifti,...
        path_parcellation_table,...
        'output_folder',local_output_folder,...
        'path_pvalue_cifti',local_path_pvalue_cifti,...
        'options',options)
end