function show_hists_provided_selected(tidyData,matched_participants,column_to_group_by,columns_to_be_matched)
%% part of the match_groups function
%
% Oscar Miranda Dominguez, Feb 9, 2019





%%
labels=table2cell((tidyData(:,column_to_group_by)));
groups=unique(labels);
n_groups=size(groups,1);
ix_all=cell(n_groups,1);
n_subjects=zeros(n_groups,1);
for i=1:n_groups
    ix_all{i}=find(ismember(labels,groups{i}));
    n_subjects(i)=numel(ix_all{i});
end
%%
n_vars=numel(columns_to_be_matched);
N=size(matched_participants,1);

SQ=ceil(sqrt(n_vars));
for i=1:n_vars
    if ~isempty(matched_participants)
    subplot(n_vars,2,2*i-1)
    else
        subplot(SQ,SQ,i)   
    end
    local_table=tidyData(:,[column_to_group_by columns_to_be_matched(i)]);
    skinny_plot(local_table,[])
    yl=ylim;
    yl=[min(local_table{:,end}) max(local_table{:,end})];
    dyl=diff(yl);
    yl(1)=yl(1)-.05*dyl;
    yl(2)=yl(2)+.05*dyl;
    
    ylim(yl);
    xt=get(gca,'xtick');
    for j=1:n_groups
        text(xt(j),yl(1)+.03*diff(yl),['N=' num2str(n_subjects(j))],...
            'fontsize',8,...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
    end
    tit=get(gca,'title');
    title([tit.String ' (all)'],...
        'fontsize',tit.FontSize)
    
    
    
    if ~isempty(matched_participants)
        subplot(n_vars,2,2*i)
        local_table=tidyData(matched_participants(:),[column_to_group_by columns_to_be_matched(i)]);
        skinny_plot(local_table,[])
        ylim(yl)
        xt=get(gca,'xtick');
        for j=1:n_groups
            text(xt(j),yl(1)+.03*diff(yl),['N=' num2str(N)],...
                'fontsize',8,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom')
        end
        tit=get(gca,'title');
        title([tit.String ' (selected)'],...
            'fontsize',tit.FontSize)
    end
end
set(gcf,'color','w')