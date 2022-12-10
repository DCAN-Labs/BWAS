function [ix_in, ix_ol]=check_outliers(y,ol_flag,ol_method)


if ol_flag==1    
    ix_ol=isoutlier(y,ol_method);
else
    ix_ol=zeros(size(y));    
end

ix_ol=ix_ol==1;
ix_in=~ix_ol;
