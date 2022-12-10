function integer_ticks()


%% Use this function to only display ticks on integers
xt=get(gca,'xtick');
ix_ix_prep=rem(xt,round(xt));
ix=ix_ix_prep==0;
xt_to_keep=xt(ix);
set(gca,'xtick',xt_to_keep)