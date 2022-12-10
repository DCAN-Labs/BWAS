function [main_table, global_stats] = fconn_rm_anovan(fconn,parcel,between_design,within_design,options,WM)

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

if issym
    for i=1:n_ROIs-1
        for j=i+1:n_ROIs
            k=k+1;
            x(:,k)=sq(fconn,i,j);
            g_network{k}=net_mat{i,j};
            ix_to_ix(k,:)=[ix(i) ix(j)];
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
            end
        end
    end
end

if options.calculate_Fisher_Z_transform
    x=atanh(x); % Fisher Z transform
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
%% Hack to run posthocs with more repeated factors (ie networks and age)
% https://www.mathworks.com/matlabcentral/answers/140799-3-way-repeated-measures-anova-pairwise-comparisons-using-multcompare

if size(within,2)==2
    % literal approach
%     for i=1:2
%         to_eval=['within.' within.Properties.VariableNames{i}];
%         to_eval=[to_eval ' = categorical(' to_eval ');'];
%         eval(to_eval);
%     end
%     to_eval=['within.' within.Properties.VariableNames{1} '_' within.Properties.VariableNames{2} ' = within{:,1}.*within{:,2};'];
%     eval(to_eval);
    
    % avoiding categorical
    ww=[within{:,1} within{:,2}];
    ww=[cat(1,ww{:,1}) repmat(' ',size(within,1),1) cat(1,ww{:,2})];
    ww=cellstr(ww);
    to_eval=['within.' within.Properties.VariableNames{1} '_' within.Properties.VariableNames{2} ' = ww;'];
    eval(to_eval);
    
end
%%
global_stats.within=within;
ngw=size(within,2); % number of groups within

