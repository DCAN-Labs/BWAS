function [indices, truncated_distance]=get_min_index(distance)
%% [indices, truncated_distance]=get_min_index(distance)
%
%
% This function takes as input a multidimensional array and returns the
% indices from the min as a cell. It also returns a matrix without those
% elements
%
% Oscar Miranda-Dominguez, Fen 9, 2019

% preallocate memory for the truncated matrix
truncated_distance=distance;
n_subjects=size(distance);
n_dimensions=numel(n_subjects);

% To be used for elements to be removed
for_text_indexing=repmat({':'},1,n_dimensions);

% preallocate memory to save the indices for the min
indices=cell(n_dimensions,1);

% find the min
[B, IND]=min(distance(:));

siz=n_subjects;

% this for loop is to write text to use the function [I1 I2, ... ] = ind2sub(siz,IND)
text_I='[';
for i=1:n_dimensions
    text_I=[text_I 'I' num2str(i) ' '];
end
text_I=[text_I ']'];
to_run=[text_I ' = ind2sub(siz,IND);'];
eval(to_run)

% This for-loop is to remove the matched/min elements
for i=1:n_dimensions
    to_run2=['indices{' num2str(i) '} = I' num2str(i) ';'];
    eval(to_run2)
    local_text_indexing=for_text_indexing;
    local_text_indexing{i}=indices{i};
    local_index=for_local_indexing(local_text_indexing);
    
%     to_run3=['truncated_distance(' local_index ')=[];'];
    to_run3=['truncated_distance(' local_index ')=nan;'];
    eval(to_run3);
end

function local_index=for_local_indexing(local_text_indexing)
n=numel(local_text_indexing);
local_index=[];
for j=1:n
    if isnumeric(local_text_indexing{j})
        local_index=[local_index num2str(local_text_indexing{j}) ','];
    else
        local_index=[local_index local_text_indexing{j} ','];
    end
end
local_index(end)=[];