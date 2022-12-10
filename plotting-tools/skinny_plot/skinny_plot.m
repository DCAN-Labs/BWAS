function skinny_plot(x,my_color,varargin)

%%
warning ('off','all');
ptiles=[25 75;2.5 97.5];

if ~istable(x)
    labels=repmat('x',size(x,1),1);
    local_table=[table(labels) array2table(x)];
    clear labels;
else
    local_table=x;
end

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

try
    if isnumeric(treatment)
        treatment=num2str(treatment);
    end
end

tit=local_table.Properties.VariableNames{end};
tit(tit=='_')=' ';
clear r c


%%
treatments=unique(treatment,'rows');

if ~iscell(treatments)
    treatments=cellstr(treatments);
end
n_treatments=size(treatments,1);

%% outliers

ol_flag=0;
ol_method='median';
%%
% if or(nargin<2,isempty(my_color))
%     my_color=prism(n_treatments);
%     my_color=get(gca,'colororder');
% end

if nargin<2
    my_color=[];
end
if isempty(my_color)
    my_color=get(gca,'colororder');
    n_my_color=size(my_color,1);
    if n_my_color<n_treatments
        my_color=repmat(my_color,ceil(n_treatments/n_my_color),1);
        %         my_color=prism(n_treatments);
    end
    %
end
%%
%% Read extra options, if provided

ylim_flag=0;
dotted_line_flag=1;
show_text_flag=1;
linking_line_flag=0;
use_median_instead_of_mean_flag=0;
span=ptiles(end,:);
include_count=0;
v = length(varargin);
thick_linewidth=5;
thin_linewidth=1;

resort_groups = 1:n_treatments;
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'thick_linewidth'
            thick_linewidth=varargin{q+1};
            q = q+1;
            
        case 'thin_linewidth'
            thin_linewidth=varargin{q+1};
            q = q+1;
            
            
        case 'dotted_line_flag'
            dotted_line_flag=varargin{q+1};
            q = q+1;
            
        case 'show_text_flag'
            show_text_flag=varargin{q+1};
            q = q+1;
            
        case 'linking_line_flag'
            linking_line_flag=varargin{q+1};
            q = q+1;
            
        case 'resort_groups'
            resort_groups=varargin{q+1};
            q = q+1;
            
        case 'use_median_instead_of_mean_flag'
            use_median_instead_of_mean_flag=varargin{q+1};
            q = q+1;
            
        case 'ol_flag'
            ol_flag=varargin{q+1};
            q = q+1;
            
        case 'span'
            span=varargin{q+1};
            q = q+1;
            
            
        case 'yl'
            yl=varargin{q+1};
            ylim_flag=1;
            q = q+1;
            
        case 'include_count'
            include_count=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

ol_flag=ol_flag==1;
dotted_line_flag=dotted_line_flag==1;
show_text_flag=show_text_flag==1;
linking_line_flag=linking_line_flag==1;
use_median_instead_of_mean_flag=use_median_instead_of_mean_flag==1;
ylim_flag=ylim_flag==1;
ptiles(end,:)=span;
include_count=include_count==1;
%%
ix=cell(n_treatments,1);
ix_ol=cell(n_treatments,1);
ol=cell(n_treatments,1);
m=zeros(n_treatments,1);
l=zeros(n_treatments,2);
L=zeros(n_treatments,2);

for k=1:n_treatments
    ix{k}=ismember(treatment,treatments(k,:),'rows');
    
    y=outcome(ix{k});
    [ix_in, ix_ol{k}]=check_outliers(y,ol_flag,ol_method);
    ol{k}=y(ix_ol{k});
    
    local_ix=and(find(ix{k}),ix_in);
    
    med(k)=prctile(y(local_ix),50);
    m(k)=nanmean(y(local_ix));
    if use_median_instead_of_mean_flag
        m(k)=nanmedian(y(local_ix));
    end
    L(k,:)=prctile(y(local_ix),ptiles(1,:));
    l(k,:)=prctile(y(local_ix),ptiles(2,:));
    
    %     med(k)=median(outcome(ix{k}));
    %     m(k)=nanmean(outcome(ix{k}));
    %     L(k,:)=prctile(outcome(ix{k}),ptiles(1,:));
    %     l(k,:)=prctile(outcome(ix{k}),ptiles(2,:));
