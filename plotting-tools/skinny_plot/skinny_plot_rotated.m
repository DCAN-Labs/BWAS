function skinny_plot_rotated(x,my_color,varargin)

%%
ptiles=[25 75;2.5 97.5];

if ~istable(x)
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

tit=local_table.Properties.VariableNames{end};
tit(tit=='_')=' ';
clear r c


%%
treatments=unique(treatment,'rows');

treatments=treatments(end:-1:1,:);
n_treatments=size(treatments,1);
%%
% if or(nargin<2,isempty(my_color))
%     my_color=prism(n_treatments);
%     my_color=get(gca,'colororder');
% end

if nargin<2
    my_color=[];
end
if isempty(my_color)
%     my_color=prism(n_treatments);
    my_color=get(gca,'colororder');
end
%%
%% Read extra options, if provided

dotted_line_flag=1;
show_text_flag=1;
linking_line_flag=0;
v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        case 'dotted_line_flag'
            dotted_line_flag=varargin{q+1};
            q = q+1;
            
        case 'show_text_flag'
            show_text_flag=varargin{q+1};
            q = q+1;
            
        case 'linking_line_flag'
            linking_line_flag=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end

dotted_line_flag=dotted_line_flag==1;
show_text_flag=show_text_flag==1;
linking_line_flag=linking_line_flag==1;
%%
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

%%
ms=8;
fs_title=10;
fs_text=8;
plot(0,0,'.w','markersize',1)
yl=[.5 n_treatments+.5];
ylim(yl);
hold all
if linking_line_flag
    plot(m,1:n_treatments,...
        'color',mean(my_color))
end
for i=1:n_treatments
    %     line(i+[-1 1]/5,m([i i]),...
    %         'color',my_color(i,:))
    if dotted_line_flag
        line(m([i i]),[0 i],...
            'color',my_color(i,:),...
            'LineStyle','-.')
    end
    plot(m(i),i,'o',...
        'MarkerFaceColor',my_color(i,:),...
        'MarkerEdgeColor',my_color(i,:),...
        'markersize',ms)
    line(l(i,:),[i i],...
        'color',my_color(i,:))
    line(L(i,:),[i i],...
        'color',my_color(i,:),...
        'linewidth',3)
    plot(m(i),i,'.w',...
        'markersize',ms/2)
    
    
    
    if show_text_flag
        %         local_text=num2str(m(i),'%4.2f');
        %         if abs(log10(abs(min(diff(sort(m))))))>3
        %             local_text=num2str(m(i),'%4.2s');
        %         end
        local_text=num2format_text(m(i),'0.2');
        text(m(i),i+.15,local_text,...
            'fontsize',fs_text,...
            'HorizontalAlignment','Left',...
            'VerticalAlignment','bottom',...
            'rotation',0)
    end
    
    
end

box off
hold off
axis tight
yl=ylim;
yl(1)=0;
ylim(yl);
delta=.4;
ylim([1-delta n_treatments+delta])


xlab=sorted.Properties.VariableNames{end};
xlab(xlab=='_')=' ';
xlabel(xlab,...
    'fontsize',fs_text);

xl=xlim;
xl(1)=0;
xlim(xl);
set(gca,'ytick',1:n_treatments)
set(gca,'yticklabel',treatments)

xl=get(gca,'xtick');
set(gca,'xtick',xl);
axis_label=num2format_text(xl,'0.2');
axis_label=set_axis_label(xl);
set(gca,'xticklabel',axis_label)

title(tit,...
    'fontsize',fs_title);