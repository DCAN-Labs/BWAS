function explore_fits(y)


%%
n=5000;
x=linspace(.01,50,n);
y=log(x)+rand(1,n);
y=y(randperm(n));
hist(y)

y=randn(n,1);
X = linspace(0,1,n);
y1 = betapdf(X,0.75,0.75);
y=y1(randperm(n));
%%
dist_name={'Beta'
    'Binomial'
    'BirnbaumSaunders'
    'Burr'
    'Exponential'
    'ExtremeValue'
    'Gamma'
    'GeneralizedExtremeValue'
    'GeneralizedPareto'
    'HalfNormal'
    'InverseGaussian'
    'Kernel'
    'Logistic'
    'Loglogistic'
    'Lognormal'
    'Nakagami'
    'NegativeBinomial'
    'Normal'
    'Poisson'
    'Rayleigh'
    'Rician'
    'Stable'
    'tLocationScale'
    'Weibull'};

dist_name{end+1}='BoxCox';
n_dist=numel(dist_name);
% n_dist=numel(dist_name)*2-1;

%% Make title 1
tit1=cell(2*n_dist-1,1);
tit1(1:n_dist)=dist_name;
for i=1:n_dist-1
    j=n_dist+i;
    tit1{j}=[dist_name{i} ' + BoxCox'];
end

%% Keep track of size and force it to be a column vector
[r,c]=size(y);
Y=y(:);
%% Select points with data
ix_in=~isnan(Y);
ix_in=and(ix_in,~isinf(Y));
x_raw=Y(ix_in);
n=numel(ix_in);

%% scale x_raw
% x_raw = map_dots(x_raw,rand(n,1));

% x_raw=x_raw-min(x_raw);
% x_raw=x_raw/max(x_raw);
% x_raw=zscore(x_raw);
%% Get linearly spaced dots to simulate data
x_linspace = get_x_in_to_simulate_dist(x_raw);

%% Preallocate memory
Z=repmat(Y,1,n_dist);
p_kolmogorov=nan(n_dist,1);

ref=randn(r*c,1);
for i=1:n_dist-1
    try
        % Fit data
        pd = fitdist(x_raw,dist_name{i});
        
        % Apply transformation
%         x_out_1=pdf(pd,x_linspace);
        x_out_1=pdf(pd,x_raw);
        
        % Force transformed data to be a column vector
        x_out_1=x_out_1(:);
        
        
        % Scale data
        x_scaled = scaled_dist(x_out_1,x_raw);
        
        % Find corresponding dots
        x_map = map_dots(x_raw,x_scaled);
        
        % Obtain the residuals
        x_res=x_raw-x_map;
%         x_res=x_raw-x_scaled;
        
        % Resort
        x_res = map_dots(x_raw,x_res);
        x_res=x_map;
        
        % Save output data
        Z(ix_in,i)=x_res;
        
        % Estimate goodness of the fit
        [h p_kolmogorov(i)]=kstest(x_res);
        
        % Get a boxcox transform
        x_out_3=boxcox_transform(x_res);
        
        % Estimate goodness of the fit
        [h p_kolmogorov(i+n_dist)]=kstest(x_out_3);
        
        % Save output data
        Z(ix_in,i+n_dist)=x_out_3;
        
    end
end
%% Do boxcox
i=n_dist;
try
    Z(ix_in,i)=boxcox_transform(x_raw);
    [h p_kolmogorov(i)]=kstest(Z(ix_in,i));
end
%% Sort 
[foo, ix]=sort(p_kolmogorov,'descend');
%%

up_to=0.05;
up_to=realmin;

ix_up_to=ix(foo>up_to);
n_ix_up_to=numel(ix_up_to);

N=ceil(sqrt(n_ix_up_to));
for i=1:n_ix_up_to
    j=ix_up_to(i);
    subplot(N,N,i)
    histogram(x_raw)
    hold all
    histogram(Z(ix_in,j))
%     histogram(ref)
    hold off
    tit=cell(2,1);
    tit{1}=tit1{j};
    
    tit{2}=['p = ' num2str(p_kolmogorov(j))];
    title(tit)
    legend('Original','Transformed')
    
%     options.n_bins=round(r*c/10);
%     options=[];
%     custom_hist([x_in Z(ix_in,j) ],options)
    
%          scatter(x_raw,Z(ix_in,j))
end

