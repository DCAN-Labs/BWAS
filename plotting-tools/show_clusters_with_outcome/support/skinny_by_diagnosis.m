function skinny_by_diagnosis(T,my_color,yl)

IX_Dx=find_ix_in_header(T,'Diagnosis');
Dx=T{:,IX_Dx};
uniqueDx=unique(Dx);
n_uniqueDx=numel(uniqueDx);
N=nan(n_uniqueDx,1);
%% Get ylims
skinny_plot(T)
axis tight

if nargin<3
    yl=ylim;
    yl=[-1 1]*2.999;
end
n_xl=numel(get(gca,'xtick'));
%%
% if n_uniqueDx==2
%     my_color=[117,112,179
%         27,158,119]/255;
% else
%     switch uniqueDx{1}
%         case 'ADHD'
%             my_color=[117,112,179]/255;
%         case 'Control'
%             my_color=[27,158,119]/255;
%     end
% end


%% Make the figure
i=1;
include_count=0;
use_median_instead_of_mean_flag=1;
dotted_line_flag=0;
linking_line_flag=1;
show_text_flag=0;
ix_in=ismember(Dx,uniqueDx(i));
angle=45;
skinny_plot(T(ix_in,:),repmat(my_color(i,:),n_xl,1),...
    'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
    'dotted_line_flag',dotted_line_flag,...
    'linking_line_flag',linking_line_flag,...
    'show_text_flag',show_text_flag,...
    'yl',yl,...
    'include_count',include_count);
hold on
N(i)=sum(ix_in)/n_xl;

for i=2:n_uniqueDx
    ix_in=ismember(Dx,uniqueDx(i));
    skinny_plot(T(ix_in,:),repmat(my_color(i,:),n_xl,1),...
        'use_median_instead_of_mean_flag',use_median_instead_of_mean_flag,...
        'dotted_line_flag',dotted_line_flag,...
        'linking_line_flag',linking_line_flag,...
        'show_text_flag',show_text_flag,...
        'yl',yl);
    N(i)=sum(ix_in)/n_xl;
end
hold off
yline(0)
xtickangle(angle)

%% add counts
xl=xlim;
xpos=linspace(xl(1),xl(2),2*(2*n_uniqueDx-1)+1);
xpos([1 end])=[];
xpos(2:2:end)=[];
xpos=xpos(1:2:end);

for i=1:n_uniqueDx
    text(xpos(i),yl(2)*1.15,['N = ' num2str(N(i))],...
        'fontsize',8,...
        'color',my_color(i,:),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle')
end