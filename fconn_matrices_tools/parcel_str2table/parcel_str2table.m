function T = parcel_str2table(parcel)
%% T = parcel_mat2table(parcel)
%% Oscar Miranda-Dominguez
% First line of code: Sept 10, 2020
% Use this function to generate a table from a parcel object

%% Read size and pre-allocate memory
n_parcels=numel(parcel);

index=cat(1,parcel.ix);
n_ROIS=numel(unique(index));
name=cell(n_ROIS,1);
shortname=cell(n_ROIS,1);
RGB=zeros(n_ROIS,3);
G=zeros(n_ROIS,1);
B=zeros(n_ROIS,1);
%% Unfold data

for i=1:n_parcels
    ix=parcel(i).ix;
    n=parcel(i).n;
    for j=1:n
        name{ix(j)}= parcel(i).name;
        shortname{ix(j)}= parcel(i).shortname;
        RGB(ix(j),:)= parcel(i).RGB;
    end
end

name=char(name);
shortname=char(shortname);

R=RGB(:,1);
G=RGB(:,2);
B=RGB(:,3);

%% Make table
% ix=index;
ix=[1:n_ROIS]';
T = table(ix,name,shortname,R,G,B);
T = sortrows(T)
