function [R, pR, df, SS, MS, F, p]=test_slopes(local_y,meanx,g)

[foo,ix]=sortrows(g);

x=meanx(ix);
y=local_y(ix);
species=foo;

ix_in=and(~isnan(y),~isnan(x));
x=x(ix_in);
y=y(ix_in);
species=species(ix_in);



DX=species;
[R pR]=corr(x,y,'Type','Spearman');


[h,atab,ctab,stats] = aoctool(y,x,DX,0.05,...
    '','','','off','separate lines');


df=atab{end-1,2};
SS=atab{end-1,3};
MS=atab{end-1,4};
F=atab{end-1,5};
p=atab{end-1,6};