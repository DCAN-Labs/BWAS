function plot_mcomp2F_RM_by_networks(m,parcel,options,arg1,arg2,between_design,p_corrected,p_uncorrected,mk)

%%
fig_name=[arg1 '_' between_design.name];

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
line_names={between_design.subgroups(:).name}';
n_lines=size(line_names,1);


xtl=line_names;
n_traces=size(xtl,1);
% xtl=stats.grpnames{2};

% if strcmp(arg2,between_design.name)
%     mk='O';
% else
%     mk='O-';
% end

lw=3;
% pth=0.05;

% tse=1.96;% 95%
% tse=1.15;% 75%
tse=options.bar_lengh_times_standard_error;
lw=3;
pth=0.05;
pth=options.p_th;
offset_xlim=.2;
offset_ylim=.1;

% for hiding non-significant plots



n_x_networks=size(tit,1);
ii=1:n_traces;


%% Plot the trends


p_th_vector=[pth([1 1]) 1 1];% This vector define the thresholds to be used for visualization, the asked one and one
p_th_plot=[p_corrected(:,end) p_uncorrected(:,end) p_corrected(:,end) p_uncorrected(:,end)]; % to show corrected and uncorrected p_values


suffix_figure=cell(4,1);
for i=1:4
    temp_label=['_p_th_' num2str(p_th_vector(i),'%4.2f') '_corrected_flag_' num2str(rem(i,2))];
    temp_label(temp_label=='.')='_';
    suffix_figure{i}=temp_label;
end


close(f)


folder_rf='mcomp2F_RM_by_networks';
mkdir(folder_rf)

for figure_counter=1:4
    
    
    local_fig_name=[fig_name suffix_figure{figure_counter}];
    f = figure('Visible',vis_flag,...
        'Units','centimeters',...
        'PaperUnits','centimeters',...
        'name',local_fig_name,...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'color',[1 1 1]);
    
    
    
    kk=0;
    for i=1:n_parcel
        for j=i:n_parcel
            k=sub2ind([n_parcel n_parcel],i,j);
            subplot(n_parcel,n_parcel,k)
            
            kk=kk+1;
            tit{kk}=[parcel(options.resort_parcel_order(i)).shortname ' and ' parcel(options.resort_parcel_order(j)).shortname];
            
            local_p=p_th_plot(kk,figure_counter);
            local_ix=find(ismember(table2cell(m(:,1)),tit{kk}));
            
            min_y_plot=100;
            max_y_plot=-100;
            
            if local_p<=p_th_vector(figure_counter)%local_p<pth%ptable.shown(qn)
                mm=zeros(n_traces,1);
                se=zeros(n_traces,1);
                for ijk=1:n_traces%n_lines
                    local_ix2=find(ismember(table2cell(m(local_ix,2)),line_names{ijk}));
                    mm(ijk)=table2array(m(local_ix(local_ix2),3));
                    se(ijk)=table2array(m(local_ix(local_ix2),4));
                end
                plot(ii,mm,mk,'color','k');
                hold all
                for ijk=1:n_traces%n_lines
                    
                    
                    line([ijk;ijk],[mm(ijk)+tse*se(ijk) mm(ijk)-tse*se(ijk)]',...
                        'color',between_design.subgroups(ijk).color,...
                        'linewidth',lw)
                    plot(ijk,mm(ijk),mk,...
                        'color',between_design.subgroups(ijk).color,...
                        'MarkerSize',6,...
                        'linewidth',lw)
                    plot(ijk,mm(ijk),mk,...
                        'color','w',...
                        'MarkerSize',2,...
                        'linewidth',lw)
                    
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
                    
                    delta=diff([min_y_plot max_y_plot])*.15;
                    min_y_plot=min_y_plot-delta;
                    ylim([min_y_plot max_y_plot])
                    
                    
                end
                hold off
                %                 delta=diff([min_y_plot max_y_plot])*.25;
                %                 min_y_plot=min_y_plot-delta;
                %                 ylim([min_y_plot max_y_plot])
                
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
            if and(local_p<p_th_vector(figure_counter),options.show_p_value)
                text(mean(xlim),min(ylim),['p = ' num2str(local_p,'%4.2s')],...
                    'Fontsize',fs_title,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom')
                
            end
            
            if and(options.show_y_scale,local_p<p_th_vector(figure_counter))
                yl=get(gca,'ytick');
                axis_label=set_axis_label(yl);
                set(gca,'yticklabel',axis_label)
            else
                set(gca,'yticklabel',[])%
            end
            
            %          xlim([0 n_traces+1]);
            
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
    
    subplot (n_parcel,n_parcel,n_parcel)
    pos=get(gca,'position');
    axis off
    
    text(.5, .7,text_legend,...
        'fontsize',fs)
    
    if options.save_figures
        %     savefig(fig_name)
        f.InvertHardcopy = 'off';
        saveas(gcf,[folder_rf filesep local_fig_name])
        print([folder_rf filesep local_fig_name],'-dpng','-r300')
        print([folder_rf filesep local_fig_name],'-dtiffn','-r300')
        if figure_counter==1
            copyfile([folder_rf filesep local_fig_name '.png'],['summary' filesep]);
        end
    end
    
end

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
