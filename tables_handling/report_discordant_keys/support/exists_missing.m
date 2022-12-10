function report = exists_missing(T)


%% Find existing in key1
ix1=T{:,2};
truncated_T=T(ix1,:);
%% From those, finding missing in key2
ix2=truncated_T{:,3};
ix2=ix2==0;
report=truncated_T(ix2,:);