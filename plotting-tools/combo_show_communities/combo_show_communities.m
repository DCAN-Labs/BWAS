function combo_show_communities (T_brain_scores,...
    T_behavioral_scores,...
    idx,...
    glabs,...
    varargin)


%% Define defaults

fs = filesep;

% Assume no Group_Color_Table is provided
Group_Color_Table_flag=0;

% Define outpur folder
output_folder=pwd;

% fig size wide
fig_wide=6;

% fig size tall
fig_tall=6;

% Default resolution for figure saving
res=300;

% save_flag
save_flag=1;

% do not use external colormap
external_cmap=[];

% default idx_truncated
idx_truncated=idx;

% outcome_brain_scores
outcome_brain_scores=T_brain_scores.Properties.VariableNames;

% glabs_to_show
glabs_to_show=unique(glabs)';

% glab_reference
glab_reference=unique(glabs)';
glab_reference=glab_reference{1};

% normalization_method
normalization_method='boxcox';

% behav_to_show
behav_to_show=glabs_to_show;

% path_save_normalized_scores
save_normalized_scores=1;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'save_normalized_scores'
            save_normalized_scores=varargin{q+1};
            q = q+1;
        
        case 'path_Group_Color_Table'
            path_Group_Color_Table=varargin{q+1};
            Group_Color_Table_flag=1;
            q = q+1;
            
        case 'idx_truncated'
            idx_truncated=varargin{q+1};
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'fig_wide'
            fig_wide=varargin{q+1};
            q = q+1;
            
        case 'fig_tall'
            fig_tall=varargin{q+1};
            q = q+1;
            
        case 'res'
            res=varargin{q+1};
            q = q+1;
            
        case 'save_flag'
            fig_tall=varargin{q+1};
            q = q+1;
            
        case 'glabs_to_show'
            glabs_to_show=varargin{q+1};
            q = q+1;
            
        case 'up_to_n_members'
            up_to_n_members=varargin{q+1};
            q = q+1;
            
        case 'external_cmap'
            external_cmap=varargin{q+1};
            q = q+1;
            
        case 'outcome_brain_scores'
            outcome_brain_scores=varargin{q+1};
            q = q+1;
            
        case 'glab_reference'
            glab_reference=varargin{q+1};
            q = q+1;
            
        case 'normalization_method'
            normalization_method=varargin{q+1};
            q = q+1;
            
            
        case 'behav_to_show'
            behav_to_show=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
Group_Color_Table_flag=Group_Color_Table_flag==1;
save_normalized_scores=save_normalized_scores==1;
%% make sure uoutput folder exists

if ~isfolder (output_folder)
    mkdir(output_folder)
end

%% Unwrap brain scores
X=table2array(T_brain_scores);
%% Show of Communities as histogram

hist_communities(idx,...
    'output_folder',output_folder,...
    'res',res);


hist_communities(idx,...
    'labels',glabs,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'output_folder',output_folder,...
    'res',res);
if prod(idx==idx_truncated)==0
    
    hist_communities(idx_truncated,...
        'output_folder',output_folder,...
        'res',res);
    
    hist_communities(idx_truncated,...
        'labels',glabs,...
        'path_Group_Color_Table',path_Group_Color_Table,...
        'output_folder',output_folder,...
        'res',res);
    
end
%% Show Distance matrix

showM_communities(X,...
    'community_index',idx_truncated,...
    'labels',glabs,...
    'output_folder',output_folder,...
    'external_cmap',external_cmap,...
    'res',res);

%% Show distributions brain and behavioral scores

preffix_name='brain_scores_';
flag_combined_small_communities=~prod(idx==idx_truncated);
Tnorm_brain_scores=show_clusters_with_outcome([T_behavioral_scores T_brain_scores],...
    idx_truncated,...
    'output_folder',output_folder,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'outcome',outcome_brain_scores,...
    'preffix_name',preffix_name,...
    'glabs',glabs,...
    'glabs_to_show',glabs_to_show,...
    'glab_reference',glab_reference,...
    'normalization_method',normalization_method,...
    'flag_combined_small_communities',flag_combined_small_communities,...
    'behav_to_show',behav_to_show);
if save_normalized_scores==1
    T=Tnorm_brain_scores;
    filename=[output_folder fs 'normalized_' normalization_method '_' preffix_name '.csv'];
     filename = strrep( filename , '_.csv' , '.csv' );
     filename = strrep( filename , '//' , '/' );
    writetable(T,filename)
end

%% Show distributions brain and behavioral scores

preffix_name='behav_scores_';
Tnorm_behav_scores=show_clusters_with_outcome([T_behavioral_scores T_brain_scores],idx_truncated,...
    'output_folder',output_folder,...
    'path_Group_Color_Table',path_Group_Color_Table,...
    'outcome',behav_to_show,...
    'preffix_name',preffix_name,...
    'glabs',glabs,...
    'glabs_to_show',glabs_to_show,...
    'glab_reference',glab_reference,...
    'normalization_method',normalization_method,...
    'flag_combined_small_communities',flag_combined_small_communities,...
    'behav_to_show',behav_to_show);

if save_normalized_scores==1
    T=Tnorm_behav_scores;
    filename=[output_folder fs 'normalized_' normalization_method '_' preffix_name '.csv'];
     filename = strrep( filename , '_.csv' , '.csv' );
     filename = strrep( filename , '//' , '/' );
    writetable(T,filename)
end
%% Exit if stand alone executable
if isdeployed
    exit
end