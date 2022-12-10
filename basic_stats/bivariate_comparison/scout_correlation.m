function [Mcount, MM, MNC]=scout_correlation(CC,bin,RGB1,RGB2,plot_option)
%% This function plots a node link distribution, plotting the number of links as a function of ranks. It is inspired in the figure 2 from the paper Zhou's paper (see References section.). This function additionally color each bin according to iuts strength.
% Arguments:
% CC, Correlation matrix, this has to be the thresholded correlation matrix
% bin, represents the number of bins to be used for display
% RGB1, optional argument 1. Corresponds to the RGB value of color 1 for
% display
% RGB2, optional argument 2. Corresponds to the RGB value of color 2 for
% display

%%Created by Oscar Miranda-Dominguez, as Postdoc @ Fair's lab.
% Date of creation: Nov 9, 2012.

%% Preliminary data

if nargin<5
    plot_option=1;
end
if or(nargin<3,or(isempty(RGB1),isempty(RGB2)))
    RGB1=[1    0.0703    0.1016];
    RGB2=[0.7930    0.7031    0.1562];
    RGB2=[0    0.7031    0.1562];
end
if nargin<2
    bin=20;
end
colorbins=128;% Number of bins for the colormap
ticks=zeros(bin,1);

%% Calculate nodes and nodes per bin

n=length(CC);%number of nodes
npb=ceil(n/bin);  %determines the number of sources nodes per bins;
%% Begin function




%% Sorting the matrix as a function of the number of connections (binary matrix)

CCbin=double(CC~=0);
R1=sum(CCbin,2);
R2=sum(CCbin,1);
[~, x1]=sort(R1,'descend');
[~, x2]=sort(R2,'descend');
Cs=CC(:,x2);
Css=Cs(x1,:);
survivors=Css(Css~=0);



%% If symmetric, get rid of duplicate information and re-sort

