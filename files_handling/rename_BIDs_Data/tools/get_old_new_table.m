function [new unique_new unique_old]=get_old_new_table(old,preffix,suffix)
%% Oscar Miranda-Dominguez

n=size(old,1);
unique_old=unique(old);
n_unique_old=numel(unique_old);
if n_unique_old<10
    flag_format=[];
else
    flag_format=['%0' num2str(ceil(log10(n_unique_old))) '.f'];
end
unique_new=[repmat(preffix,n_unique_old,1) num2str([1:n_unique_old]',flag_format) repmat(suffix,n_unique_old,1)];
unique_new=cellstr(unique_new);
new=cell(n,1);
for i=1:n_unique_old
    ix=ismember(old,unique_old(i));
    new(ix)=unique_new(i);
end
