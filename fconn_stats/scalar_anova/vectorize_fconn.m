function [x, ix_ix, g_network] = vectorize_fconn(fconn,parcel,options)

% Calculate or not Fisher Z transform
if ~isfield(options,'calculate_Fisher_Z_transform') || isempty(options.calculate_Fisher_Z_transform)
    options.calculate_Fisher_Z_transform=1; % Making default =1
end
options.calculate_Fisher_Z_transform=options.calculate_Fisher_Z_transform==1;%% making it binary (==)


%% Resort alphabetically
if isfield(options,'resort_parcel_order')
    temp_ix=options.resort_parcel_order;
else
    temp_ix=1:size(parcel,2);
end
if isempty (temp_ix)
    temp_ix=1:size(parcel,2);
end


[aa bb]=unique(char(parcel(temp_ix).shortname),'rows','sorted');
options.resort_parcel_order=temp_ix(bb');
options.ix_sorting=cat(1,parcel(options.resort_parcel_order).ix);
clear aa bb

%% Options for multiple comparison's correction

%% Resort
ix=options.ix_sorting;
fconn_backup=fconn;
fconn=fconn(ix,ix,:);

sN=size(fconn,3);
n_ROIs=size(ix,1); % Notice this number is read from ix, not from fconn. THis trick is to allow the exclussion of functional networks in options (options.resort_parcel_order), since in options you can specify which networks to include in the analysis
%% Get the crosstalking-names between networks
n_ROIS=size(ix,1);
network=cell(n_ROIS,1);
offset=0;
for i=1:size(options.resort_parcel_order,2)
    j=options.resort_parcel_order(i);
    local_ix=1:parcel(j).n;
    network(local_ix+offset)=cellstr(repmat(parcel(j).shortname,parcel(j).n,1));
    offset=offset+parcel(j).n;
end

[net_mat, net_num, LUT]=get_net_mat(network);
%% reshape the data for n-anova testing

issym=issymmetric(mean(fconn,3)); % determine if the data is symmetric | in connectotyping data is not symmetric
issym=1;
n_feat=n_ROIs*(n_ROIs-1);

if issym
    n_feat=n_feat/2; % remove repeated data
end

ix_ix=zeros(2,n_feat);
x=zeros(sN,n_feat);
g_network=cell(1,n_feat);


k=0;
sq=@(M,i,j) squeeze(M(i,j,:));%inline function to squeeze each 3D matrix

if issym
    for i=1:n_ROIs-1
        for j=i+1:n_ROIs
            k=k+1;
            x(:,k)=sq(fconn,i,j);
            g_network{k}=net_mat{i,j};
            ix_ix(:,k)=[i j];
        end
    end
else
    for i=1:n_ROIs
        for j=1:n_ROIs
            if i~=j
                k=k+1;
                x(:,k)=sq(fconn,i,j);
                g_network{k}=net_mat{i,j};
            end
        end
    end
end
nsg_w=1;
within1=cell2table(repmat(g_network',nsg_w,1));
within1.Properties.VariableNames={'Networks'};

if options.calculate_Fisher_Z_transform
    x=atanh(x); % Fisher Z transform
    display('Doing Fisher Z-transformation')
end