%% If symmetric, get rid of duplicate information and re-sort
X=CC-(CC+CC')/2;
% mean(X(:))
% std(X(:))
test_symmetry=max(abs(X(:)));

if test_symmetry<1e-6
    srM=Css.*tril(ones(n),-1);%sorted raw Matrix
    
else
    srM=Css;
end
sbM=srM~=0;%sorted binary Matrix

MM=zeros(bin,bin,npb^2);% This 3D array will save the ranks (x,y) and the corresponding weights
Mcount=zeros(bin,bin);% this will keep record of the number of cells per bin
MNC=zeros(bin,bin);

ix=1:npb:n;
ix2=ix(2:end)-1;
ix2(end+1)=n;

% n_bin=ix2-ix;
bin_real=length(ix);
for i=1:bin_real
    for j=1:bin_real
        local_ix1=ix(i):ix2(i);
        local_ix2=ix(j):ix2(j);
        
        if i==j
            mnc=length(local_ix1)*(length(local_ix2)-1)/2;
        else
            mnc=length(local_ix1)*(length(local_ix2));
        end
        MNC(i,j)=mnc;
        Mcount(i,j)=sum(sum(sbM(local_ix1,local_ix2) ));
        
        dummy=srM(local_ix1,local_ix2);
        dummy(dummy==0)=[];
        MM(i,j,1:length(dummy(:)))=sort(dummy(:));
        %     Mcount(i,j)=CC(x1(ix1(i)):x1(ix2(i))
    end
end



%% Create colormap

% HSV1=rgb2hsv(RGB1);
% HSV2=rgb2hsv(RGB2);
% r1=linspace(HSV1(end),0,colorbins/2);
% r2=linspace(0,HSV2(end),colorbins/2);
%
% % r1=-logspace(log10(HSV1(end)),-8,colorbins/2)+linspace(HSV1(end),0,colorbins/2);r1(end)=0;
% % r2=-logspace(-8,log10(HSV2(end)),colorbins/2)+linspace(0,HSV2(end),colorbins/2);r2(1)=0;
%
% custom_map=zeros(colorbins,3);
% custom_map(1:colorbins/2,:)=repmat(HSV1,colorbins/2,1);
% custom_map(colorbins/2+1:end,:)=repmat(HSV2,colorbins/2,1);
% custom_map(1:colorbins/2,end)=r1;
% custom_map(colorbins/2+1:end,end)=r2;
% custom_map=hsv2rgb(custom_map);
custom_map=jet(colorbins);
% custom_map(round(colorbins/2),:)=[0 0 0];
range_cc=linspace(min(survivors)-.01,max(survivors)+.01,colorbins);

%% Create the plot (*)
if plot_option==1
    %% to do
    % axes(handles.axes1)
    % range_hist=linspace(min(Mean_mat_weight(:))-.01,max(Mean_mat_weight(:))+.01,handles.bin);
    % [n, x]=hist(Mean_mat_weight(:),range_hist);
    % bar(x,n,'w');
    % hold on
    % [n, x]=hist(survivors,range_hist);
    % bar(x,n,'r');
    % hold off
    % legend('Original','Survivors')
    % xlabel('Correlations')
    % ylabel('Abundance')
    % title('Distribution of correlations','fontsize',14);
    %
    % axes(handles.axes2)
    % stairs(sort(sum(Mean_mat_bin,2),'descend'),'r')
    % xlabel('Rank')
    % ylabel('Connections')
    % title('Connections per node','fontsize',14)
    % handles.output = hObject;
    % axes(handles.axes1)
    % range_hist=linspace(min(Mean_mat_weight(:))-.01,max(Mean_mat_weight(:))+.01,handles.bin);
    % [n, x]=hist(Mean_mat_weight(:),range_hist);
    % bar(x,n,'w');
    % hold on
    % [n, x]=hist(survivors,range_hist);
    % bar(x,n,'r');
    % hold off
    % legend('Original','Survivors')
    % xlabel('Correlations')
    % ylabel('Abundance')
    % title('Distribution of correlations','fontsize',14);
    %
    % axes(handles.axes2)
    % stairs(sort(sum(Mean_mat_bin,2),'descend'),'r')
    % xlabel('Rank')
    % ylabel('Connections')
    % title('Connections per node','fontsize',14)
    % handles.output = hObject;
    figure
    % figure('Visible','on',...
    %         'name','ROC',...
    %         'Position',[680   662   747   647],...
    %         'color','w');
    subplot 231
    [b, x]=hist(survivors,bin);
    xbin=(x(2)-x(1))/1.05;
    for k=1:bin
        c_hist=(custom_map(find(range_cc>x(k),1),:));
        if isempty(c_hist)
            c_hist=[1 1 1];
        end
        plotcube([xbin xbin b(k)],[x(k)-xbin/2 0 0],.8,c_hist)
        
    end
    xlim([x(1)-xbin x(end)+xbin])
    xlabel('Strength connection')
    zlabel('Abundance')
    title('Distribution of correlations across connections');
    view(0,0)
    box on
    % dummy=x([1 end/2 end])';
    % if length(unique(dummy))<3
    %     dummy=x([1 end])';
    % end
    %
    % set(gca,...
    %     'xtick',dummy,...
    %     'xticklabel',num2str(dummy,'%4.3f'));
    
    %%
    subplot 234
    
    
    xx=sort(xx,'descend');
    % for k=1:n
    %     xx(:,n-k+1)=sort(M(k,:),'descend');
    % end
    xx=xx(end:-1:1,:);
    Mbin=double(and((xx~=0),~(isnan(xx))));
    R3=sum(Mbin,1);
    
    if min(survivors)~=max(survivors)
        imagesc(xx,[min(survivors) max(survivors)])
    else
        imagesc(xx,[range_cc(1) range_cc(end)])
    end
    set(gca,'ydir','normal')
    colormap(custom_map)
    
    hold on
    h2_ylim=get(gca,'ylim');
    h2_xlim=get(gca,'xlim');
    
    Y=R3(1:n)+.5;
    YY=repmat(Y,2,1);
    YY=YY(:);
    YY=[h2_ylim(2) h2_ylim(2) YY' ];
    
    XX=h2_xlim(1):1:h2_xlim(2);
    XX=repmat(XX,2,1);
    XX=XX(:);
    XX=circshift(XX,1)';
    % XX=[h2_xlim(1) XX' h2_xlim(2)];
    
    patch(XX,YY,[1 1 1]);
    
    if n<20
        for k=1:n
            line([0.5 0.5]+(k),[0.5 Y(k)],'color',[1 1 1]*0)
        end
    end
    hold off
    %%
    ylim([h2_ylim(1) min(max(YY),4*ceil(R3(1)/4))])
    xlabel('Nodes sorted by Rank')
    ylabel('# of connections')
    ytick=get(gca,'ytick');
    ytick=ytick(mod(ytick,1)==0);
    set(gca,'ytick',ytick)
    xtick=get(gca,'xtick');
    xtick=xtick(mod(xtick,1)==0);
    set(gca,'xtick',xtick)
    box on
    
    %%
    subplot(2,3,[2 6])
    for i=1:bin
        ticks(i)=i*5+.5;
        for j=1:bin
            if Mcount(i,j)==0
                plotcube([1 1 .01],[ i*5 j*5 1],.9,[0 0 0]);
                plotcube([.9 .9 .009],[ i*5+.05 j*5+.05 1+.005],.9,[1 1 1]);
            else
                for k=1:Mcount(i,j)
                    %             plotcube([1 1 1],[ i*2 j*2 k],.9,rand(1,3));
                    plotcube([1 1 1],[ i*5 j*5 k-1],.9,custom_map(find(range_cc>MM(i,j,k),1),:));
                end
            end
        end
    end
    
    % view([1 1.5 1])
    view(110,20)
    view (70,20)
    % axis tight
    box on
    grid
    xlabel ('Rank (%)')
    ylabel ('Rank (%)')
    zlabel ('Abundance')
    % set(gca,'xtick',ticks,'xticklabel',num2str(linspace(100/bin,100,bin)))
    %%
    colormap(custom_map)
    colorbar;
    
    dummy=0:.2:1;
    set(colorbar,'yticklabel',num2str(linspace(min(survivors),max(survivors),11)','%4.2f'))
    
    set(gca,'xtick',linspace(0,ticks(end),6),'xticklabel',num2str(100*dummy','%4.0f'))
    set(gca,'ytick',linspace(0,ticks(end),6),'yticklabel',num2str(100*dummy','%4.0f'))
    % set(gca,'xtick',ticks,'xticklabel',num2str(linspace(100/bin,100,bin)','%4.1f'))
    % set(gca,'ytick',ticks,'yticklabel',num2str(linspace(100/bin,100,bin)','%4.1f'))
end
%% (*) Note that I am using the function plotcube. This function was created by Thomas Montagnon and I downloaded from Matlab Central. Here is the code of the function
% function plotcube(varargin)
% % PLOTCUBE - Display a 3D-cube in the current axes
% %
% %   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
% %   with the following properties:
% %   * EDGES : 3-elements vector that defines the length of cube edges
% %   * ORIGIN: 3-elements vector that defines the start point of the cube
% %   * ALPHA : scalar that defines the transparency of the cube faces (from 0
% %             to 1)
% %   * COLOR : 3-elements vector that defines the faces color of the cube
% %
% % Example:
% %   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0]);
% %   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0]);
% %   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]);
%
% % Default input arguments
% inArgs = { ...
%   [10 56 100] , ... % Default edge sizes (x,y and z)
%   [10 10  10] , ... % Default coordinates of the origin point of the cube
%   .7          , ... % Default alpha value for the cube's faces
%   [1 0 0]       ... % Default Color for the cube
%   };
%
% % Replace default input arguments by input values
% inArgs(1:nargin) = varargin;
%
% % Create all variables
% [edges,origin,alpha,clr] = deal(inArgs{:});
%
% XYZ = { ...
%   [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
%   [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
%   [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
%   [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
%   [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
%   [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
%   };
%
% XYZ = mat2cell(...
%   cellfun( @(x,y,z) x*y+z , ...
%     XYZ , ...
%     repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...
%     repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
%     'UniformOutput',false), ...
%   6,[1 1 1]);
%
% %% plot edges
% % cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
% %   repmat({clr},6,1),...
% %   repmat({'FaceAlpha'},6,1),...
% %   repmat({alpha},6,1)...
% %   );
%
% %% No edges
% cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
%   repmat({clr},6,1),...
%   repmat({'FaceAlpha'},6,1),...
%   repmat({alpha},6,1),...
%   repmat({'EdgeColor'},6,1),...
%   repmat({clr},6,1));
%
%
%
% view(3);

%% References
% Zhou, S., & Mondragon, R. J. (2004). The Rich-Club Phenomenon in the Internet Topology. IEEE Communications Letters, 8(3), 180?182. doi:10.1109/LCOMM.2004.823426