function make_unipanel_figures(local_fig,root_path_new_figures)
%%
% local_fig='Diet_age_Networks_p_th_1_00_corrected_flag_0.fig';
%% Load local figure

openfig(local_fig);

%%
[filepath,name,ext] = fileparts(local_fig);
%% Define preffix for figures
preffix=name;
old='_p_th_1_00_corrected_flag_0';
new='';
preffix = strrep(preffix,old,new);

%% Make folder to save new figures
output_folder=[root_path_new_figures filesep 'figures_by_network' filesep preffix];
if ~isfolder(output_folder)
    mkdir(output_folder)
end
%% Read figure content

% First load the figure

ch=get(gcf,'children');
n=size(ch,1);
n=size(ch,1)-1;

% from systems*(systems+1)/2=npanels
r=roots([1 1 -2*n])';
n_networks=r(r>0);
n_networks=floor(n_networks);
% n_sq=ceil(sqrt(n));

s=cell(n,1);



%
kk=0;
for i=1:n_networks
    for j=i:n_networks
        k=sub2ind([n_networks n_networks],i,j);
        kk=kk+1;
        s{kk}=subplot(n_networks,n_networks,k);
        try
        s{kk}.Children(1).String=[];
        end
        local_xtl=s{kk}.XTickLabel;
        if ~isempty(local_xtl)
            xtl=local_xtl;
        end
    end
end

%% Optimize size
fig_title=s{kk}.Title.String;

fig_name=fig_title(1);
fig_name=fig_name{:};
fig_name(fig_name==' ')='_';

local_ix=find(fig_name==')');
fig_name=fig_name(local_ix+2:end);

vis_flag='on';

fig_size=[8 8  4 4];% cm
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'name',fig_name,...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);

copyobj(s{kk},f)
delta=0.2;
% set(gca,'position',[delta delta 1-2*delta 1-2*delta])
%

BottomSpace = .12;
TopSpace = 0.2;
LeftSpace=0.3;
RightSpace=0.05;
hight=1;
R=1;
C=1;
BetweenV=0;
BetweenH=0;

k=ones(2,1);
rsel = mod(ceil(k(1)/C-1),R);
csel = mod(k(1)-1,C);
H = (1 - TopSpace-BottomSpace - BetweenV*(R-1))/R;H;
W = (1 - LeftSpace-RightSpace - BetweenH*(C-1))/C;W=W*(diff(k)+1);
B = BottomSpace + (R - rsel -1)*(H+BetweenV);
L = LeftSpace + csel*(W/(diff(k)+1)+BetweenH);

p = [L B W H*hight];
set(gca,'position',p)
xl=xlim;
set(gca,'xlim',[0 xl(2)])
%% Make individual sub-panels

for k=1:n
    
    fig_title=s{k}.Title.String;
    
    fig_name=fig_title(1);
    fig_name=fig_name{:};
    fig_name(fig_name==' ')='_';
        
    vis_flag='on';
    clf
    copyobj(s{k},f)
    
    %         set(gca,'position',[delta delta 1-2*delta 1-2*delta])
    set(gca,'position',[delta delta/2 1-1.5*delta 1-1.5*delta])
    set(gca,'position',p)
    
    xl=xlim;
    set(gca,'xlim',[0 xl(2)])
    ylabel('');
    xlabel('')
    set(gca,'xticklabel',xtl)
    
%     title(fig_title{2})
    fig_name=[preffix '_' fig_name];
    set(f,'name',fig_name)
    f.InvertHardcopy = 'off';
    saveas(gcf,[output_folder filesep fig_name])
    print([output_folder filesep fig_name],'-dtiffn','-r1000')
end


