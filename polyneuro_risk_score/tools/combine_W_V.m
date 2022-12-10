function combine_W_V(path_betaweights,...
    path_Rsquared,...
    varargin)

%% Oscar Miranda-Dominguez
% First line of code: Aug 12, 2021

%%
%% Define defaults

fs = filesep;



% Define outpur folder
output_folder=pwd;

%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch (varargin{q})
        
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end


%% Count inputs
n=numel(path_betaweights);


%% Read templates
i=1;
template_betas=readtable(path_betaweights{i});
template_R=readtable(path_Rsquared{i});

%% Pre-allocate memory

r=size(template_betas,1);
betas=nan(r,n);
R=nan(r,n);
V=nan(r,n);

betas(:,i)=template_betas.Estimate;
V(:,i)=r*(template_betas.SE).^2;
R(:,i)=template_R.Adjusted;
%% Read additional values
for i=2:n
    template_betas=readtable(path_betaweights{i});
    template_R=readtable(path_Rsquared{i});
    
    betas(:,i)=template_betas.Estimate;
    V(:,i)=r*(template_betas.SE).^2;
    R(:,i)=template_R.Adjusted;
end
%% Do the math

Wpos=(betas(:,1).*V(:,2)+betas(:,2).*V(:,1))./sum(V,2);
Vpos=prod(V,2)./sum(V,2);
SEpos=sqrt(Vpos)/sqrt(r);
Rpos=mean(R,2);
% Rpos=(R(:,1).*V(:,2)+R(:,2).*V(:,1))./sum(V,2);
% Rpos=harmmean(R,2);
% Rpos=geomean(R,2);
%% Remake the tables

template_betas.Estimate=Wpos;
template_betas.SE=SEpos;
template_betas{:,5}=nan;
template_betas{:,7:end}=nan;

template_R.Ordinary=Rpos;
template_R.Adjusted=Rpos;

%% Save the tables

writetable(template_R,[output_folder fs 'Rsquared.csv'])
writetable(template_betas,[output_folder fs 'brain_feature.csv'])