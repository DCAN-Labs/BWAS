function ix_in_fconn = get_ix_from_table(T,group)

all_participants=T.group;

ix_temp=find(ismember(all_participants,group,'rows'));
ix_in_fconn=T(ix_temp,:).consecutive_number;