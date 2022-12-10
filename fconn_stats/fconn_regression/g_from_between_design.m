function g=g_from_between_design(main_table,between_design)


group=main_table(:,1);
n=size(between_design(1).subgroups,2);

pallete(n).group=[];
pallete(n).color=[];

for i=1:n
    pallete(i).group=between_design(1).subgroups(i).name;
    pallete(i).color=between_design(1).subgroups(i).color;
end

g=colorize_groups(group,pallete);