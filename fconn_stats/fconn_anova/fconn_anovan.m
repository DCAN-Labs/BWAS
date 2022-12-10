function main_table = fconn_anovan(fconn,parcel,between_design,within_design,options)

%% Function to run anova analysis on imaging data
% Oscar Miranda-Dominguez, Jan 4, 2017

%%
if nargin < 5
    options=[];
end
%% Read options

[options] = read_options_fconn_anovas(options,parcel);
% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_fconn_anovas(options,n_cases, n_feat);

% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_basic_SVM(options,n_cases, n_feat);
options

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
n_feat=n_ROIs*(n_ROIs-1);

if issym
    n_feat=n_feat/2; % remove repeated data
end

x=zeros(sN,n_feat);
g1=cell(1,n_feat);
k=0;
sq=@(M,i,j) squeeze(M(i,j,:));%inline function to squeeze each 3D matrix

if issym
    for i=1:n_ROIs-1
        for j=i+1:n_ROIs
            k=k+1;
            x(:,k)=sq(fconn,i,j);
            g1{k}=net_mat{i,j};
        end
    end
else
    for i=1:n_ROIs
        for j=1:n_ROIs
            if i~=j
                k=k+1;
                x(:,k)=sq(fconn,i,j);
                g1{k}=net_mat{i,j};
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
ng=size(g,1)+1;% g reads the groups, the +1 is for the networks
G=cell(sN,n_feat,ng);
G(:,:,1)=repmat(g1,sN,1);
for i=1:ng-1
    G(:,:,1+i)=repmat(g{i},1,n_feat);
end

for i=1:ng
    to_run=['G' num2str(i) '=G(:,:,' num2str(i) ');'];
    eval(to_run)
end
%% Decide repeated measures or not

if isempty(within_design)
    
    %% do anovan
    part1='[p, anova_table, stats] = anovan(x(:),{G1(:) ';
    part2=[];
    for i=1:ng-1
        part2=[part2 'G' num2str(i+1) '(:) '];
    end
    part3=['},''model'',' num2str(ng) ',''varnames'','];
    
    
    
    varnames=cell(ng,1);
    varnames{1}='Networks';
    varnames(2:end)=cellstr(char(between_design.name));% not quite right (the warning), I am fooling matlab, jajaja
    
    part4='varnames';
    
    to_run=[part1 part2 part3 part4 ');'];
    display (['Executing ' to_run])
    eval(to_run)
    display('Anova table')
    anova_table
    main_table=anova_table;
    % eval(to_run) is doing this
    %[p, anova_table, stats] = anovan(x(:),{G1(:) G2(:),GN},'model',ng,'varnames',{'Group','Networks',...});
    %%
    
    for i=1:ng
        figure
        Var_name=stats.varnames{i};
        Grp_name=stats.grpnames{i};
        display(['Preparing figures comparing subgroups in ' Var_name])
        
        [results, m, h, gnames] = multcompare(stats,'Dimension',i);
        n_sg=size(m,1);
        mycolor=zeros(n_sg,3);
        if i>1
            for j=1:n_sg
                try
                    mycolor(j,:)=between_design(i-1).subgroups(j).color;
                end
            end
        end
        
        
        plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor)
        
        %     whos results m h gnames
    end
    
    %% Post hoc analysis, interaction
    figure
    display ('Preparing figures for interaction')
    [results, m, h, gnames] = multcompare(stats,'Dimension',1:ng);
    plot_mcomp2D(results,m,gnames,stats,parcel,options,between_design)
    
    display ('Done!')