ix_to_ix_table=array2table(repmat(ix_to_ix,nsg_w,1)');
global_stats.ix_to_ix_table=ix_to_ix_table;

%     Time=table(char(within_design.subgroups.name),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl

% Time=table(categorical(cellstr(char(within_design.subgroups.name))),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl
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
end
global_stats.table_raw_data=t;
%% prep for rm
part1=['rm = fitrm(t,'''];
part2=[t.Properties.VariableNames{ng+1} '-' t.Properties.VariableNames{end} ' ~ ' ];
part3=varnames{1};
for i=2:ng
    part3=[part3 '*' varnames{i}];
end
part4=[''', ''WithinDesign'',within);'];
% part4=[''', ''WithinDesign'',' within_design.name ');'];
to_run=[part1 part2 part3 part4];
%% commented out to include connections | March 1, 2018
% display (['Executing ' to_run])
% eval(to_run)%
%% Including connections

conn=cell(nsg_w*n_feat,1);
offset=0;
for counter=1:nsg_w
    for ijk=1:n_feat
        conn{ijk+offset}=['conn_' num2str(ijk)];
    end
    offset=offset+ijk;
end

tab2=cell2table(conn);

within_plus_conn=[within tab2];
part4=[''', ''WithinDesign'',within_plus_conn);'];
% part4=[''', ''WithinDesign'',' within_design.name ');'];
to_run2=[part1 part2 part3 part4];

display (['Executing ' to_run2])
eval(to_run2)%
%%
global_stats.within_plus_conn=within_plus_conn;
global_stats.command_to_run_main_test=to_run2;
global_stats.main_fit_model=rm;
% here June 10, 2016
%% debug
% [transdat,MSE] = cell_boxcox(data,lambda)
%
% n_groups=size(data,1)
%
% transdat=cell(n_groups,1);
% MSE=zeros(n_groups,1);
%
% local_boxcox = @(raw_data) sum((raw_data-mean(raw_data)).^2)/length(raw_data);
% %
% lambda=-2;
% for i=1:n_groups
%     [transdat{i} MSE(i)]= home_made_boxcox(data{i},lambda);
% end
% sum(MSE)
% xx=home_made_boxcox(x-min(x(:))+1,lambda);
% t2=array2table(xx);
%%




display('Mauchly''s test for sphericity ')
tbl=mauchly(rm)
if tbl.pValue<.05
    display('Small p-values of the Mauchly''s test indicates that the sphericity, hence the compound symmetry assumption, does not hold')
end


%% Select within model

if isempty(WM)
    WM=within.Properties.VariableNames{1};
    for i=2:ngw
        WM=[WM '*' within.Properties.VariableNames{i}];
    end
    WM=[WM '*conn'];
    
    if tbl.pValue<.05
        display('p-values are corrected using the Epsilon adjustment for repeated measures anova')
        epsilon(rm)
    end
    
    % to exclude hack
    if numel(within.Properties.VariableNames)>1
        WM=strrep(WM,[within.Properties.VariableNames{1} '_' within.Properties.VariableNames{2} '*'],'');
    end
    
    % To exclude higher order interaction
    WM=[WM '-' strrep(WM,'*',':')];
    WM=[WM '-Networks:conn'];
end
WM=replace( WM , ' ' , '' );
%% Run anova test after correcting for repeated measures
ranovatbl = ranova(rm,'WithinModel',WM)


main_table=ranovatbl;
%% ranova table looking at connections
% Included on WM=[WM '*conn'];

% WM2='conn';
% for i=2:ngw
%     WM2=[WM2 '*' within.Properties.VariableNames{i}];
% end
% if tbl.pValue<.05
%     display('p-values are corrected using the Epsilon adjustment for repeated measures anova')
%     epsilon(rm)
% end
%
% ranovatbl2 = ranova(rm,'WithinModel',WM2);
% display(['RM anova table using connections'])
% ranovatbl2
global_stats.ranovatbl_networks=main_table;
% global_stats.ranovatbl_connections=ranovatbl2;
%% Define folders for saving
host_folder=pwd;
main_analysis_folder=[host_folder filesep 'main_analysis'];
planB_folder=[host_folder filesep 'planB_by_networks'];

if ~isfolder(main_analysis_folder)
    mkdir(main_analysis_folder);
end

if ~isfolder(planB_folder)
    mkdir(planB_folder);
end
%% Save table as figure
filename_main_table=[main_analysis_folder filesep 'main_anova_table.csv'];
save_main_anova_table(main_table,filename_main_table);

if options.save_figures==1
    fig_name=[main_analysis_folder filesep 'main_anova_table'];
    save_formatted_table(main_table,within_design,fig_name)
    %     save_formatted_table(ranovatbl2,within_design,'table_connections')
    save_options_as_text(options,[main_analysis_folder filesep 'options.txt'])
    
    summary_folder=[main_analysis_folder filesep 'summary'];
    mkdir(summary_folder);
    copyfile([main_analysis_folder filesep 'options.txt'],summary_folder);
    copyfile([main_analysis_folder filesep 'main_anova_table.png'],summary_folder)
    %     copyfile('table_connections.png',['summary' filesep])
end
copyfile(filename_main_table,summary_folder);
delete(filename_main_table)
%% Save post hoc and marginal means tables

path_to_save=[main_analysis_folder filesep 'posthoc_tables'];
save_posthoc_and_marg_mean_tables(rm,options,path_to_save)


%% Move to main analysis folder
cd(main_analysis_folder)
%% Save data before plotting;

if isfield(options,'filename_to_save_all_before_plotting')
    filename_to_save_all_before_plotting=options.filename_to_save_all_before_plotting;
    [foo_a foo_b foo_c]=fileparts(filename_to_save_all_before_plotting);
    if ~strcmp(foo_c,'.mat')
        filename_to_save_all_before_plotting=[filename_to_save_all_before_plotting '.mat'];
    end
    save(filename_to_save_all_before_plotting,'-v7.3')
end
%% Plot significant connections

% results=multcompare(global_stats.main_fit_model,between_design.name,'by','conn');
% T=consensus_sig_connection(results,between_design);
% sig_ix=find(table2array(T(:,end))<options.p_th);
% T_sig=T(sig_ix,:);
%
% arg1=global_stats.main_fit_model.BetweenFactorNames{1};
% m=margmean(global_stats.main_fit_model,{'conn' arg1});
%
%
% patch_plot_connections_planA(T_sig,m,between_design,options)
%% Ploting individual between factors | corrected
for i=1:ng
    %         figure
    Var_name=rm.BetweenFactorNames{i};
    display(['Preparing figures comparing subgroups in ' Var_name])
    
    % To re-use prev plotting function
    m=margmean(rm,Var_name);
    to_pack_global_stats_m=['global_stats.' Var_name '.marginal_means = m;'];
    eval(to_pack_global_stats_m);
    
    Grp_name=table2cell(m(:,1));
    
    m=table2array(m(:,2:3));
    
    results=multcompare(rm,Var_name,'ComparisonType',options.correction_type);
    
    to_pack_global_stats_results=['global_stats.' Var_name '.corrected_mult_comparisons = results;'];
    eval(to_pack_global_stats_results);
    
    results=remake_results_plotting1D(results,options);
    
    n_sg=size(m,1);
    
    gnames=cell(n_sg,1);
    for j=1:n_sg
        gnames{j}=[Var_name '=' Grp_name{j}];
    end
    
    mycolor=zeros(n_sg,3);
    if i>1
        for j=1:n_sg
            try
                mycolor(j,:)=between_design(i-1).subgroups(j).color;
            end
        end
    end
    
    if sum(results(:,end)<options.p_th)
        plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,options.p_th,options)% p_th=0.5
    else
        display(['No significant, so NO figures are made']);
    end
    %     plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,1)% p_th=1
    
    %     whos results m h gnames
end

%% Ploting individual within factor

for i=1:ngw
    
    Var_name=rm.WithinFactorNames{i};
    
    
    condition_xsectional=ngw==1;
    condition_longitudinal=1;
    if ngw>1
        condition_longitudinal=~strcmp(Var_name,[within.Properties.VariableNames{1} '_' within.Properties.VariableNames{2}]);
    end
    do_it=or(condition_longitudinal,condition_xsectional);
    
    if do_it
        display(['Preparing figures comparing subgroups in ' Var_name])
        
        
        m=margmean(rm,Var_name);
        
        to_pack_global_stats_m=['global_stats.' Var_name '.marginal_means = m;'];
        eval(to_pack_global_stats_m);
        
        Grp_name=table2cell(m(:,1));
        if iscategorical(Grp_name{1})
            Grp_name=cellstr(char([Grp_name{:}]'));
        end
        
        
        m=table2array(m(:,2:3));
        results=multcompare(rm,Var_name,'ComparisonType',options.correction_type);
        
        to_pack_global_stats_results=['global_stats.' Var_name '.corrected_mult_comparisons = results;'];
        eval(to_pack_global_stats_results);
        
        results=remake_results_plotting1D(results,options);
        n_sg=size(m,1);
        
        gnames=cell(n_sg,1);
        for j=1:n_sg
            gnames{j}=[Var_name '=' Grp_name{j}];
        end
        
        mycolor=zeros(n_sg,3);
        for j=1:n_sg
            try
                mycolor(j,:)=within_design(i).subgroups(j).color;
            end
        end
        try % needs to be fixed
            if sum(results(:,end)<options.p_th)
                plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,options.p_th,options)
                %     elseif sum(results(:,end)==1)
                %         plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,options.p_th,options)
            else
                display(['No significant, so NO figures are made']);
            end
        end
        if sum(results(:,end)==1)
            plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,options.p_th,options)
        end
        %     plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor,1)
    else
        display(['Skiping figures comparing subgroups in ' Var_name])
    end
