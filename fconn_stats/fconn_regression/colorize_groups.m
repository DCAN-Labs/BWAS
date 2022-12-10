function g=colorize_groups(group,pallete)


n=size(group,1);
RGB=zeros(n,3);

all_groups=cat(1,pallete.group);

for i=1:n   
    j=find(ismember(all_groups,group{i,1}));
    RGB(i,:)=pallete(j).color;
end

g=[group array2table(RGB)];