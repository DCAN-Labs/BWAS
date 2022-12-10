function [p, labels, labels_ F]=compare_3_groups(local_table,tit,save_figure_flag,my_color)

%% [p, labels, labels_]=compare_3_groups(local_table,tit,save_figure_flag,my_color)
% This function makes 3 things:
%
% - compares 3 groups using an anova test
% - compare each pair of groups using a Kolmogorov-Smirnov (KS) test. It also
% compares the first group versus the other 2 groups combined also using a
% KS test. The order of the groups is determined alphabetically
% - visualize the results.
%
% For the anova test, data is normalized uisng z-scores. For ploting anf KS
% test, data is used as provided in the local_table.
%
%
%  Input variables (mandatory):
%   - local_table: The last element of the table should be the variable to be
% compared. The end-1 element is the grouping variable.
%
%  Input variables (optional):
%   - tit, text to be used as title for the figure
%   - save_figure_flag,"1" or "0", default "0". If set to one, figure is
%   saved
%   -my_color: a RGB colormap to be used to display the histograms. If not
%   provided, default colors are black, cyan, and blue.
%
%
%   Output variables:
%
%   -p, a vector with 5 p-values, one for the anova test and the remaining
%   four for each KS test
%   -labels, cell array with 5 elements, where each  entry corresponds to
%   the p value reported on the first output, respectively
%   -labels_, similar to previous one but spaces are replaced with
%   underscores (useful for combining data in tables)
%
%  Credits: Oscar Miranda-Dominguez | Jan 2019
%% Default title
if nargin<2
    tit='mult comp';
end

%% Default save_figure_flag
if nargin<3
    save_figure_flag=0;
end
%%
if nargin<4
    % my_color=[84,39,136;128,205,193;0,60,48]/255;
    my_color=[0 0 0;128,205,193;8,81,156]/255;
end
ptiles=[25 75;2.5 97.5];


[r,c]=size(local_table);
sorted=sortrows(local_table,c-1);
try
    outcome=(table2array(sorted(:,end)));
catch
    outcome=cell2mat(table2array(sorted(:,end)));
end
treatment=table2array(sorted(:,end-1));

try
    if iscategorical(treatment)
        treatment=char(treatment);
    end
end


clear r c
%%
if iscell(treatment)
    treatment=char(treatment);
end
treatments=unique(treatment,'rows');
n_treatments=size(treatments,1);

ix=cell(n_treatments,1);
m=zeros(n_treatments,1);
l=zeros(n_treatments,2);
L=zeros(n_treatments,2);

for k=1:n_treatments
    ix{k}=ismember(treatment,treatments(k,:),'rows');
    med(k)=median(outcome(ix{k}));
    m(k)=nanmean(outcome(ix{k}));
    L(k,:)=prctile(outcome(ix{k}),ptiles(1,:));
    l(k,:)=prctile(outcome(ix{k}),ptiles(2,:));
end
%% Run the tests
% y=zscore(outcome);
y=(outcome-nanmean(outcome))./nanstd(outcome);

p=zeros(5,1);
labels=cell(5,1);
[p_anova,tbl,stats] = anova1(y,treatment,'off');

p(1)=p_anova;
F=tbl{2,4};


%%
temp_labels=cell(n_treatments,1);
for i=1:n_treatments
    temp_labels{i}=treatments(i,:);
    while strcmp(temp_labels{i}(end),' ')
        temp_labels{i}(end)=[];
    end
    
end

labels{1}='ANOVA on outcome';
labels{1}='ANOVA';
labels{2}='Con vs ISO 1';
labels{3}='Con vs ISO 3';
labels{4}='ISO 1 vs ISO 3';
labels{5}='Con vs ISO';

labels{2}=[temp_labels{1} ' vs ' temp_labels{2}];
labels{3}=[temp_labels{1} ' vs ' temp_labels{3}];
labels{4}=[temp_labels{2} ' vs ' temp_labels{3}];
labels{5}=[temp_labels{1} ' vs both'];

labels_=labels;
for i=1:5
    labels_{i}(labels_{i}==' ')='_';
end

lab{2,1}=temp_labels{1};
lab{2,2}=temp_labels{2};

lab{3,1}=temp_labels{1};
lab{3,2}=temp_labels{3};