end

1;
%% Do network by each between factor
% Try plan A
% Read p_value for network_between factor
% local_p=(table2array(global_stats.ranovatbl_networks(end-1,[end-3 end-2])));

% if options.plot_uncorrected_NN_other_factor==0
for i=1:ng
    if size(between_design(i).subgroups,2)<4% if more than 3 groups, different figure
        % arg1=rm.WithinFactorNames{1};
        % arg2=rm.BetweenFactorNames{1};
        
        arg2=rm.WithinFactorNames{1};
        arg1=rm.BetweenFactorNames{i};
        % arg1=rm.WithinFactorNames{2};
        
        m=margmean(rm,{arg1 arg2});
        to_pack_global_stats_m=['global_stats.' arg1 '_' arg2 '.marginal_means = m;'];
        eval(to_pack_global_stats_m);
        
        ct{1}='tukey-kramer';
        ct{2}='dunn-sidak';
        ct{3}='bonferroni';
        ct{4}='scheffe';
        ct{5}='lsd';
        
        results=multcompare(rm,arg1,'by',arg2,'ComparisonType',options.correction_type);
        %     results=multcompare(rm,arg1,'by',arg2,'ComparisonType',ct{5})
        
        to_pack_global_stats_results=['global_stats.' arg1 '_' arg2 '.corrected_mult_comparisons = results;'];
        eval(to_pack_global_stats_results);
        
        Grp_name=table2cell(m(:,[2 1]));
        try
            Grp_name=cellfun(@cellstr,Grp_name);
        end
        % results=remake_results_plotting_mcomp2D(results,Grp_name,options);
        n_sg=size(m,1);
        
        gnames=cell(n_sg,1);
        for j=1:n_sg
            Grp_name{j,2}=char(Grp_name{j,2});
            gnames{j}=[arg2 '=' Grp_name{j,1} ',' arg1 '=' char(Grp_name{j,2})];
        end
        
        results=remake_results_plotting_mcomp2D(results,Grp_name,options);
        try
        stats.grpnames{1}=unique(Grp_name(:,1),'stable');
        catch
            stats.grpnames{1}=unique(cellfun(@cellstr,Grp_name(:,i)),'stable');
        end
        try
        stats.grpnames{2}=unique(Grp_name(:,2),'stable');
        catch
            stats.grpnames{2}=unique(cellfun(@cellstr,Grp_name(:,2)),'stable');
        end
        stats.varnames{1,1}=arg2;
        stats.varnames{2,1}=arg1;
        m=table2array(m(:,3:4));
        
        %         plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,between_design)
        sig_text=plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,between_design(i));
        to_pack_global_stats_results=['global_stats.' arg1 '_' arg2 '.sig_text = sig_text;'];
        eval(to_pack_global_stats_results);
        save('sig_interaction.mat','sig_text')
    else
        % WIP | To show uncorrected comparisons for cases with more than 3
        % groups
    end
