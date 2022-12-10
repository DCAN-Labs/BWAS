function meanM=get_mean_M(M,environment)

%% Oscar Miranda-Dominguez
% Function to calculate mean connectivity matrices after doing FIsher Z
% transform for correlations. If using connectotyping, it simply calculates
% the mean on the third dimension

if nargin<2
    environment='standard';
end

switch environment
    case 'standard'
        
        FM=atanh(M);
        mean_FM=nanmean(FM,3);
        meanM=tanh(mean_FM);
    case 'connectotyping'
        meanM=nanmean(M,3);  
end

