function my_color=local_get_my_color(localT,Group_Color_Table)


glabs_to_show=unique(localT{:,1});
ix_temp=find(ismember(Group_Color_Table{:,1},glabs_to_show));
Group_Color_Table=Group_Color_Table(ix_temp,:);

Group_Color_Table=sortrows(Group_Color_Table,1);
my_color=Group_Color_Table{:,2:end};