end
% end

%% Do network by each other within factor
% temp. closed | Feb 28, 2018
if options.plot_uncorrected_NN_other_factor==0
    for i=2:ngw
        %     if size(within_design(i-1).subgroups,2)<4% if more than 3 groups, different figure
        % arg1=rm.WithinFactorNames{1};
        % arg2=rm.BetweenFactorNames{1};
        
        arg2=rm.WithinFactorNames{1};
        arg1=rm.WithinFactorNames{i};
        
        if ~strcmp(arg1,[within.Properties.VariableNames{1} '_' within.Properties.VariableNames{2}])
        
        m=margmean(rm,{arg1 arg2});
        
        to_pack_global_stats_m=['global_stats.' arg1 '_' arg2 '.marginal_means = m;'];
        eval(to_pack_global_stats_m);
        
        ct{1}='tukey-kramer';
        ct{2}='dunn-sidak';
        ct{3}='bonferroni';
        ct{4}='scheffe';
        ct{5}='lsd';
        
        results=multcompare(rm,arg1,'by',arg2,'ComparisonType',options.correction_type);
        
        to_pack_global_stats_results=['global_stats.' arg1 '_' arg2 '.corrected_mult_comparisons = results;'];
        eval(to_pack_global_stats_results);
        %     results=multcompare(rm,arg1,'by',arg2,'ComparisonType',ct{5})
        
        Grp_name=table2cell(m(:,[2 1]));
        try
            Grp_name=cellfun(@cellstr,Grp_name);
        end
        % results=remake_results_plotting_mcomp2D(results,Grp_name);
        n_sg=size(m,1);
        
        gnames=cell(n_sg,1);
        for j=1:n_sg
            Grp_name{j,2}=char(Grp_name{j,2});
            gnames{j}=[arg2 '=' Grp_name{j,1} ',' arg1 '=' char(Grp_name{j,2})];
        end
        
        results=remake_results_plotting_mcomp2D(results,Grp_name,options);
        stats.grpnames{1}=unique(Grp_name(:,1),'stable');
        stats.grpnames{2}=unique(Grp_name(:,2),'stable');
        stats.varnames{1,1}=arg2;
        stats.varnames{2,1}=arg1;
        m=table2array(m(:,3:4));
        try
            plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,within_design)
        end
        %     else
        %         % WIP | To show uncorrected comparisons for cases with more than 3
        %         % groups
        %     end
        else
        end
    end
