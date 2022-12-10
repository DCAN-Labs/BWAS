function show_networks_reliability (exp_var_table,varargin)

%% Oscar Miranda-Dominguez
% First line of code: Nov 26, 2021

%% Define defaults
fs=filesep;

% output folder
output_folder=pwd;

% filename
filename='networks_reliability';

% Tcolor
Tcolor=[];

% resolution
res=300;

% n_upto
n_upto=25;
%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
        case 'filename'
            filename=varargin{q+1};
            q = q+1;
            
        case 'tcolor'
            Tcolor=varargin{q+1};
            q = q+1;
            
        case 'res'
            res=varargin{q+1};
            q = q+1;
            
        case 'n_upto'
            n_upto=varargin{q+1};
            q = q+1;
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
%% Get T_variance table
exp_variance_header={'Vcum','exp_variance'};
[Tvar, Tix]= Tcell2Tvar(exp_var_table,exp_variance_header);

%% Extract my_color from T_color table Get T_color table
if isempty(Tcolor)
    my_color=rand(size(Tvar,1),3);
else
    my_color=Extract_my_color_from_T_color(Tcolor,Tvar);
end

%% Define settings for figure

network_fontsize=11;
fs_to_cm=0.0352778;% fontsize to cm

[n_rows, n_cols]=size(Tvar);
ord=cellstr(num2str([1:n_rows]'));
ord{1}=[ord{1} 'st'];
ord{2}=[ord{2} 'nd'];
for i=3:n_rows
    ord{i}=[ord{i} 'th'];
end


row_names=Tvar.Properties.RowNames;
offset=3;
L = strlength(row_names);
sizeL=max(L)+offset;
sizeLcm=sizeL*network_fontsize*fs_to_cm;

pair_length=sizeLcm*1.2;
n_pairs=n_cols-1;

fig_wide=sizeLcm+pair_length*n_pairs;
fig_tall=n_upto*network_fontsize*fs_to_cm*2;


lm=0.2;
rm=1;

x_ticks=zeros(1+(n_pairs+1)*2,1);
n_x_ticks=numel(x_ticks);
k=0;
for i=2:2:n_x_ticks
    x_ticks(i)=sizeLcm+k*(pair_length);
    x_ticks(i+1)=x_ticks(i)+rm;
    k=k+1;
end

%% Validate n_upto
n_upto=min(n_upto,n_rows);
% n_upto=n_rows;
%%
linewidth=3;
r=network_fontsize*fs_to_cm*2.5;

%%
fig_color='w';
h = figure('Visible','on',...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'Position',[8 1 fig_wide fig_tall],...
    'PaperPosition',[8 1 fig_wide fig_tall],...
    'color',fig_color);
%%

for i=1:n_rows
    text(0,i,[num2str(i) ') ' row_names{i}],...
        'fontsize',network_fontsize,...
        'color',my_color(i,:),...
        'VerticalAlignment','middle')
    
    text(x_ticks(end),i,ord{i},...
        'fontsize',network_fontsize-1,...
        'color',[1 1 1]*.4,...
        'VerticalAlignment','middle',...
        'HorizontalAlignment','left')
    hold all
    for j=1:n_cols
        pos=[x_ticks(2+2*(j-1)) Tix{i,j}-r/2 r r];
        
        if j<n_cols
            x=[pos(1)+r/2 x_ticks(2+2*(j))+r/2];
            delta=diff(x)*.15;
            x=[x(1) x(1)+delta x(2)-delta x(2)];
            
            y=Tix{i,[j j+1]};
            y=y([1 1 2 2]);
            line(x,y,...
                'color',my_color(i,:),...
                'linewidth',linewidth);
            
        end
        rectangle('Position',pos,'Curvature',[1 1],...
            'FaceColor',my_color(i,:),...
            'EdgeColor',my_color(i,:))
        local_text=num2str(Tvar{Tix{i,j},j},'%4.1f');
        text(pos(1)+r/2,pos(2)+r/2,local_text,...
            'fontsize',network_fontsize-1,...
            'Color','w',...
            'HorizontalAlignment','center',...
            'VerticalAlignment','middle')
        
        %         if j<n_cols
        %             local_text=[num2str(Tix{i,j}) ' - ' num2str(Tix{i,j+1})];
        %             local_text=[num2str(Tix{i,j})];
        %             text(x_ticks(2+2*(j-1))+r*1.1,i+.2,local_text,...
        %                 'HorizontalAlignment','left',...
        %                 'VerticalAlignment','middle')
        %         end
    end
end
for j=1:n_cols
    text(x_ticks(2+2*(j-1))+r/2,0,Tvar.Properties.VariableNames{j},...
        'HorizontalAlignment','center')
end
set(gca,'ydir','Reverse')
xl=xlim;
xl(1)=0;
yl=ylim;
%%
axis off
axis tight
% axis equal
hold off
xlim(xl)
ylim([0 n_upto])
%%
set(gca,'position',[.01 .01 .9 .98])

%% Save figure
if ~isfolder(output_folder)
    mkdir(output_folder)
end

set(gcf,'name',filename)
saveas(gcf,[output_folder filesep filename])
res_text=['-r' num2str(res)];
print([output_folder filesep filename],'-dpng',res_text)
print([output_folder filesep filename],'-dtiffn',res_text)