end

%%
ms=8;
fs_title=10;
fs_text=8;
plot(0,0,'.w','markersize',1)
xl=[.5 n_treatments+.5];
xlim(xl);
hold all
if linking_line_flag
    plot(1:n_treatments,m(resort_groups),...
        'color',mean(my_color))
end
for j=1:n_treatments
    i=resort_groups(j);
    %     line(i+[-1 1]/5,m([i i]),...
    %         'color',my_color(i,:))
    
    central_tendency=m(i);
    if use_median_instead_of_mean_flag
        central_tendency=med(i);
    end
    if dotted_line_flag
        line([j xl(2)],central_tendency([1 1]),...
            'color',my_color(i,:),...
            'LineStyle','-.')
    end
    
    
    
    
    plot(j,central_tendency,'o',...
        'MarkerFaceColor',my_color(i,:),...
        'MarkerEdgeColor',my_color(i,:),...
        'markersize',ms)
    line([j j],l(i,:),...
        'color',my_color(i,:),...
        'linewidth',thin_linewidth)
    line([j j],L(i,:),...
        'color',my_color(i,:),...
        'linewidth',thick_linewidth)
    plot(j,central_tendency,'.w',...
        'markersize',ms/2)
    try
        plot(j,ol{i},'.w',...
            'MarkerFaceColor',my_color(i,:),...
            'MarkerEdgeColor',my_color(i,:),...
            'markersize',ms)
        
        plot(j,ol{i},'.w',...
            'markersize',ms/3)
    end
    
    
    
    if show_text_flag
        %         local_text=num2str(m(i),'%4.2f');
        %         if abs(log10(abs(min(diff(sort(m))))))>3
        %             local_text=num2str(m(i),'%4.2s');
        %         end
        
        
        try
            local_text=num2format_text(central_tendency,'0.3');
        catch
            t1='num2format_text function from text_manipulation''s toolbox (https://gitlab.com/Fair_lab/text_manipulation.git) is prefered. As not available using num2str';
            disp(t1)
            local_text=num2str(central_tendency);
        end
        text(j-.15,central_tendency,local_text,...
            'fontsize',fs_text,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','middle',...
            'rotation',0)
    end
    
    
end


box off
hold off
axis tight
if ylim_flag==0
    yl=ylim;
    delta=abs(diff(yl));
    yl(1)=yl(1)-delta/5;
    yl(2)=yl(2)+delta/5;
end
ylim(yl)

ylab=sorted.Properties.VariableNames{end};
ylab(ylab=='_')=' ';
ylabel(ylab,...
    'fontsize',fs_text);

xlim([.3 n_treatments+.3])
set(gca,'xtick',1:n_treatments)
set(gca,'xticklabel',treatments(resort_groups))

set(gca,'xticklabel',treatments(resort_groups))

if include_count
    leg_n=count_from_categorical(treatment);
    splitted=split( leg_n,' ' );
    xt=get(gca,'xticklabel');
    n_xt=size(xt,1);
    temp=char(leg_n);
    ix=zeros(n_xt,1);
    new_xt=cell(n_xt,1);
    for i=1:n_xt
        
        new_xt{i}=splitted(i,:)';
        
        local_text=xt{i};
        n_local_text=numel(local_text);
        ix(i)=find(ismember(temp(:,1:n_local_text),local_text,'rows'));
    end
    set(gca,'XTickLabel',leg_n(ix))
    %     set(gca,'XTickLabel',new_xt)
end

set(gca,'fontsize',fs_text)

yl=get(gca,'ytick');
set(gca,'ytick',yl);
% axis_label=num2format_text(yl,'0.2');

try
    axis_label=set_axis_label(yl);
    set(gca,'yticklabel',axis_label)
catch
    t2='set_axis_label function from fconn_stats''s toolbox (https://gitlab.com/Fair_lab/fconn_stats) is prefered. As not available text in the ylabel is not reformatted';
    disp(t2)
end

title(tit,...
    'fontsize',fs_title);
warning ('on','all');