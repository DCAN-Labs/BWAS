function M = showM_communities(scores,...
    varargin)

%% function M = showM_communities(scores)
% scores is a table that contains a column per score. Additionally you can
% provide a column to assign community and a label for diagnosis
%% Define defaults

[r,c]=size(scores);

community_index=ones(r,1);

labels=[];
n_labels=0;
external_cmap=[];

% Define outpur folder
output_folder=pwd;

% save_flag
save_flag=1;

% Default resolution for figure saving
res=300;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        
        case 'community_index'
            community_index=varargin{q+1};
            q = q+1;
            
        case 'labels'
            labels=varargin{q+1};
            q = q+1;
            
        case 'external_cmap'
            external_cmap=varargin{q+1};
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'res'
            res=varargin{q+1};
            q = q+1;
            
        case 'save_flag'
            save_flag=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end


%% Sort data per community

ix=1:numel(community_index);
ix=[ix' community_index];
ix=sortrows(ix,2);
idx=ix(:,2);
ix=ix(:,1);

scores_sorted=scores(ix,:);
%% identify labels, if provided
if ~isempty (labels)
    % resort labels
    labels=labels(ix,:);
    [u,n_labels,ix_label,nix]=find_uniques(labels);
end
%% DO the thing
local_label='All';
local_idx=idx;
R=corr(scores_sorted');
do_showM_communities(R,...
    local_label,...
    local_idx,...
    external_cmap,...
    output_folder,...
    res,...
    save_flag);

for i=1:n_labels
    local_ix=ix_label{i};
    local_R=corr(scores_sorted(local_ix,:)');
    local_label=u(i);
    local_idx=idx(local_ix);
    do_showM_communities(local_R,...
        local_label,...
        local_idx,...
        external_cmap,...
        output_folder,...
        res,...
        save_flag);
    
end
