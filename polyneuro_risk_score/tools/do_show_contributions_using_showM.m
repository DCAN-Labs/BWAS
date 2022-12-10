function do_show_contributions_using_showM(M,parcel,varargin)

%% Define defaults

tit=[];

output_folder=pwd;

fs=filesep;
%% Read additional arguments

%% Read extra options, if provided

v = length(varargin);
q=1;
while q<=v
    switch lower(varargin{q})
        
        case 'tit'
            tit=varargin{q+1};
            q = q+1;
            
        case 'output_folder'
            output_folder=varargin{q+1};
            q = q+1;
            
            
        otherwise
            disp(['Unknown option ',varargin{q}])
    end
    q = q+1;
end
%%
n=size(parcel,2);
countM=zeros(n);
ALL=zeros(n);
R=zeros(n);
%% Set diagonal to zero
ix=find(eye(size(M,1)));
M(ix)=0;
%%
reduced_parcel=parcel;
for i=1:n
    ix1=parcel(i).ix;
    for j=1:n
        ix2=parcel(j).ix;
        local_data=M(ix1,ix2);
        if i==j
            ix_to_kill=find(eye(parcel(i).n));
            local_data(ix_to_kill)=[];
        end
        countM(i,j)=sum(local_data(:));
        ALL(i,j)=numel(local_data);
    end
    reduced_parcel(i).ix=i;
    reduced_parcel(i).n=1;
end

% R=countM./ALL;
R=countM/sum(countM(:));
ref=ALL/(sum(ALL(:)));
% RR=R./(ALL/(sum(ALL(:))));
RR=R-ref;
R=RR;
clims=[-0.01 0.01];
my_color='RG';
force_diag_to_be_zero_flag=0;
H=showM(R,...
    'parcel',reduced_parcel,...
    'line_color',[0 0 0],...
    'line_width',1,...
    'fs_axis',10,...
    'fig_wide',7,...
    'one_side_labels',1,...
    'clims',clims,...
    'force_diag_to_be_zero_flag',force_diag_to_be_zero_flag,...
    'fig_tall',8,...
    'half','low');
imagesc(R,clims)
set(gca,'xtick',1:n)
set(gca,'ytick',1:n)
set(gca,'xticklabel',cat(1,reduced_parcel.shortname))
set(gca,'yticklabel',cat(1,reduced_parcel.shortname))
xtickangle(90)
xl=xlim;
yl=ylim;
for i=xl(1):xl(end)-1
    j=i;
    line(xl,[j j],'color','k')
    line([j j],yl,'color','k')
end

patch(xl([1 2 2 ]),yl([1 2 1]),'w')
line(xl,yl([1 1]),'color','w')
line(xl([2 2]),yl,'color','w')
box off
if ~isempty(tit)
    set(gca,'position',[0.1500    0.2500    0.720    0.680])
    t=title(tit);
end

%% save
replace_old_new={'%','percent'};
figname=title2filename({tit},'replace_old_new',replace_old_new);
figname=[output_folder fs figname];
saveas(gcf,figname)
print(figname,'-dpng','-r300')
print(figname,'-dtiffn','-r300')