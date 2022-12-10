function [main_table, within_headers, options, r, c,ix_to_ix_table] = extract_NN_table(fconn,parcel,between_design,within_design,options)

%% Function to run anova analysis on imaging data
% Oscar Miranda-Dominguez, June 10, 2017
% Options that can be defined by the user:
% calculate_Fisher_Z_transform | 1 or 0
% resort_parcel_order: |parcels to be included in the analysis
% boxcox_transform | 1 or 0
% correction_type:
% 1}='tukey-kramer';
% 2}='dunn-sidak';
% 3}='bonferroni';
% 4}='scheffe';
% 5}='lsd';

%%
if nargin < 5
    options=[];
end

%% Resort alphabetically
if isfield(options,'resort_parcel_order')
    temp_ix=options.resort_parcel_order;
else
    temp_ix=1:size(parcel,2);
end
if isempty (temp_ix)
    temp_ix=1:size(parcel,2);
end


[aa bb]=unique(char(parcel(temp_ix).shortname),'rows','sorted');
options.resort_parcel_order=temp_ix(bb');
clear aa bb
%% Read options

[options] = read_options_fconn_anovas(options,parcel);
% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_fconn_anovas(options,n_cases, n_feat);

% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_basic_SVM(options,n_cases, n_feat);
global_stats.options=options;
options

%%
p_th=options.p_th; %P value for figures
%% Options for multiple comparison's correction

%% Resort
ix=options.ix_sorting;
fconn_backup=fconn;
fconn=fconn(ix,ix,:);

sN=size(fconn,3);
n_ROIs=size(ix,1); % Notice this number is read from ix, not from fconn. THis trick is to allow the exclussion of functional networks in options (options.resort_parcel_order), since in options you can specify which networks to include in the analysis
%% Get the crosstalking-names between networks
n_ROIS=size(ix,1);
network=cell(n_ROIS,1);
offset=0;
for i=1:size(options.resort_parcel_order,2)
    j=options.resort_parcel_order(i);
    local_ix=1:parcel(j).n;
    network(local_ix+offset)=cellstr(repmat(parcel(j).shortname,parcel(j).n,1));
    offset=offset+parcel(j).n;
end

[net_mat, net_num, LUT]=get_net_mat(network);
%% reshape the data for n-anova testing

issym=issymmetric(mean(fconn,3)); % determine if the data is symmetric | in connectotyping data is not symmetric

issym=1;
issym=~options.is_connectotyping;
n_feat=n_ROIs*(n_ROIs-1);

if issym
    n_feat=n_feat/2; % remove repeated data
end

x=zeros(sN,n_feat);
ix_to_ix=zeros(n_feat,2);
g_network=cell(1,n_feat);
k=0;
sq=@(M,i,j) squeeze(M(i,j,:));%inline function to squeeze each 3D matrix
r=zeros(n_feat,1);
c=zeros(n_feat,1);
if issym
    for i=1:n_ROIs-1
        for j=i+1:n_ROIs
            k=k+1;
            x(:,k)=sq(fconn,i,j);
            g_network{k}=net_mat{i,j};
            ix_to_ix(k,:)=[ix(i) ix(j)];
            r(k)=i;
            c(k)=j;
        end
    end
else
    for i=1:n_ROIs
        for j=1:n_ROIs
            if i~=j
                k=k+1;
                x(:,k)=sq(fconn,i,j);
                g_network{k}=net_mat{i,j};
                ix_to_ix(k,:)=[ix(i) ix(j)];
                r(k)=i;
                c(k)=j;
            end
        end
    end
end

if options.calculate_Fisher_Z_transform
    x=atanh(x);
    display('Doing Fisher Z-transformation')
end
%% Preparing text to run n-anova
g=read_between_design(between_design,sN);
ng=size(g,1);
G=cell(sN,ng);
for i=1:ng
    G(:,i)=g{i};
end

for i=1:ng
    to_run_G=['G' num2str(i) '=G(:,' num2str(i) ');'];
    to_run_g=['g' num2str(i) '=g{' num2str(i) '};'];
    eval(to_run_G)
    eval(to_run_g)
end

%% Read longitudinal/within design data, if provided
nsg_w=1;% # subgroups within
% OM to me: check what happen with nsg_w when within design proviced
within2=[];
if ~isempty(within_design)
    X=read_within_design(within_design,x);
    x_text=[];
    x_fold='x = [';
    nsg_w=size(X,1);
    for i=1:nsg_w
        to_run_unfold_x=['x' num2str(i) '=X{' num2str(i) '};'];
        x_text=[x_text 'x' num2str(i) '(:), '];% premaking text to be used later in the table
        x_fold=[x_fold 'x' num2str(i) ' '];% reshaping connectivity data for the table
        eval(to_run_unfold_x)
        within2=[within2; table(repmat({within_design(1).subgroups(i).name},n_feat,1))];
        %         within2=[within2; table(repmat(within_design(1).subgroups(i).name,n_feat,1))];
    end
    within2.Properties.VariableNames={within_design(1).name};
    x_fold=[x_fold '];'];
    eval(x_fold);
    n_subjects=size(X{1},1);
end
%% Truncate Gs
% This section relays on the data provided to be balanced

n_subjects=size(x,1);
G_text=[];
for i=1:ng
    to_run=['G' num2str(i) '=G' num2str(i) '(1:n_subjects,:);'];
    G_text=[G_text 'g' num2str(i) ', '];
    eval(to_run)
end

%% prep for rep anovan

part1='t1=table(';
varnames=cell(ng,1);
varnames(1:ng)=cellstr(char(between_design.name));%
to_run=[part1 G_text '''VariableNames'',varnames);'];
eval(to_run)
t1=t1(1:n_subjects,:);% casted this way since when within design provided, 3rd dimention of the matric provides data from the same participant
t2=array2table(x);
t=[t1 t2];
% for i=1:size(X,1)
%     varnames{ng+i}=['T' num2str(i)];
% end

% to_run=[part1 G_text x_text '''VariableNames'',varnames);'];
% display (['Executing ' to_run])
% eval(to_run)

within1=cell2table(repmat(g_network',nsg_w,1));
within1.Properties.VariableNames={'Networks'};
% within1.Networks=categorical(within1.Networks);% forcing stuff to be % categorical


within=[within1 within2];
ngw=size(within,2); % number of groups within

main_table=t;
within_headers=within;

%     Time=table(char(within_design.subgroups.name),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl

% Time=table(categorical(cellstr(char(within_design.subgroups.name))),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl
%%
ix_to_ix_table=array2table(repmat(ix_to_ix,nsg_w,1)');
%% Apply boxcox if asked
if options.boxcox_transform
    
    disp ('Applying boxcox transformation')
    data=encapsulate_data(x,t1,within);
    
    % MSE=combined_MSE_boxcox(lambda,data);
    lambda=1;
    fitfun=@combined_MSE_boxcox;
    options_fminsearch=[];
    lambda=fminsearch(fitfun,lambda,options_fminsearch,data);
    
    [MSE, x_boxcox]=home_made_boxcox(lambda,x-min(x(:))+1);
    x_backup=x;
    x=x_boxcox;
    
    % table needs to be made again
    t2=array2table(x);
    t=[t1 t2];
    main_table=t;
end

