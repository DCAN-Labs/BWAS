function [fconn_top, parcel, ix_cat] = rank_brain_features(Y,R,options)

%% Read explained variance to rank weights

R_Adjusted=R.Adjusted;

%% Sort R_Adjusted

[B,ix]=sort(R_Adjusted,'descend');

%% Count number of brain features
[n, n_brain_features]=size(Y);

%% Find top indices

if isfield(options,'percentile')
    options.top_features=round(options.percentile*n_brain_features/100);
    options.top_features=[1 options.top_features];
end
top_features=options.top_features;

% truncate top features
top_features(top_features>n_brain_features)=[];

n_top_features=numel(top_features);
%% encapsulate fconn
IX=cell(n_top_features,1);
for i=1:n_top_features
    IX{i}=[1:top_features(i)]';
end
ix_all=cat(1,IX{:});
ix_cat=ix(ix_all);
fconn_top=Y(:,ix_cat);

%% make parcel
shortnames=set_axis_label(top_features);


parcel(n_top_features).name=[];
parcel(n_top_features).shortname=[];
parcel(n_top_features).ix=[];
parcel(n_top_features).n=[];
parcel(n_top_features).RGB=[];

old=' ';
new='0';
RGB=jet(n_top_features);
RGB=RGB(end:-1:1,:);
offset=[0 cumsum(top_features)];

for i=1:n_top_features
    parcel(i).name=['top ' shortnames(i,:) ' brain features'];
%     temp=['top_' shortnames(i,:)];
    temp=[shortnames(i,:)];
    temp = strrep(temp,old,new);
    parcel(i).shortname=temp;
    temp_ix=[1:top_features(i)]+offset(i);
    parcel(i).ix=temp_ix';
    parcel(i).n=top_features(i);
    parcel(i).RGB=RGB(i,:);
end