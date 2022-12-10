function T=summarize_parcel(parcel)


n=size(parcel,2);
% [num2str([1:n]') repmat(') ',n,1) cat(1,char(parcel.name)) repmat(', n = ',n,1) num2str(cat(1,parcel.n))]

text=[num2str([1:n]') repmat(') ',n,1) cat(1,char(parcel.name)) repmat(' (',n,1) cat(1,char(parcel.shortname)) repmat('), n = ',n,1) num2str(cat(1,parcel.n))];
n_rois=sum(cat(1,parcel.n));
text2=repmat('_',1,size(text,2));
text3=['Total = ' num2str(n_rois) ' ROIs'];
disp(text);
disp(text2);
disp(text3);
if nargout>0
    T=table(cellstr(text));
    T.Properties.VariableNames{1}='summary';
end