end
%% Move to planB folder

%% Plot 3 interactions | within1 between each within2 TB fixed

if size(rm.WithinFactorNames,2)>1
    arg1=rm.WithinFactorNames{1};
    arg3=rm.WithinFactorNames{2};
    for i=1:ng
        arg2=rm.BetweenFactorNames{i};
%         if size (fconn,1)<120 %|Temporary blocking this to avoida crash on big matrices. Needs a more stable fix
            m=margmean(rm,{arg1 arg2 arg3 });
%         end
        
        to_pack_global_stats_m=['global_stats.' arg1 '_' arg2 '_' arg3 '.marginal_means = m;'];
        eval(to_pack_global_stats_m);
        
        tt=t(:,[i ng+1:end]);
        try
            posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within(:,1:2));
            %             posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within);
            global_stats.posthoc_mcomp2D_planB{i}=posthoc_mcomp2D_planB;
            % % following line needs to be optimized to avoid extra memory
            % usage | Nov 11, 2018
            %             plot_mcomp2D_plan_B_unifigures(parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within);
        end
        
        
        try
            posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within(:,1));
            %             posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within);
            global_stats.posthoc_mcomp2D_planB{i}=posthoc_mcomp2D_planB;
            % % following line needs to be optimized to avoid extra memory
            % usage | Nov 11, 2018
            %             plot_mcomp2D_plan_B_unifigures(parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within);
        end
        
        %         if options plan b
        % temp. closed | Feb 28, 2018
        %         if options.plot_uncorrected_NN_other_factor==1
        %                     posthoc_mcomp2D_planB=plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within);
        %                     global_stats.posthoc_mcomp2D_planB=posthoc_mcomp2D_planB;
        %             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,within_design(i),tt,to_run,within)
        %         end
        %
        %         if and(options.plot_uncorrected_NN_other_factor==1,size(between_design(i).subgroups,2)>3)
        %             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within)
        %         end
        
        
        %         end
        try
            posthoc_3F_RM_by_networks=plot_mcomp3F_RM_by_networks(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within,ix_to_ix_table);
            global_stats.posthoc_3F_RM_by_networks{i}=posthoc_3F_RM_by_networks;
        end
        
        try
            local_arg=arg2;
            m=margmean(rm,{arg1 local_arg});
            find_header=find(ismember(posthoc_3F_RM_by_networks.p_uncorrected.Properties.VariableNames,[arg1 '_' local_arg]));
            local_p_uncorrected=table2array(posthoc_3F_RM_by_networks.p_uncorrected(:,find_header));
            local_p_corrected=table2array(posthoc_3F_RM_by_networks.p_corrected(:,find_header));
            mk='O';
            plot_mcomp2F_RM_by_networks(m,parcel,options,arg1,local_arg,between_design,local_p_corrected,local_p_uncorrected,mk)
            
            local_arg=arg3;
            m=margmean(rm,{arg1 local_arg});
            find_header=find(ismember(posthoc_3F_RM_by_networks.p_uncorrected.Properties.VariableNames,[arg1 '_' local_arg]));
            local_p_uncorrected=table2array(posthoc_3F_RM_by_networks.p_uncorrected(:,find_header));
            local_p_corrected=table2array(posthoc_3F_RM_by_networks.p_corrected(:,find_header));
            mk='O-';
            plot_mcomp2F_RM_by_networks(m,parcel,options,arg1,local_arg,within_design,local_p_corrected,local_p_uncorrected,mk)
        end
        
    end
    
