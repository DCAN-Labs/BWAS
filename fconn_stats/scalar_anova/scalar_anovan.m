function main_results = scalar_anovan(scalar_brainarea_subject,between_design,within_design,options)
if nargin < 4
    options=[];
end
%% Read options
%
% [options] = read_options_scalar_anovas(options,parcel);
% % [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_fconn_anovas(options,n_cases, n_feat);

% [N, perc_training, core_features, increment_features, upto_features,partition, N_opt_svm, null_hypothesis,balance_1_0,options] = read_options_basic_SVM(options,n_cases, n_feat);
options
%%
[n_ROIs, sN]=size(scalar_brainarea_subject);% count subjects
y=scalar_brainarea_subject;
%% Preparing text to run naovan
g=read_between_design(between_design,sN);
ng=size(g,1);
% G=cell(sN,n_feat,ng);
G=cell(sN,ng);

for i=1:ng
    G(:,i)=repmat(g{i},1);
end

for i=1:ng
    to_run=['G' num2str(i) '=G(:,' num2str(i) ');'];
    eval(to_run)
end

%% Read within design varnames
varnames=cell(ng,1);
varnames(1:end)=cellstr(char(between_design.name));% not quite right (the warning), I am fooling matlab, jajaja
%%
all_anova_tables=cell(n_ROIs,1);

%% Decide repeated measures or not

if isempty(within_design)
    
    %% do anovan
    part1='[p, anova_table, stats] = anovan(x(:),{G1(:) ';
    part2=[];
    for i=1:ng-1
        part2=[part2 'G' num2str(i+1) '(:) '];
    end
    part3=['},''model'',' num2str(ng) ',''varnames'','];
%     part3=['},''model'', ''full'' ,''varnames'','];
    
    
    
    
    part4='varnames';
    
    to_run=[part1 part2 part3 part4 ',''display'',''off'');'];
    %     to_run=[part1 part2 part3 part4 ',''display'',''on'');'];
    
    % calculate interactions
    n_int=0;
    for i=1:ng
        n_int=n_int+nchoosek(ng,i);
    end
    
    %memory prealocation
    P=nan(n_ROIs,n_int+2);
    F=nan(n_ROIs,n_int+2);
    SSE=nan(n_ROIs,n_int+2);
    MSE=nan(n_ROIs,n_int+2);
    dof=nan(n_ROIs,n_int+2);
    
    
    display (['Executing ' to_run])
    for j=1:n_ROIs
        x=y(j,:);
        eval(to_run)
        P(j,1:end-2)=p;
        F(j,1:end-2)=[anova_table{2:end-2,6}];
        SSE(j,:)=[anova_table{2:end,2}];
        MSE(j,1:end-1)=[anova_table{2:end-1,5}];
        dof(j,:)=[anova_table{2:end,3}];
        
        all_anova_tables{j}=anova_table;
        %         j
    end
    
    var_names=anova_table(2:end,1);
    for j=1:n_int+2
        foo=var_names{j};
        foo(foo=='(')=[];
        foo(foo==')')=[];
        foo(foo==':')='_';
        foo(foo=='*')='_';
        var_names{j}=foo;
    end
    
    main_results.var_names=var_names;
    main_results.all_anova_tables=all_anova_tables;
    main_results.P=P;
    main_results.F=F;
    main_results.SSE=SSE;
    main_results.MSE=MSE;
    main_results.dof=dof;
    %     eval(to_run)
    %     display('Anova table')
    %     anova_table
    %     main_table=anova_table;
    % eval(to_run) is doing this
    %[p, anova_table, stats] = anovan(x(:),{G1(:) G2(:),GN},'model',ng,'varnames',{'Group','Networks',...});
    %%
    
else
    
    n_int=0;
    for i=1:ng
        n_int=n_int+nchoosek(ng,i);
    end
    
    n_int=2*n_int+2; % to add errors and intercpets
    
    
    ngw=size(within_design,2);
    x_text=[];
    for i=1:ngw
        nsg=size(within_design(i).subgroups,2);
        X=cell(nsg,1);
        
        for j=1:nsg
            X{j}=within_design(i).subgroups(j).ix;
            x_text=[x_text 'x' num2str(j) '(:), '];
            %             eval(to_run)
        end
    end
    
    G_text=[];
    for i=1:ng
        to_run_G=['G' num2str(i) '=G' num2str(i) '(within_design(1).subgroups(1).ix);'];
        G_text=[G_text 'G' num2str(i) '(:), '];
        eval(to_run_G)
    end
    
    
    nsg=size(within_design(1).subgroups,2);
    part1='t=table(';
    for i=1:nsg
        varnames{ng+i}=['T' num2str(i)];
    end
    
    to_make_t=[part1 G_text x_text '''VariableNames'',varnames);'];
    
    %memory prealocation
    P=nan(n_ROIs,n_int+2);
    F=nan(n_ROIs,n_int+2);
    SSE=nan(n_ROIs,n_int+2);
    MSE=nan(n_ROIs,n_int+2);
    dof=nan(n_ROIs,n_int+2);
    
    Time=table(categorical(cellstr(char(within_design.subgroups.name))),'VariableNames',{within_design.name}); % this variable time is used in ranovatbl
    
    for j=1:n_ROIs
        for i=1:nsg
            fill_x=['x' num2str(i) '=y(' num2str(j) ',X{' num2str(i) '});'];
            eval(fill_x)
        end
        
        eval(to_make_t)
        
        
        
        %% prep for rm
        part1=['rm = fitrm(t,'''];
        part2=[varnames{ng+1} '-' varnames{end} ' ~ ' ];
        part3=varnames{1};
        for i=2:ng
            part3=[part3 '*' varnames{i}];
        end
        part4=[''', ''WithinDesign'',' within_design.name ');'];
        to_run_rm=[part1 part2 part3 part4];
%         display (['Executing ' to_run])
        eval(to_run_rm)
%         display('Mauchly''s test for sphericity ')
        %         tbl=mauchly(rm)
        %         if tbl.pValue<.05
        %             display('Small p-values of the Mauchly''s test indicates that the sphericity, hence the compound symmetry assumption, does not hold')
        %         end
        
        ranovatbl = ranova(rm,'WithinModel','Time');
        %         if tbl.pValue<.05
        %             display('p-values are corrected using the Epsilon adjustment for repeated measures anova')
        %             epsilon(rm)
        %         end
        anova_table=ranovatbl;
        all_anova_tables{j}=anova_table;
        p=anova_table.pValue;
        f=anova_table.F;
        
        
        P(j,[1:end/2-1 end/2+1:end-1])= p([1:end/2-1 end/2+1:end-1]);
        F(j,[1:end/2-1 end/2+1:end-1])= f([1:end/2-1 end/2+1:end-1]);
        SSE(j,:)=anova_table.SumSq;
        MSE(j,:)=anova_table.MeanSq;
        dof(j,:)=anova_table.DF;
        
        %         all_anova_tables{j}=anova_table;
                j
    end
    
    var_names=anova_table.Properties.RowNames;
    for j=1:n_int+2
        foo=var_names{j};
        foo(foo=='(')=[];
        foo(foo==')')=[];
        foo(foo==':')='_';
        foo(foo=='*')='_';
        var_names{j}=foo;
    end
    
    main_results.var_names=var_names;
    main_results.all_anova_tables=all_anova_tables;
    main_results.P=P;
    main_results.F=F;
    main_results.SSE=SSE;
    main_results.MSE=MSE;
    main_results.dof=dof;
    
    
    
    
    
    
    
end