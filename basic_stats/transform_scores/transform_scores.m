function [Z, preffix,params]=transform_scores(y,normalization,params)
% Preallocate memory
Z=nan(size(y));

%0. exclude negatives
% ix=y<0;
% y(ix)=nan;

if nargin>2
    if isfield(params,'y_to_validate')
        try
            %00. Remove out of limit
            minlim=min(params.y_to_validate);
            maxlim=max(params.y_to_validate);
            y(y<minlim)=nan;
            y(y>maxlim)=nan;
            
            if sum(isnan(y))>0
                TF=isnan(y);
            else
                TF=zeros(size(y));
            end
            
        end
        TF=TF==1;
    end
else
    TF = isoutlier(y);
end

% 1. identify ol
% TF = isoutlier(y);

% TF=or(TF,y<0);
ix_in=~TF;
ix_out=TF;

% 2, exclude ol
x=y(ix_in);


ix=~isnan(x);


switch normalization
    case 'Z'
        
        if nargin==3
            m=params.m;
            s=params.s;
        else
            
            m=mean(x(ix));
            s=std(x(ix));
        end
        
        z=(x-m)/s;
        params.m=m;
        params.s=s;
        
        preffix='Z_';
        
    case 'boxcox'
        if nargin==3
            [z, params]=boxcox_transform(x,params);
        else
            [z, params]=boxcox_transform(x);
        end
        
        preffix='boxcox_';
end

Z(ix_in)=z;