end
global_stats.parcel=parcel;
global_stats.between_design=between_design;
global_stats.within_design=within_design;
%% Move data to plan B folder
target_folder{1}='*planB*';
target_folder{2}='*by_networks';
n_target_folder=size(target_folder,2);
for i=1:n_target_folder
    temp=dir(target_folder{i});
    n_temp=size(temp,1);
    for j=1:n_temp
        source_folder=[temp(j).folder filesep temp(j).name];
        destination_folder=[planB_folder filesep temp(j).name];
        copyfile(source_folder,destination_folder);
        rmdir(source_folder, 's')  
    end 
end
%% Save post hocs for plan B
for i=1:ng
    
    %% Read posthocs
    try
        % check 3 factors
        posthoc_planB=global_stats.posthoc_3F_RM_by_networks{i};
    catch
        % go for 2 factors instead
        posthoc_planB=global_stats.posthoc_mcomp2D_planB{i};
    end
    
    %% save summary p-value tables
    preffix_group=between_design(i).name;
    path_to_save=[planB_folder filesep 'posthoc_tables' filesep preffix_group];
     path_to_save=strrep(path_to_save,[filesep 'main_analysis' filesep],filesep);
    if ~isfolder(path_to_save)
        mkdir(path_to_save)
    end
    p_corrected=posthoc_planB.p_corrected;
    p_uncorrected=posthoc_planB.p_uncorrected;
    T=cell(2,1);
    T{1}=p_corrected;
    T{2}=p_uncorrected;
    filename_table=cell(2,1);
    filename_table{1}=[path_to_save filesep preffix_group '_p_corrected'];
    filename_table{2}=[path_to_save filesep preffix_group '_p_uncorrected'];
    for j=1:2
        writetable(T{j},[filename_table{j} '.csv'],'WriteRowNames',true)
    end
    
    
    %% save detailed posthocs
    n_functional_system_pairs=size(posthoc_planB.RM,1);
    for j=1:n_functional_system_pairs
        
        rm=posthoc_planB.RM{i};
        path_to_save=[planB_folder filesep 'posthoc_tables' filesep preffix_group filesep posthoc_planB.tit{j}];
        path_to_save=strrep(path_to_save,' ','_');
        save_posthoc_and_marg_mean_tables(rm,options,path_to_save)
    end
    
    
end

%% Make unipanel figures
anchor_text='p_th_1_00_corrected_flag_0.fig';

% Find paths to multipanel figures
paths=dir([planB_folder filesep '*' filesep '*' anchor_text ]);
root_path_new_figures=host_folder;

for i=1:size(paths,1)
    local_fig=[paths(i).folder filesep paths(i).name];
    make_unipanel_figures(local_fig,root_path_new_figures)
end
%%
%% move to host folder
cd(host_folder)

% temp. closed | Feb 28, 2018
% try
%     if and(options.plot_uncorrected_NN_other_factor==1,size(within_design(i).subgroups,2)>3)
%         for i=2:ngw
%             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,within_design(i),tt,to_run,within)
%         end
%     end
% end
%% still | WIP Plan B for 1 within group
% m=margmean(rm,{arg2 arg3 arg1});
% temp. closed | Feb 28, 2018
% if options.plot_uncorrected_NN_other_factor==1
%
%     arg1=rm.WithinFactorNames{1};
%     arg3=[];
%     for i=1:ng
%         arg2=rm.BetweenFactorNames{i};
%         m=margmean(rm,{arg1 arg2  });
%
%         tt=t(:,[i ng+1:end]);
%         %         if options plan b
%         if options.plot_uncorrected_NN_other_factor==1
%             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within)
% %             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,within_design(i),tt,to_run,within)
%         end
%
%         if and(options.plot_uncorrected_NN_other_factor==1,size(between_design(i).subgroups,2)>3)
%             plot_mcomp2D_plan_B(m,parcel,options,arg1,arg2,arg3,between_design(i),tt,to_run,within)
%         end
%
%
%
%     end
%
% end
%

%

