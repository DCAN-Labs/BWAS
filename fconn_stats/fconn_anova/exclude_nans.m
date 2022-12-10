function [main_table_no_nans,y_no_nans]=exclude_nans(main_table,y)

X=main_table{:,2:end};
X=sum(isnan(X),2);
ix_nan=or(isnan(y),isnan(X));

main_table_no_nans=main_table(~ix_nan,:);
y_no_nans=y(~ix_nan,:);