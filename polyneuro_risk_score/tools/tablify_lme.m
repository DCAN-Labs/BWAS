function tablify_lme(LME)

%% Count models
n=size(LME,1);

%% Extract one model to define parameters for pre-allocation

lme=LME{1};
%% Pre-allocate memory for tables

% Pre-allocate memory for R
local_Rsquared=lme.Rsquared;
fields_Rsquared = fieldnames(local_Rsquared);
n_fields_Rsquared=numel(fields_Rsquared);
Rsquared=nan(n,n_fields_Rsquared);


% Pre-allocate memory for coefficients
CoefficientNames=lme.CoefficientNames;
NumEstimatedCoefficients=lme.NumEstimatedCoefficients;

CoefficientStatsNames=lme.Coefficients.Properties.VarNames;
NumCoefficientStatsNames=numel(CoefficientStatsNames);

T=cell(NumCoefficients,1);
M=nan(NumEstimatedCoefficients,n,NumCoefficientStatsNames-1);
%% Populate tables

for i=1:n
    % read local model
    lme=LME{i};
    
    % Read explained variance
    local_Rsquared=lme.Rsquared;
    for j=1:n_fields_Rsquared
        eval(['Rsquared(' num2str(i) ',' num2str(j) ') = local_Rsquared.' fields_Rsquared{ j} ';'])
    end
    
    % Read numbers for tables
    local_T=lme.Coefficients;
    M(:,i,:)=double(local_T(:,2:end));
end

%% SAve data