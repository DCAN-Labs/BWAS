function [T, raw_data]=describe_M (M,varargin)

%% Oscar Miranda-Dominguez
% First line of code: March 2nd, 2020
%% describe_M (M,varargin)
%
% This function display and show central tendency values from connectivity
% matrices
% Calculated values:
% - min
% - max
% - mean
% - median
% - std deviation
% - percentile 25
% - percentile 75

%% Define defaults

% which half to show
half='up';

% ignore diagonal
ignore_diagonal=1;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'half'
            half=varargin{q+1};
            q = q+1;
            
            
        case 'ignore_diagonal'
            ignore_diagonal=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
ignore_diagonal=ignore_diagonal==1;
%% get the size

[n_rois,n_rois,n]=size(M);


%% Calculate the mask

mask = ones(n_rois,n_rois);

switch half
    case 'up'
        mask=triu(M(:,:,1));
        
    case 'low'
        mask=tril(M(:,:,1));
end

if ignore_diagonal
    mask=mask.*(~eye(n_rois));
end

mask=mask~=0;
n_surv=sum(mask(:));

%% Read the masked values
unique_fconn=zeros(n_surv,n);
for i=1:n
    tempM=squeeze(M(:,:,i));
    unique_fconn(:,i)=tempM(mask);
end

%% Concatenate values and do Fisher
R=unique_fconn(:);
Z=atanh(R);

[sumR, row_names]=summarize_data(R);
sumZ=summarize_data(Z);
sumR_via_Fisher=tanh(sumZ);

formatted_sumR=num2str(sumR,'%4.2f');
formatted_sumR_via_Fisher=num2str(sumR_via_Fisher,'%4.2f');

VariableNames=cell(4,1);
VariableNames{1}='from_raw_data';
VariableNames{2}='via_Fisher_Z_transform';
VariableNames{3}='formatted_from_raw_data';
VariableNames{4}='formatted_via_Fisher_Z_transform';

T=table(sumR,sumR_via_Fisher,formatted_sumR,formatted_sumR_via_Fisher);
T.Properties.VariableNames=VariableNames;
T.Properties.RowNames=row_names;
custom_hist(R);

if nargout>1
    raw_data=R;
end