function H = tsline()
% OScar Miranda-Dominguez
% First line of code Jan 31, 2020

h = findobj(gca,'Type','line');
if isempty(h)
    h = findobj(gca,'Type','scatter');
end


n=size(h,1);
to_kill=zeros(n,1);
for i=1:n
    if numel(h(i).XData)<=2
        to_kill(i)=1;
    end
end
to_kill=to_kill==1;
h(to_kill)=[];

x=get(h,'Xdata');
y=get(h,'Ydata');

n=size(x,1);
lw=1;

xl=xlim;
yl=ylim;
for k=1:n
    try
        X=[x{k}' y{k}'];
    catch
        X=[x(k,:)' y(k,:)'];
    end
    meanX = mean(X,1);
    m=size(X,1);
    [coeff,score,roots] = pca(X);
    basis = coeff(:,1:2);
    
    i=1;
%     for i=1:2
    dirVect = coeff(:,i);
    
    Xfit1 = repmat(meanX,m,1) + score(:,i)*coeff(:,i)';
    %     t = [min(score(:,i))-.2, max(score(:,i))+.2];
    t = [min(score(:,i))-2, max(score(:,i))+2];
    
    endpts = [meanX + t(1)*dirVect'; meanX + t(2)*dirVect'];
%     endpts=[xl' yl([2 1])'];
    
    X1 = [X(:,1) Xfit1(:,1) nan*ones(m,1)];
    X2 = [X(:,2) Xfit1(:,2) nan*ones(m,1)];
    
    local_color=get_color(h(k));
    
    H=line(endpts(:,1),endpts(:,2),'color',local_color,...
        'linewidth',lw);
end
xlim(xl);
ylim(yl);

function local_color=get_color(h)

switch h.Type
    case 'scatter'
        local_color=h.CData;
    case 'line'
        local_color=h.Color;
end
