function clr=get_colors(g,Group_Color_Table)

clr=[];
n=size(g,1);
try
if n==sum(ismember(g,Group_Color_Table{:,1}))
    classes=unique(g,'rows','stable');
    ix_in=find(ismember(Group_Color_Table{:,1},classes));
    clr=Group_Color_Table{ix_in,2:end};
%     ng=size(Group_Color_Table,1);
%     clr=nan(n,3);
%     for i=1:ng
%         ix=find(ismember(g,Group_Color_Table{i,1}));
%         clr(ix,:)=repmat(Group_Color_Table{i,2:end},numel(ix),1);
%     end
    
end

end