function my_color=Extract_my_color_from_T_color(Tcolor,Tvar)


%%
[n_rows, n_cols]=size(Tvar);
IX=nan(n_rows,1);
for i=1:n_rows
    IX(i)=find(ismember(Tcolor.shortname,Tvar.Properties.RowNames{i}));
end
%%
Tcol=Tcolor(IX,:);


my_color=Tcol.RGB;