else
    
    %% do repeated measures anova
    X=read_within_design(within_design,x);
    x_text=[];
    for i=1:size(X,1)
        to_run=['x' num2str(i) '=X{' num2str(i) '};'];
        x_text=[x_text 'x' num2str(i) '(:), '];
        eval(to_run)
    end
    
    %% Truncate Gs
    % This section relays on the data provided to be balanced
    n_subjects=size(X{1},1);
    
    G_text=[];
    for i=1:ng
        to_run=['G' num2str(i) '=G' num2str(i) '(1:n_subjects,:);'];
        G_text=[G_text 'G' num2str(i) '(:), '];
        eval(to_run)
    end
    
    %% do rep anovan
    
    part1='t=table(';
    
    varnames=cell(ng+size(X,1),1);
    varnames{1}='Networks';
    varnames(2:ng)=cellstr(char(between_design.name));%
    
    for i=1:size(X,1)
        varnames{ng+i}=['T' num2str(i)];
    end
    
    to_run=[part1 G_text x_text '''VariableNames'',varnames);'];
    display (['Executing ' to_run])
    eval(to_run)
    
    
    %     Time=table(char(within_design.subgroups.name),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl
    
    Time=table(categorical(cellstr(char(within_design.subgroups.name))),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl
    %% prep for rm
    part1=['rm = fitrm(t,'''];
    part2=[varnames{ng+1} '-' varnames{end} ' ~ ' ];
    part3=varnames{1};
    for i=2:ng
        part3=[part3 '*' varnames{i}];
    end
    part4=[''', ''WithinDesign'',' within_design.name ');'];
    to_run=[part1 part2 part3 part4];
    display (['Executing ' to_run])
    eval(to_run)
    display('Mauchly''s test for sphericity ')
    tbl=mauchly(rm)
    if tbl.pValue<.05
        display('Small p-values of the Mauchly''s test indicates that the sphericity, hence the compound symmetry assumption, does not hold')
    end

    ranovatbl = ranova(rm,'WithinModel','Time')
    if tbl.pValue<.05
        display('p-values are corrected using the Epsilon adjustment for repeated measures anova')
        epsilon(rm)
    end
    main_table=ranovatbl;
    
    for i=1:ng
%         figure
        
        Var_name=rm.BetweenFactorNames{i};
        display(['Preparing figures comparing subgroups in ' Var_name])
        
        % To re-use prev plotting function
        m=margmean(rm,Var_name);
        Grp_name=table2cell(m(:,1));
        
        m=table2array(m(:,2:3));
        
        results=multcompare(rm,Var_name);
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
        
        
        plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor)
        
        %     whos results m h gnames
    end
    
    Var_name=rm.WithinFactorNames{1};
    display(['Preparing figures comparing subgroups in ' Var_name])
    
    m=margmean(rm,Var_name);
    Grp_name=table2cell(m(:,1));
    if iscategorical(Grp_name{1})
        Grp_name=cellstr(char([Grp_name{:}]'));
    end
    
    
    m=table2array(m(:,2:3));
    results=multcompare(rm,Var_name);
    results=remake_results_plotting1D(results);
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
    plot_mcomp1D(results,m,gnames,Var_name,Grp_name,mycolor)
    1;
    
    %% DO network by next between variable
    arg1=rm.BetweenFactorNames{2};
    arg2=rm.BetweenFactorNames{1};
    m=margmean(rm,{arg1 arg2});
    
    Grp_name=table2cell(m(:,[2 1]));
    n_sg=size(m,1);
    
    gnames=cell(n_sg,1);
    for j=1:n_sg
        gnames{j}=[arg2 '=' Grp_name{j,1} ',' arg1 '=' Grp_name{j,2}];
    end
    
    m=table2array(m(:,3:4));
    
    results=multcompare(rm,arg1,'by',arg2);
    results=remake_results_plotting_mcomp2D(results,Grp_name,options);
    stats.grpnames{1}=unique(G1,'stable');
    stats.grpnames{2}=unique(Grp_name(:,2),'stable');
    stats.varnames{1,1}=arg2;
    stats.varnames{2,1}=arg1;
    
    
    plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,between_design)
    
    %% Time
    arg1=rm.WithinFactorNames{1};
    arg2=rm.BetweenFactorNames{1};
    m=margmean(rm,{arg1 arg2});
    results=multcompare(rm,arg1,'by',arg2);
    
    Grp_name=table2cell(m(:,[2 1]));
    
    n_sg=size(m,1);
    
    gnames=cell(n_sg,1);
    for j=1:n_sg
        Grp_name{j,2}=char(Grp_name{j,2});
        gnames{j}=[arg2 '=' Grp_name{j,1} ',' arg1 '=' char(Grp_name{j,2})];
    end
    
    results=remake_results_plotting_mcomp2D(results,Grp_name);
    stats.grpnames{1}=unique(G1,'stable');
    stats.grpnames{2}=unique(Grp_name(:,2),'stable');
    stats.varnames{1,1}=arg2;
    stats.varnames{2,1}=arg1;
    m=table2array(m(:,3:4));
    plot_mcomp2D_RM(results,m,gnames,stats,parcel,options,within_design)
    
    %% Plot 3 interactions
    arg1=rm.WithinFactorNames{1};
    
    arg2=rm.BetweenFactorNames{1};
    arg3=rm.BetweenFactorNames{2};
    m=margmean(rm,{arg2 arg3 arg1});
    
    plot_mcomp3F_RM(m,parcel,options,arg1,arg2,arg3,between_design,t,to_run,Time)
    
    %% stringent
%     clear t
% t1=cell2table(G2(:,1))
% t1.Properties.VariableNames{1}='Exposure';
% t2=array2table([x1 x2 x3]);
% t=[t1 t2];
% 
% whos t
% 
% %%
% 
% within=repmat(G1(1,:),1,3);
% 
% for i=1:size(within,2)
%     foo=within{i};
%     foo(foo==' ')='_';
%     within{i}=foo;
% end
% within=cell2table(within');
% within.Properties.VariableNames={'Networks'};
% 
% time=repmat({'m2', 'm4', 'm6'},n_feat,1);
% time=time(:);
% time=cell2table(time);
% within=[time within];
% 
% %%
% rm = fitrm(t,'Var1-Var9963 ~ Exposure','WithinDesign',within);
% 
% ranovatbl = ranova(rm,'WithinModel','Networks*time')
    

    
end
% %% Make plot table
%
% ginfo(1).names={between_design(1).subgroups.name}';
% ginfo(1).n=size(ginfo(1).names,1);
%
%
% ncases=2.^nchoosek(ginfo(1).n,2);% base 2 because for each comparison there are 2 possible outcomes: significant or not significant. nchoosek(ginfo(1).n,2) calculates how many pair comparisons can be made
% foo=nchoosek(ginfo(1).names,2);% made for temp saving
% temp_n=size(foo,1);
% arms_comp=cell(temp_n,1);
%
%
% for i=1:temp_n
%     arms_comp{i}=[foo{i,1} '_' foo{i,2}];
% end
%
% dummy=dec2bin(0:ncases-1);% code each comparison as significant or not
% cases=zeros(size(dummy));
% for i=1:size(cases,2)
%     cases(:,i)=str2num(dummy(:,i));
% end
%
% bg_color=zeros(ncases,3);
% gen_bg=repmat(linspace(1,0,temp_n)',1,3);
%
% for i=0:temp_n-2
%     foo=sum(cases,2)'==i;
%     bg_color(foo,:)=repmat(gen_bg(i+1,:),sum(foo),1);
% end
% bg_color(end,:)=gen_bg(end,:);
%
% temp_ix=find(sum(cases,2)==temp_n-1);
% j=0;
% for i=1:temp_n
%     j=j+1;
%     bg_color(temp_ix(i),:)=between_design(1).subgroups(end-j+1).color;
% end
%
% % ln_color=repmat([0 0 0],ncases,1);
% ln_color=repmat([0 0 0],ncases,1);
% ln_color([1 end],:)=1;
%
% varnames={'Number' arms_comp{:} 'shown', 'ln_color' 'bg_color'};
%
% shown=[1:ncases]'>1;
% %
% part1=['ptable=table([1:ncases]'','];
% part2=[];
% for i=1:temp_n
%     part2=[part2 'cases(:,' num2str(i) '), '];
% end
% part3=['shown,ln_color,bg_color,''VariableNames'',varnames)'];
% to_run=[part1 part2 part3 ]
% eval(to_run)
%
% %%
%
