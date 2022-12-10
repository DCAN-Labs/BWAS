function [between_design,within_design]=colorize_design_groups(between_design,within_design,Group_Color_Table)

%% Count subgroups
nb=size(between_design,2);
mb=zeros(nb,1);
for i=1:nb
    mb(i)=size(between_design(i).subgroups,2);
end

nw=size(within_design,2);
mw=zeros(nw,1);
for i=1:nw
    mw(i)=size(within_design(i).subgroups,2);
end

%% Define colormap
my_color=jet(sum(mb)+sum(mw));


%% Apply colormap

if nargin<3
    k=0;
    for i=1:nb
        for j=1:mb(i)
            k=k+1;
            between_design(i).subgroups(j).color=my_color(k,:);
        end
    end
    
    for i=1:nw
        for j=1:mw(i)
            k=k+1;
            within_design(i).subgroups(j).color=my_color(k,:);
        end
    end
else
   k=0;
    for i=1:nb
        for j=1:mb(i)
            k=k+1;
            ix=find(ismember(Group_Color_Table{:,1},between_design(i).subgroups(j).name));
            local_color=table2array(Group_Color_Table(ix,2:end));
            local_color(local_color<0)=0;
            local_color(local_color>1)=1;
            between_design(i).subgroups(j).color=local_color;
        end
    end
    
    for i=1:nw
        for j=1:mw(i)
            k=k+1;
            ix=find(ismember(Group_Color_Table{:,1},within_design(i).subgroups(j).name));
            local_color=table2array(Group_Color_Table(ix,2:end));
            local_color(local_color<0)=0;
            local_color(local_color>1)=1;
            within_design(i).subgroups(j).color=local_color;
        end
    end
end