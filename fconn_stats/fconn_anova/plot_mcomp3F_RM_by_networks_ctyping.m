function [tit, p_to_store, p_corrected,headers_comparisons,summary_P_table]=plot_mcomp3F_RM_by_networks_ctyping(m,parcel,options,arg1,arg2,arg3,between_design,t,to_run,within)
%% Make plot table

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
% endpow
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
% bg_color(end,:)=gen_bg(end,:);
% % ln_color=repmat([0 0 0],ncases,1);
% ln_color=repmat([0 0 0],ncases,1);
% ln_color([1 end],:)=1;
%
% varnames={'Numbfunction plot_mcomp3F_RM(m,parcel,options,arg1,arg2,arg3,between_design)
%% Make plot table

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
% bg_color(end,:)=gen_bg(end,:);
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
% end% ginfo(1).names={between_design(1).subgroups.name}';
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
% bg_color(end,:)=gen_bg(end,:);
% % ln_color=repmat([0 0 0],ncases,1);
% ln_color=repmat([0 0 0],ncases,1);
% ln_color([1 end],:)=1;
% % ginfo(1).names={between_design(1).subgroups.name}';
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
% bg_color(end,:)=gen_bg(end,:);
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

% part3=['shown,ln_color,bg_color,''VariableNames'',varnames)'];
% to_run=[part1 part2 part3 ]
% eval(to_run)
%%
% fig_name=[stats.varnames{1} ' vs ' stats.varnames{2}];
fig_name=[arg2 '_' arg3 '_' arg1];

if options.display_figures
    vis_flag='on';
else
    vis_flag='off';
end

fig_size=[8 1 20 20];
n_parcel=size(options.resort_parcel_order,2);

if n_parcel>6
    fig_size=[8 1 24 24];
end
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
fs_axis=9; %size of fonts in plots
fs_title=7;%size of fonts in title
fs_legend=10;
fs_label=12;
%%

% Q=table2array(ptable(:,2+(0:temp_n-1)));% section of the table that will be querried

% n_parcel=size(parcel,2);

% tit=stats.grpnames{1};
tit=unique(table2cell(m(:,1)),'stable');
xtl=table2cell(unique(m(:,3),'stable'));
line_names=unique(table2cell(m(:,2)),'stable');
n_lines=size(line_names,1);

%particular for Valeria's project

line_names=unique(table2cell(within(:,3)),'stable');
n_lines=size(line_names,1);
%

n_traces=size(xtl,1);
for i=1:n_traces
    xtl{i}=char(xtl{i});
end

% xtl=stats.grpnames{2};

mk='O-';

lw=3;
% pth=0.05;
kk=0;
% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
pth=0.05;
pth=options.p_th;
offset_xlim=.2;
offset_ylim=.1;

% for hiding non-significant plots

master_t=t;


part1=to_run(1:find(to_run=='''',1));

part3=to_run(find(to_run=='~',1):end-2);


% part1=[to_run(1:2) '1' to_run(3:12)];
% part2='(ix_p,:)';
% part3=to_run(13:22);
% part4=to_run(32:end);
% local_run=[part1 part2 part3 part4];

% n_x_networks=size(stats.grpnames{1},1);
n_x_networks=size(tit,1);
ii=1:n_traces;
if options.use_half_matrix==1
    NN_comp=n_parcel*(n_parcel+1)/2;
    for_nested_loop='for j=i:n_parcel';
else
    NN_comp=n_parcel^2;
    for_nested_loop='for j=1:n_parcel';
end

p_to_store=zeros(NN_comp,1);

all_P=zeros(NN_comp,3);
all_P_corrected=zeros(NN_comp,3);
all_DF=zeros(NN_comp,3);
new_m=[];


%% Calculate uncorrected p pvalues

for i=1:n_parcel
    
    if options.use_half_matrix==1
        for j=i:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
            subplot(n_parcel,n_parcel,k)
            
            
            
            %         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
            %         local_ix=zeros(1,n_traces);
            
            kk=kk+1;
            %         tit{kk}=[parcel(i).shortname ' and ' parcel(j).shortname];
            tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
            
            local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
            n_nn=length(local_within);
            part2=['Var1-Var' num2str(n_nn) ' '];
            part4='(local_within,:));';
            part4='(local_within,[2:end]));';
            local_run=[part1 part2 part3 part4];
            t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
            eval(local_run);
            ranovatbl = ranova(rm,'WithinModel',[rm.WithinFactorNames{1} '*' rm.WithinFactorNames{2}]);
            local_p=table2array(ranovatbl(end-1,5));
            p_to_store(kk)=local_p;
            
            all_P(kk,:)=table2array(ranovatbl(3:2:end-1,5));
            all_DF(kk,:)=table2array(ranovatbl(3:2:end-1,2));
            
            local_m=margmean(rm,rm.WithinFactorNames);
            col1=table(repmat({tit{kk}},n_lines*n_traces,1),'VariableNames',{within.Properties.VariableNames{1}});
            local_m=[col1 local_m];
            new_m=[new_m;local_m];
        end
    else
        for j=1:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
            subplot(n_parcel,n_parcel,k)
            
            
            
            %         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
            %         local_ix=zeros(1,n_traces);
            
            kk=kk+1;
            %         tit{kk}=[parcel(i).shortname ' and ' parcel(j).shortname];
            tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
            
            local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
            n_nn=length(local_within);
            part2=['Var1-Var' num2str(n_nn) ' '];
            part4='(local_within,:));';
            part4='(local_within,[2:end]));';
            local_run=[part1 part2 part3 part4];
            t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
            eval(local_run);
            ranovatbl = ranova(rm,'WithinModel',[rm.WithinFactorNames{1} '*' rm.WithinFactorNames{2}]);
            local_p=table2array(ranovatbl(end-1,5));
            p_to_store(kk)=local_p;
            
            all_P(kk,:)=table2array(ranovatbl(3:2:end-1,5));
            all_DF(kk,:)=table2array(ranovatbl(3:2:end-1,2));
            
            local_m=margmean(rm,rm.WithinFactorNames);
            col1=table(repmat({tit{kk}},n_lines*n_traces,1),'VariableNames',{within.Properties.VariableNames{1}});
            local_m=[col1 local_m];
            new_m=[new_m;local_m];
        end
    end
    
end

tit(kk+1:end)=[];
%% Use FDR to correct
% p_corrected=mafdr(p_to_store);% there is something wrong with this function. Sometimes corrected values are lower than uncorrected
% [h crit_p adj_p]=fdr_bh(p_to_store);
% [sum(p_to_store<=.05) sum(p_corrected<=.05) sum(adj_p<=.05)]

[h crit_p p_corrected]=fdr_bh(p_to_store);

for ijk=1:3
    [dummy, dummy, all_P_corrected(:,ijk)]=fdr_bh(all_P(:,ijk));
    
end

%%
headers_comparisons=ranovatbl.Properties.RowNames(3:2:end-1);
tit2=char(tit);
tit2(tit2==' ')='_';
summary_P_table=table(tit,all_DF,all_P,all_P_corrected)% We need to fixed saving p values
%% Plot the trends
kk=0;
for i=1:n_parcel
    if options.use_half_matrix==1
        for j=i:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
        subplot(n_parcel,n_parcel,k)
        
        
        
        %         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
        %         local_ix=zeros(1,n_traces);
        
        kk=kk+1;
        %         tit{kk}=[parcel(i).shortname ' and ' parcel(j).shortname];
        tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
        
        %         local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
        %         n_nn=length(local_within);
        %         part2=['Var1-Var' num2str(n_nn) ' '];
        %         part4='(local_within,:));';
        %         part4='(local_within,2));';
        %         local_run=[part1 part2 part3 part4];
        %         t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
        %         eval(local_run);
        %         ranovatbl = ranova(rm);
        %         local_p=table2array(ranovatbl(end-1,5));
        %         p_to_store(kk)=local_p;
        local_p=p_corrected(kk);
        local_ix=find(ismember(table2cell(m(:,1)),tit{kk}));
        local_ix=find(ismember(table2cell(new_m(:,1)),tit{kk}));% For valeria
        %
        %
        %         ix_p=find(ismember(table2cell(t(:,1)),tit{kk}));
        %         eval(local_run);
        %         ranovatbl = ranova(rm1,'WithinModel','within');
        %         local_p=table2array(ranovatbl(end-1,5));
        %         for ij=1:n_traces
        %             dummy=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' xtl{ij}];
        %             local_ix(ij)=find(ismember(gnames,dummy));
        %         end
        
        
        
        %         qp=zeros(1,temp_n);
        %         for k=1:temp_n
        %             unfold_arm=arms_comp{k};
        %             p1=unfold_arm(1:floor(end/2));
        %             p2=unfold_arm(ceil(end/2)+1:end);
        %
        %             P1=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p1];
        %             P2=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p2];
        %
        %             ix1=find(ismember(gnames,P1));
        %             ix2=find(ismember(gnames,P2));
        %             %             ix3=find(and(results(:,1)==ix1,results(:,2)==ix2));
        %             ix3=and(results(:,1)==ix1,results(:,2)==ix2);
        %             qp(k)=results(ix3,end);
        %         end
        %         qp=qp<pth;
        
        %         qn=ismember(Q,qp,'rows');
        min_y_plot=100;
        max_y_plot=-100;
        
        %         local_p=pp(kk); % comment out to more stable fix
        
        if local_p<pth%ptable.shown(qn)
            for ijk=1:n_lines
                %                 local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
                %                 mm=table2array(m(local_ix(local_ix2),4));
                %                 se=table2array(m(local_ix(local_ix2),5));
                
                local_ix2=find(ismember(table2cell(new_m(local_ix,3)),line_names{ijk}));% for Valeria's
                mm=table2array(new_m(local_ix(local_ix2),4));
                se=table2array(new_m(local_ix(local_ix2),5));
                
                %             'color',parcel(options.resort_parcel_order(i)).RGB,...
                %                 'fontsize',12
                %             se=m(local_ix,2);
                %             line([ii;ii],[mm+tse*se mm-tse*se]',...
                %                 'color',ptable.ln_color(qn,:),...
                %                 'linewidth',lw)
                line([ii;ii],[mm+tse*se mm-tse*se]',...
                    'color',between_design.subgroups(ijk).color,...
                    'linewidth',lw)
                %                 line([ii;ii],[mm+tse*se mm-tse*se]',...
                %                     'color',[0 0 0],...
                %                     'linewidth',lw)% for Valeria
                
                foo1=([mm+tse*se mm-tse*se]);
                foo1=min(foo1(:));
                if foo1<min_y_plot
                    min_y_plot=foo1;
                end
                
                foo2=([mm+tse*se mm-tse*se]);
                foo2=max(foo2(:));
                if foo2>max_y_plot
                    max_y_plot=foo2;
                end
                
                hold all
                plot(ii,mm,mk,'color',between_design.subgroups(ijk).color,...
                    'LineWidth',lw,...
                    'MarkerSize',6,...
                    'MarkerEdgeColor',between_design.subgroups(ijk).color,...
                    'MarkerFaceColor',[1 1 1])
                
                %             plot(ii,mm,mk,'color',ptable.ln_color(qn,:),...
                %                 'LineWidth',lw,...
                %                 'MarkerSize',6,...
                %                 'MarkerEdgeColor',ptable.ln_color(qn,:),...
                %                 'MarkerFaceColor',ptable.bg_color(qn,:))
                %             set(gca,'color',ptable.bg_color(qn,:))
                
            end
            hold off
            delta=diff([min_y_plot max_y_plot])*.25;
            min_y_plot=min_y_plot-delta;
            ylim([min_y_plot max_y_plot])
            %         else
            %             plot(ii,ii*0,'color',ptable.bg_color(qn,:))
        end
        box on
        xlim([1 n_traces]);
        set(gca,'xtick',ii)
        set(gca,'xticklabel',[])
        if i==1
            ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                'color',parcel(options.resort_parcel_order(j)).RGB,...
                'fontsize',fs_label)
        end
        if j==n_parcel
            xlabel(parcel(options.resort_parcel_order(i)).shortname,...
                'color',parcel(options.resort_parcel_order(i)).RGB,...
                'fontsize',fs_label)
            set(gca,'xticklabel',xtl)
        end
        %         xlim([0 n_traces+1]);
        %         title(ginfo(2).names(kk))
        
        
        %
        
        
        %         axis tight
        xl=xlim;
        dxl=abs(diff(xl));
        xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
        yl=ylim;
        dyl=abs(diff(yl));
        ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
        title(tit(kk),...
            'fontsize',fs_title)
        if and(local_p<pth,options.show_p_value)
            text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
                'Fontsize',fs_title,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
            
        end
        
        if and(options.show_y_scale,local_p<pth)
            yl=get(gca,'ytick');
            axis_label=set_axis_label(yl);
            set(gca,'yticklabel',axis_label)
        else
            set(gca,'yticklabel',[])%
        end
        
        %          xlim([0 n_traces+1]);
        
    end
        
            else
        for j=1:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
        subplot(n_parcel,n_parcel,k)
        
        
        
        %         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
        %         local_ix=zeros(1,n_traces);
        
        kk=kk+1;
        %         tit{kk}=[parcel(i).shortname ' and ' parcel(j).shortname];
        tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
        
        %         local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
        %         n_nn=length(local_within);
        %         part2=['Var1-Var' num2str(n_nn) ' '];
        %         part4='(local_within,:));';
        %         part4='(local_within,2));';
        %         local_run=[part1 part2 part3 part4];
        %         t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
        %         eval(local_run);
        %         ranovatbl = ranova(rm);
        %         local_p=table2array(ranovatbl(end-1,5));
        %         p_to_store(kk)=local_p;
        local_p=p_corrected(kk);
        local_ix=find(ismember(table2cell(m(:,1)),tit{kk}));
        local_ix=find(ismember(table2cell(new_m(:,1)),tit{kk}));% For valeria
        %
        %
        %         ix_p=find(ismember(table2cell(t(:,1)),tit{kk}));
        %         eval(local_run);
        %         ranovatbl = ranova(rm1,'WithinModel','within');
        %         local_p=table2array(ranovatbl(end-1,5));
        %         for ij=1:n_traces
        %             dummy=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' xtl{ij}];
        %             local_ix(ij)=find(ismember(gnames,dummy));
        %         end
        
        
        
        %         qp=zeros(1,temp_n);
        %         for k=1:temp_n
        %             unfold_arm=arms_comp{k};
        %             p1=unfold_arm(1:floor(end/2));
        %             p2=unfold_arm(ceil(end/2)+1:end);
        %
        %             P1=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p1];
        %             P2=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p2];
        %
        %             ix1=find(ismember(gnames,P1));
        %             ix2=find(ismember(gnames,P2));
        %             %             ix3=find(and(results(:,1)==ix1,results(:,2)==ix2));
        %             ix3=and(results(:,1)==ix1,results(:,2)==ix2);
        %             qp(k)=results(ix3,end);
        %         end
        %         qp=qp<pth;
        
        %         qn=ismember(Q,qp,'rows');
        min_y_plot=100;
        max_y_plot=-100;
        
        %         local_p=pp(kk); % comment out to more stable fix
        
        if local_p<pth%ptable.shown(qn)
            for ijk=1:n_lines
                %                 local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
                %                 mm=table2array(m(local_ix(local_ix2),4));
                %                 se=table2array(m(local_ix(local_ix2),5));
                
                local_ix2=find(ismember(table2cell(new_m(local_ix,3)),line_names{ijk}));% for Valeria's
                mm=table2array(new_m(local_ix(local_ix2),4));
                se=table2array(new_m(local_ix(local_ix2),5));
                
                %             'color',parcel(options.resort_parcel_order(i)).RGB,...
                %                 'fontsize',12
                %             se=m(local_ix,2);
                %             line([ii;ii],[mm+tse*se mm-tse*se]',...
                %                 'color',ptable.ln_color(qn,:),...
                %                 'linewidth',lw)
                line([ii;ii],[mm+tse*se mm-tse*se]',...
                    'color',between_design.subgroups(ijk).color,...
                    'linewidth',lw)
                %                 line([ii;ii],[mm+tse*se mm-tse*se]',...
                %                     'color',[0 0 0],...
                %                     'linewidth',lw)% for Valeria
                
                foo1=([mm+tse*se mm-tse*se]);
                foo1=min(foo1(:));
                if foo1<min_y_plot
                    min_y_plot=foo1;
                end
                
                foo2=([mm+tse*se mm-tse*se]);
                foo2=max(foo2(:));
                if foo2>max_y_plot
                    max_y_plot=foo2;
                end
                
                hold all
                plot(ii,mm,mk,'color',between_design.subgroups(ijk).color,...
                    'LineWidth',lw,...
                    'MarkerSize',6,...
                    'MarkerEdgeColor',between_design.subgroups(ijk).color,...
                    'MarkerFaceColor',[1 1 1])
                
                %             plot(ii,mm,mk,'color',ptable.ln_color(qn,:),...
                %                 'LineWidth',lw,...
                %                 'MarkerSize',6,...
                %                 'MarkerEdgeColor',ptable.ln_color(qn,:),...
                %                 'MarkerFaceColor',ptable.bg_color(qn,:))
                %             set(gca,'color',ptable.bg_color(qn,:))
                
            end
            hold off
            delta=diff([min_y_plot max_y_plot])*.25;
            min_y_plot=min_y_plot-delta;
            ylim([min_y_plot max_y_plot])
            %         else
            %             plot(ii,ii*0,'color',ptable.bg_color(qn,:))
        end
        box on
        xlim([1 n_traces]);
        set(gca,'xtick',ii)
        set(gca,'xticklabel',[])
        if i==1
            ylabel(parcel(options.resort_parcel_order(j)).shortname,...
                'color',parcel(options.resort_parcel_order(j)).RGB,...
                'fontsize',fs_label)
        end
        if j==n_parcel
            xlabel(parcel(options.resort_parcel_order(i)).shortname,...
                'color',parcel(options.resort_parcel_order(i)).RGB,...
                'fontsize',fs_label)
            set(gca,'xticklabel',xtl)
        end
        %         xlim([0 n_traces+1]);
        %         title(ginfo(2).names(kk))
        
        
        %
        
        
        %         axis tight
        xl=xlim;
        dxl=abs(diff(xl));
        xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
        yl=ylim;
        dyl=abs(diff(yl));
        ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
        title(tit(kk),...
            'fontsize',fs_title)
        if and(local_p<pth,options.show_p_value)
            text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
                'Fontsize',fs_title,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
            
        end
        
        if and(options.show_y_scale,local_p<pth)
            yl=get(gca,'ytick');
            axis_label=set_axis_label(yl);
            set(gca,'yticklabel',axis_label)
        else
            set(gca,'yticklabel',[])%
        end
        
        %          xlim([0 n_traces+1]);
        
    end
        
        
    end
end

fs=12;
text_legend=cell(n_traces,1);
for i=1:n_lines
    r=between_design.subgroups(i).color(1);
    g=between_design.subgroups(i).color(2);
    b=between_design.subgroups(i).color(3);
    text_legend{i}=['\color[rgb]{' num2str(r) ',' num2str(g) ',' num2str(b) '} ' between_design.subgroups(i).name ];
end

%%
% kk=0;
% for i=1:n_parcel
%     for j=1:n_parcel
%         k=sub2ind([n_parcel n_parcel],i,j);
%         subplot(n_parcel,n_parcel,k)
%         
%         
%         
%         %         local_ix=[1:n_x_networks:n_traces*n_x_networks]+kk;
%         %         local_ix=zeros(1,n_traces);
%         
%         kk=kk+1;
%         %         tit{kk}=[parcel(i).shortname ' and ' parcel(j).shortname];
%         tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
%         
%         %         local_within=find(ismember(table2cell(within(:,1)),tit{kk}));
%         %         n_nn=length(local_within);
%         %         part2=['Var1-Var' num2str(n_nn) ' '];
%         %         part4='(local_within,:));';
%         %         part4='(local_within,2));';
%         %         local_run=[part1 part2 part3 part4];
%         %         t=[master_t(:,1) array2table(table2array(master_t(:,[1+local_within(:)'])))];
%         %         eval(local_run);
%         %         ranovatbl = ranova(rm);
%         %         local_p=table2array(ranovatbl(end-1,5));
%         %         p_to_store(kk)=local_p;
%         local_p=p_corrected(kk);
%         local_ix=find(ismember(table2cell(m(:,1)),tit{kk}));
%         local_ix=find(ismember(table2cell(new_m(:,1)),tit{kk}));% For valeria
%         %
%         %
%         %         ix_p=find(ismember(table2cell(t(:,1)),tit{kk}));
%         %         eval(local_run);
%         %         ranovatbl = ranova(rm1,'WithinModel','within');
%         %         local_p=table2array(ranovatbl(end-1,5));
%         %         for ij=1:n_traces
%         %             dummy=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' xtl{ij}];
%         %             local_ix(ij)=find(ismember(gnames,dummy));
%         %         end
%         
%         
%         
%         %         qp=zeros(1,temp_n);
%         %         for k=1:temp_n
%         %             unfold_arm=arms_comp{k};
%         %             p1=unfold_arm(1:floor(end/2));
%         %             p2=unfold_arm(ceil(end/2)+1:end);
%         %
%         %             P1=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p1];
%         %             P2=[stats.varnames{1} '=' tit{kk} ',' stats.varnames{2} '=' p2];
%         %
%         %             ix1=find(ismember(gnames,P1));
%         %             ix2=find(ismember(gnames,P2));
%         %             %             ix3=find(and(results(:,1)==ix1,results(:,2)==ix2));
%         %             ix3=and(results(:,1)==ix1,results(:,2)==ix2);
%         %             qp(k)=results(ix3,end);
%         %         end
%         %         qp=qp<pth;
%         
%         %         qn=ismember(Q,qp,'rows');
%         min_y_plot=100;
%         max_y_plot=-100;
%         
%         %         local_p=pp(kk); % comment out to more stable fix
%         
%         if local_p<pth%ptable.shown(qn)
%             for ijk=1:n_lines
%                 %                 local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
%                 %                 mm=table2array(m(local_ix(local_ix2),4));
%                 %                 se=table2array(m(local_ix(local_ix2),5));
%                 
%                 local_ix2=find(ismember(table2cell(new_m(local_ix,3)),line_names{ijk}));% for Valeria's
%                 mm=table2array(new_m(local_ix(local_ix2),4));
%                 se=table2array(new_m(local_ix(local_ix2),5));
%                 
%                 %             'color',parcel(options.resort_parcel_order(i)).RGB,...
%                 %                 'fontsize',12
%                 %             se=m(local_ix,2);
%                 %             line([ii;ii],[mm+tse*se mm-tse*se]',...
%                 %                 'color',ptable.ln_color(qn,:),...
%                 %                 'linewidth',lw)
%                 line([ii;ii],[mm+tse*se mm-tse*se]',...
%                     'color',between_design.subgroups(ijk).color,...
%                     'linewidth',lw)
%                 %                 line([ii;ii],[mm+tse*se mm-tse*se]',...
%                 %                     'color',[0 0 0],...
%                 %                     'linewidth',lw)% for Valeria
%                 
%                 foo1=([mm+tse*se mm-tse*se]);
%                 foo1=min(foo1(:));
%                 if foo1<min_y_plot
%                     min_y_plot=foo1;
%                 end
%                 
%                 foo2=([mm+tse*se mm-tse*se]);
%                 foo2=max(foo2(:));
%                 if foo2>max_y_plot
%                     max_y_plot=foo2;
%                 end
%                 
%                 hold all
%                 plot(ii,mm,mk,'color',between_design.subgroups(ijk).color,...
%                     'LineWidth',lw,...
%                     'MarkerSize',6,...
%                     'MarkerEdgeColor',between_design.subgroups(ijk).color,...
%                     'MarkerFaceColor',[1 1 1])
%                 
%                 %             plot(ii,mm,mk,'color',ptable.ln_color(qn,:),...
%                 %                 'LineWidth',lw,...
%                 %                 'MarkerSize',6,...
%                 %                 'MarkerEdgeColor',ptable.ln_color(qn,:),...
%                 %                 'MarkerFaceColor',ptable.bg_color(qn,:))
%                 %             set(gca,'color',ptable.bg_color(qn,:))
%                 
%             end
%             hold off
%             delta=diff([min_y_plot max_y_plot])*.25;
%             min_y_plot=min_y_plot-delta;
%             ylim([min_y_plot max_y_plot])
%             %         else
%             %             plot(ii,ii*0,'color',ptable.bg_color(qn,:))
%         end
%         box on
%         xlim([1 n_traces]);
%         set(gca,'xtick',ii)
%         set(gca,'xticklabel',[])
%         if i==1
%             ylabel(parcel(options.resort_parcel_order(j)).shortname,...
%                 'color',parcel(options.resort_parcel_order(j)).RGB,...
%                 'fontsize',fs_label)
%         end
%         if j==n_parcel
%             xlabel(parcel(options.resort_parcel_order(i)).shortname,...
%                 'color',parcel(options.resort_parcel_order(i)).RGB,...
%                 'fontsize',fs_label)
%             set(gca,'xticklabel',xtl)
%         end
%         %         xlim([0 n_traces+1]);
%         %         title(ginfo(2).names(kk))
%         
%         
%         %
%         
%         
%         %         axis tight
%         xl=xlim;
%         dxl=abs(diff(xl));
%         xlim([xl(1)-dxl*offset_xlim xl(2)+dxl*offset_xlim])
%         yl=ylim;
%         dyl=abs(diff(yl));
%         ylim([yl(1)-dyl*offset_ylim yl(2)+dyl*offset_ylim])
%         title(tit(kk),...
%             'fontsize',fs_title)
%         if and(local_p<pth,options.show_p_value)
%             text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
%                 'Fontsize',fs_title,...
%                 'HorizontalAlignment','center',...
%                 'VerticalAlignment','bottom')
%             
%         end
%         
%         if and(options.show_y_scale,local_p<pth)
%             yl=get(gca,'ytick');
%             axis_label=set_axis_label(yl);
%             set(gca,'yticklabel',axis_label)
%         else
%             set(gca,'yticklabel',[])%
%         end
%         
%         %          xlim([0 n_traces+1]);
%         
%     end
% end
% fs=12;
% text_legend=cell(n_traces,1);
% for i=1:n_lines
%     r=between_design.subgroups(i).color(1);
%     g=between_design.subgroups(i).color(2);
%     b=between_design.subgroups(i).color(3);
%     text_legend{i}=['\color[rgb]{' num2str(r) ',' num2str(g) ',' num2str(b) '} ' between_design.subgroups(i).name ];
% end
%%
% subplot (n_parcel,n_parcel,n_parcel)
% pos=get(gca,'position');
% axis off

%
if options.save_figures
    %     savefig(fig_name)
    saveas(gcf,fig_name)
    print(fig_name,'-dpng','-r300')
    print(fig_name,'-dtiffn','-r300')
end
figure
text(.5, .7,text_legend,...
    'fontsize',fs)
axis off
set(gcf,'color','w')

%% WIP adding color boxes
% POS=get(gca,'position');
% POS(4)=POS(2)*.5;
% POS(2)=POS(2)*.1;
%
% subplot('position',POS)
% box on
% set(gca,'color',parcel(options.resort_parcel_order(i)).RGB)
%
% text(mean(xlim),mean(ylim),parcel(options.resort_parcel_order(i)).shortname,...
%     'HorizontalAlignment','center',...
%     'fontsize',12)
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])er' arms_comp{:} 'shown', 'ln_color' 'bg_color'};
%
% shown=[1:ncases]'>1;
% %
% part1=['ptable=table([1:ncases]'','];
% part2=[];function plot_mcomp3F_RM(m,parcel,options,arg1,arg2,arg3,between_design)
%% Make plot table

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
% bg_color(end,:)=gen_bg(end,:);
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
% end% ginfo(1).names={between_design(1).subgroups.name}';
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
% bg_color(end,:)=gen_bg(end,:);
% % ln_color=repmat([0 0 0],ncases,1);
% ln_color=repmat([0 0 0],ncases,1);
% ln_color([1 end],:)=1;
% % ginfo(1).names={between_design(1).subgroups.name}';
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
% bg_color(end,:)=gen_bg(end,:);
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

% part3=['shown,ln_color,bg_color,''VariableNames'',varnames)'];
% to_run=[part1 part2 part3 ]
% eval(to_run)
