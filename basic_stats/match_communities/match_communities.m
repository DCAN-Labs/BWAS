function [M,...
    matched_communities,...
    new_ix1,...
    new_ix2]=match_communities(path_scores,...
    path_communities,...
    cost_function)

%% Oscar Miranda-Dominguez
% First line of code: march 11, 2022


%% Define criteria

if nargin<3
    cost_function='median_diff';
end
%% Read the data
n_samples=numel(path_scores);
X=cell(n_samples,1);
IX=cell(n_samples,1);

for i=1:n_samples
    X{i}=load_imaging_data(path_scores{i});
    IX{i}=load_imaging_data(path_communities{i});
    
end

%% calculate distance




[u1,nu1,ix1,nix1]=find_uniques(IX{1});
[u2,nu2,ix2,nix2]=find_uniques(IX{2});

M=nan(nu1,nu2);
% cost_function='kolmogorov_combined';
% cost_function='kolmogorov_per_score';
for i=1:nu1
    sample1=X{1}(ix1{i},:);
    for j=1:nu2
        
        sample2=X{2}(ix2{j},:);
        M(i,j)=compare_dist_of_communities(sample1,...
            sample2,...
            cost_function);
    end
end

%% Find closest matches
n_matches=min([nu1 nu2]);
matched_communities=zeros(n_matches,2);
truncated_distance=M;
for i=1:n_matches
    [indices, truncated_distance]=get_min_index(truncated_distance);
    local_min_ix=cell2mat(indices)';

    matched_communities(i,:)=local_min_ix;
end

%% Find closest matches in order
n_matches=min([nu1 nu2]);
matched_communities=zeros(n_matches,2);
truncated_distance=M;
mask_template=nan(size(M));
for i=1:n_matches
    
    local_mask=mask_template;
    local_mask(i,:)=1;
    
    to_filter=local_mask.*truncated_distance;
    [indices, A]=get_min_index(to_filter);
    local_min_ix=cell2mat(indices)';
    truncated_distance(local_min_ix(1),:)=nan;
    truncated_distance(:,local_min_ix(2))=nan;
    
    
    matched_communities(i,:)=local_min_ix;
end
%%
new_ix1=nan;
new_ix2=nan;