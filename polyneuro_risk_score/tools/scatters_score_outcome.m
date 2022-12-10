function x = scatters_score_outcome(demographics_Table,...
    path_group_Design_Table,...
    PBScores,...
    path_Group_Color_Table,...
    PBScores_null,...
    path_save_scatter_plots,...
    make_figures_flag)
%% check if skip_figures_flag
if ~exist('make_figures_flag','var')
    make_figures_flag=1;
end
make_figures_flag=make_figures_flag==1;
%% check if path provided
if ~exist('path_save_scatter_plots','var')
    path_save_scatter_plots=[pwd filesep 'figures' filesep 'scatter_plots' filesep 'by_top_connection'];
end

local_folder=path_save_scatter_plots;
if ~isfolder(local_folder)
    if make_figures_flag==1
        % only make the folder if figures will be saved
        mkdir(local_folder)
    end
end
%%
Group_Color_Table_flag=1;
if isempty(path_Group_Color_Table)
    Group_Color_Table_flag=0;
end
Group_Color_Table_flag=Group_Color_Table_flag==1;

%%

% [demographics_Table, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_demographics_Table,path_demographics_Table);
group_Design_Table=readtable(path_group_Design_Table);

%% Define demographics table headers by type

T_column_names_for_between = get_variable_design(group_Design_Table,'between');
T_column_names_for_within = get_variable_design(group_Design_Table,'within');
T_column_names_for_outcome = get_variable_design(group_Design_Table,'outcome');
T_column_names_for_id = get_variable_design(group_Design_Table,'id');

%%
if Group_Color_Table_flag
    Group_Color_Table=readtable(path_Group_Color_Table);
else
    Group_Color_Table=[];
end
%% x data

x=demographics_Table{:,T_column_names_for_outcome};
x_lab=demographics_Table.Properties.VariableNames{T_column_names_for_outcome};
x_lab = strrep(x_lab,'_',' ');
%%
y_lab=demographics_Table.Properties.VariableNames;

%%
% Figure size
if make_figures_flag
    vis_flag='on';
    fig_size=[1 1 8 8];
    f = figure('Visible',vis_flag,...
        'Units','centimeters',...
        'PaperUnits','centimeters',...
        'PaperPosition',fig_size,...
        'Position',fig_size,...
        'color',[1 1 1]);
end
%%
n_plots=size(PBScores,2)-1;
%% Pre allocate memory for R
R=nan(n_plots,1);
row_names=cell(n_plots,1);
%% Make figures ans save

sz=16;
c='k';
lw=3;