lab{4,1}=temp_labels{2};
lab{4,2}=temp_labels{3};

lab{5,1}=temp_labels{1};
lab{5,2}='both';

ix=cell(5,2);

for i=2:4
    for j=1:2
        ix{i,j}=ismember(treatment,lab{i,j},'rows');
    end
end
i=5;
j=1;
ix{i,j}=ismember(treatment,lab{i,j},'rows');
ix{i,j+1}=~ix{i,j};

for i=2:5
    [h, p(i)]=kstest2(outcome(ix{i,1}),outcome(ix{i,2}));
end
%%


fig_name=[char(tit)];
fig_name(fig_name==' ')='_';
fig_name(fig_name==')')='_';
fig_name(fig_name=='(')='_';
fig_name(fig_name=='/')='_';
fig_name(fig_name=='\')='_';
fig_name(fig_name==',')='_';
while fig_name(end)=='_'
    fig_name(end)=[];
end
%%
% fig_size=[8 1 8 10];

fig_size=[8 1 6 6];

f = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

fs_title=10;
fs_text=8;
%%

% treatments=regexprep(cellstr(treatments),'Fa','NF');
% treatments=regexprep(cellstr(treatments),'Fp','Fr');

ms=8;
subplot (4,1,1:3)
% subplot('position',[.1 .3 .8 .6])% use for this fig size fig_size=[8 1 8 10];
subplot('position',[.2 .45 .75 .43])
plot(0,0,'.w','markersize',1)
xl=[.5 n_treatments+.5];
xlim(xl);
hold all
for i=1:n_treatments
%         line(i+[-1 1]/5,m([i i]),...
%             'color',my_color(i,:))
    
    
    
    line([i xl(2)],m([i i]),...
        'color',my_color(i,:),...
        'LineStyle','-.')
    plot(i,m(i),'o',...
        'MarkerFaceColor',my_color(i,:),...
        'MarkerEdgeColor',my_color(i,:),...
        'markersize',ms)
    line([i i],l(i,:),...
        'color',my_color(i,:))
    line([i i],L(i,:),...
        'color',my_color(i,:),...
        'linewidth',3)
    plot(i,m(i),'.w',...
        'markersize',ms/2)
    local_text=num2str(m(i),'%4.2f');
    if abs(log10(abs(min(diff(sort(m))))))>3
        local_text=num2str(m(i),'%4.2s');
    end
    text(i-.1,m(i),local_text,...
        'fontsize',fs_text,...
        'HorizontalAlignment','right',...
        'VerticalAlignment','middle',...
        'rotation',0)
    
    
end
box off
hold off
axis tight
yl=ylim;
delta=abs(diff(yl));
yl(1)=yl(1)-delta/5;
yl(2)=yl(2)+delta/5;
ylim(yl)

ylab=sorted.Properties.VariableNames{end};
ylab(ylab=='_')=' ';
ylabel(ylab,...
    'fontsize',fs_text);

xlim([.3 n_treatments+.3])
set(gca,'xtick',1:n_treatments)
set(gca,'xticklabel',treatments)

set(gca,'fontsize',fs_text)

title(tit,...
    'fontsize',fs_title);
%%
% labels=regexprep(labels,'Fa','NF');
% labels=regexprep(labels,'Fp','Fr');

offset_x=[0 .1 .1 .1 .1];

subplot 414
subplot('position',[.1 .03 .8 .3])
for i=1:5
    if p(i)>.05
        text(offset_x(i),1-i,[labels{i} ', p = ' num2str(p(i),'%4.2f')],...
            'fontsize',fs_text)
    else
        
        if p(i)<0.01
            text(offset_x(i),1-i,[labels{i} ', p = ' num2str(p(i),'%4.2s')],'FontWeight','bold',...
                'fontsize',fs_text,...
                'color','k')
        else
            text(offset_x(i),1-i,[labels{i} ', p = ' num2str(p(i),'%4.2f')],'FontWeight','bold',...
                'fontsize',fs_text,...
                'color','k')
        end
    end
end
ylim([-4.5 0.5])
axis off
%%
if save_figure_flag==1
    f.InvertHardcopy = 'off';
%     print([fig_name],'-dpng','-r300')
    print([fig_name],'-dtiffn','-r300')
    saveas(gcf,[fig_name])
end
