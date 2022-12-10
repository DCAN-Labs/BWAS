function [ix,T] = catch_nans (M, varargin)

%% Use this function to identify entries with nans or inf in a fconn matrix
%% Define defaults

% which half to show
half='both';

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

[~,n_rois,n]=size(M);


%% Calculate the mask

mask = ones(n_rois,n_rois);

switch half
    case 'up'
        mask=triu(mask);
        
    case 'low'
        mask=tril(mask);
end

if ignore_diagonal
    I=eye(n_rois)==1;
    mask(I)=0;
end

mask=mask~=0;
n_surv=sum(mask(:));

%% Read the masked values
unique_fconn=zeros(n_surv,n);
for i=1:n
    tempM=squeeze(M(:,:,i));
    unique_fconn(:,i)=tempM(mask);
end

%%

NAN=isnan(unique_fconn);
INF=isinf(unique_fconn);

sumNAN=squeeze(sum(NAN));
sumINF=squeeze(sum(INF));

ix=or(sumNAN>0,sumINF>0);
ix=find(ix);

T=table(ix,sumNAN(ix),sumINF(ix));
T.Properties.VariableNames{2}='nans';
T.Properties.VariableNames{3}='inf';

%% display
display(['Check index ' num2str(ix)])
display(T)
%%