for i=1:n_plots
    j=i+1;
    y=PBScores{:,j};
    x=demographics_Table{:,T_column_names_for_outcome};
    % hard nan validation
    ix_in=~isnan(y);
    ix_in=and(ix_in,~isnan(x));
    y=y(ix_in);
    x=x(ix_in);
    
    tit=cell(2,1);
    tit{1}=PBScores.Properties.VariableNames{j};
    R(i)=corr(x,y);
    p=polyfit(x,y,1);
    
    V=100*R(i)^2;
    
    tit{2}=['\fontsize{8} R = ' num2format_text(R(i)) ' (Exp. Variance: ' num2format_text(V) ' %)'];
    filename=['scatter_' tit{1}];
    tit = strrep(tit,'_point_','.');
    tit = strrep(tit,'_',' ');
    tit = strrep(tit,'top 0','top ');
    tit = strrep(tit,'  ',' ');
    tit = strrep(tit,'percent','% features');
    tit = strrep(tit,' %','%');
    row_names{i}=tit{1};
    
    if make_figures_flag
        
        scatter(x,y,sz,c,'filled');
        set(gca,'View',[90 -90])
        h1=lsline;
        h1.Color = 'k';
        h1.LineWidth = lw;
        title(tit)
        xlabel(x_lab)
        ylabel('PNRS')
        axis square
        
        
        yl=get(gca,'ytick');
        set(gca,'ytick',yl);
        axis_label=set_axis_label(yl);
        set(gca,'yticklabel',axis_label)
        
        xl=get(gca,'xtick');
        set(gca,'xtick',xl);
        axis_label=set_axis_label(xl);
        set(gca,'xticklabel',axis_label)
        
        % remove spaces from filename, if they exist
        filename=strrep(filename,' ','_');
        set(gcf,'name',filename)
        saveas(gcf,[local_folder filesep filename])
        print([local_folder filesep filename],'-dpng','-r300')
        %     print([local_folder filesep filename],'-dtiffn','-r300')
        
        
        %%   do the dscatter
        
        yl=ylim;
        xl=xlim;
        dscatter(x,y);
        set(gca,'View',[90 -90])
        xlim(xl)
        ylim(yl)
        hold on
        dscatter(x,y,'plottype','contour')
        hold off
        colormap jet
        
        h1=lsline;
        h1.Color = 'k';
        h1.LineWidth = lw;
        title(tit)
        xlabel(x_lab)
        ylabel('PNRS')
        axis square
        
        yl=get(gca,'ytick');
        set(gca,'ytick',yl);
        axis_label=set_axis_label(yl);
        set(gca,'yticklabel',axis_label)
        
        xl=get(gca,'xtick');
        set(gca,'xtick',xl);
        axis_label=set_axis_label(xl);
        set(gca,'xticklabel',axis_label);
        
        old='scatter';
        new='dscatter';
        filename=strrep(filename,old,new);
        set(gcf,'name',filename)
        saveas(gcf,[local_folder filesep filename])
        print([local_folder filesep filename],'-dpng','-r300')
        %     print([local_folder filesep filename],'-dtiffn','-r300')
        new='scatter';
        old='dscatter';
        filename=strrep(filename,old,new);
        %%
        n_bet=numel(T_column_names_for_between);
        for k=1:n_bet
            g=demographics_Table{:,T_column_names_for_between{k}};
            g=g(ix_in);
            g_type=whos('g');
            switch g_type.class
                case 'double'
                    scatter3(x,y,g,'filled')
                    %set(gca,'View',[90 -90])
                    zlab=T_column_names_for_between{k};
                    zlab = strrep( zlab , '_' , ' ' );
                    zlabel (zlab)
                    
                    zl=get(gca,'ztick');
                    set(gca,'ztick',zl);
                    axis_label=set_axis_label(zl);
                    set(gca,'zticklabel',axis_label)
                    
                case 'char'
                    clr=get_colors(g,Group_Color_Table);
                    if isempty(clr)
                        gscatter(x,y,g);
                    else
                        gscatter(x,y,g,clr);
                    end
                    set(gca,'View',[90 -90])
                    yp=polyval(p,xlim);
                    line(xlim,yp,'color',c,'linewidth',lw);
                    leg=get(gca,'legend');
                    leg.String(end)=[];
            end
            
            box off
            xlabel(x_lab)
            ylabel('PNRS')
            
            yl=get(gca,'ytick');
            set(gca,'ytick',yl);
            axis_label=set_axis_label(yl);
            set(gca,'yticklabel',axis_label)
            
            xl=get(gca,'xtick');
            set(gca,'xtick',xl);
            axis_label=set_axis_label(xl);
            set(gca,'xticklabel',axis_label)
            
            axis square
            title(tit)
            
            local_filename=['g' filename '_by_' T_column_names_for_between{k}];
            saveas(gcf,[local_folder filesep local_filename])
            print([local_folder filesep local_filename],'-dpng','-r300')
            %         print([local_folder filesep local_filename],'-dtiffn','-r300')
        end
    end
end

%% Make table
V=100*R.^2;
T=array2table([R V]);
T.Properties.RowNames=row_names;
T.Properties.VariableNames{1}='R';
T.Properties.VariableNames{2}='exp_variance';

if contains(T.Properties.RowNames{1},'Top')
    filename='correlations.csv';
else
    T=sortrows(T,1,'descend');
    filename='correlations_by_networks.csv';
end
filepath=[pwd filesep 'tables'];
if ~isfolder(filepath)
    mkdir(filepath)
end

writetable(T,[filepath filesep filename],'WriteRowNames',true)
disp(T);

%% Make null
if ~isempty(PBScores_null)
    x=demographics_Table{:,T_column_names_for_outcome};
    N_null=size(PBScores_null,3);
    R_Null=nan(n_plots,N_null);
    for i=1:n_plots
        for j=1:N_null
            y=PBScores_null(:,i,j);
            ix_in=~isnan(y);
            ix_in=and(ix_in,~isnan(x));
            local_y=y(ix_in);
            local_x=x(ix_in);
            R_Null(i,j)=corr(local_x,local_y);
        end
    end
    V_null=100*R_Null.^2;
    
    %% Make figure Null
    xlab=T.Properties.RowNames;
    tit='% Explained Variance';
    plot_data_versus_null(V,V_null,xlab,...
        tit)
    
    tit='Correlations';
    plot_data_versus_null(R,R_Null,xlab,...
        tit)
    
end
%% Make figure by netwirks
if contains(filename,'by_networks')
    output_folder=[pwd filesep 'figures' filesep 'ExplainedVariance_and_Null'];
    if make_figures_flag
        try % it will only work for correlation matrices not for scalars
            correlations_by_network_to_M([pwd filesep 'tables' filesep filename],...
                'output_folder',output_folder);
        end
    end
end