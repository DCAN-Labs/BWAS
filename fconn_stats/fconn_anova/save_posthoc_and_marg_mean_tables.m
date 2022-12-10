function save_posthoc_and_marg_mean_tables(rm,options,path_to_save)
%% Save posthoc tables and marginal means

%% Oscar Miranda-Dominguez
% First line of code: July 17, 2020
%%

%%
if nargin<3
    path_to_save=pwd;
end

%% Verify dir exist

if ~isfolder(path_to_save)
    mkdir(path_to_save)
end
%%

fs=filesep;

%% Read factor names
bet_factors=rm.BetweenFactorNames;
wit_factors=rm.WithinFactorNames;
%% Exclude connection to avoid memory a lot of memory

if strcmp(wit_factors(end),'conn')
    wit_factors(end)=[];
end

%% Unifactor
all_factors=cat(2,bet_factors,wit_factors);

% to only exclude this interaction in longitudinal studies
if numel(wit_factors)>1
    ix=ismember(all_factors,[wit_factors{1} '_' wit_factors{2}]);
    all_factors(ix)=[];
end
n_all_factors=numel(all_factors);

for i=1:n_all_factors
    try
        filename=['posthoc_1_factor_for_' all_factors{i} '_corrected_by_' options.correction_type];
        t_posthoc=multcompare(rm,all_factors{i},...
            'ComparisonType',options.correction_type);
        IX=find_ix_in_header(t_posthoc,'pValue');
        t_posthoc=sortrows(t_posthoc,IX);
        writetable(t_posthoc,[path_to_save fs filename '.csv'])
    end
end
%% Two factors

all_factors=cat(2,bet_factors,wit_factors(2:end));% To exclude networks

if numel(wit_factors)>1
    ix=ismember(all_factors,[wit_factors{1} '_' wit_factors{2}]);
    ix2=ismember(all_factors,'conn');
    ix=or(ix,ix2);
    all_factors(ix)=[];
end
n_all_factors=numel(all_factors);


for i=1:n_all_factors
    filename=['posthoc_2_factors_for_' all_factors{i} '_BY_' wit_factors{1} '_corrected_by_' options.correction_type];
    t_posthoc=multcompare(rm,all_factors{i},'By',wit_factors{1},...
        'ComparisonType',options.correction_type);
    IX=find_ix_in_header(t_posthoc,'pValue');
    t_posthoc=sortrows(t_posthoc,IX);
    writetable(t_posthoc,[path_to_save fs filename '.csv'])
end

%% Three factors
if numel(wit_factors)>1
    by_factor=[wit_factors{1} '_' wit_factors{2}];
    
    ix_to_kill=zeros(n_all_factors,1);
    for i=1:n_all_factors
        ix_to_kill(i)=contains(by_factor,all_factors{i});
    end
    ix_to_kill=ix_to_kill==1;
    all_factors(ix_to_kill)=[];
    n_all_factors=numel(all_factors);
    
    
    for i=1:n_all_factors
        filename=['posthoc_3_factors_for_' all_factors{i} '_BY_' by_factor '_corrected_by_' options.correction_type];
        filename = strrep( filename , by_factor , [wit_factors{1} '_BY_' wit_factors{2}] );
        t_posthoc=multcompare(rm,all_factors{i},'By',by_factor,...
            'ComparisonType',options.correction_type);
        IX=find_ix_in_header(t_posthoc,'pValue');
        t_posthoc=sortrows(t_posthoc,IX);
        T = split_mixed_within_names(t_posthoc,wit_factors);
        writetable(T,[path_to_save fs filename '.csv']);
    end
end
%% Save marginal means
all_factors=cat(2,bet_factors,wit_factors);

% to only exclude this interaction in longitudinal studies
if numel(wit_factors)>1
    ix=ismember(all_factors,[wit_factors{1} '_' wit_factors{2}]);
    all_factors(ix)=[];
end
n_all_factors=numel(all_factors);


for i=1:n_all_factors
    C = nchoosek(all_factors,i);
    n_comb=size(C,1);
    for j=1:n_comb
        filename=strjoin(C(j,:));
        filename = strrep( filename , ' ' , '_by_' );
        if i==1
            filename=['marginal_means_' num2str(i) '_factor_by_' filename];
        else
            filename=['marginal_means_' num2str(i) '_factors_by_' filename];
        end
        m=margmean(rm,C(j,:));
        writetable(m,[path_to_save fs filename '.csv'])
    end
    
end
%% Combining post hocs with marginal means

for i=1:n_all_factors
    
    
    included_factors=nchoosek(all_factors,i);
    n_cases=size(included_factors,1);
    clc
    for j=1:n_cases
        local_included_factors=included_factors(j,:);
        try
            [path_posthocs, path_marginal_means] = find_files_to_paired(path_to_save,local_included_factors);
            T = merge_marginal_means_and_posthocs(path_marginal_means,path_posthocs);
            
            [ filepath , name , ext ] = fileparts( path_posthocs ) ;
            old=['posthoc_'];
            new='posthoc_with_marginal_means_';
            filename= strrep( name , old , new );
            full_path_filename=[filepath filesep filename ext];
            writetable(T,full_path_filename);
        end
    end
end

