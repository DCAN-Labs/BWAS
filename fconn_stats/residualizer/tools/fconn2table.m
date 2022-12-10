function [Y, imaging_type, ind, sz, BrainFeatures_table,subject_fconn_sample] = fconn2table(fconn,options)

%%
[r,c,h]=size(fconn);
if h==1
    n=c;
    imaging_type='2D';
    subject_fconn_sample=fconn(1,:);
else
    n=r;
    imaging_type='3D'; 
    subject_fconn_sample=squeeze(fconn(:,:,1));
end
sz=[r c];
%%
if strcmp(imaging_type,'2D')
    T = fconn;
    ind=(1:c)';
    n_connections=numel(ind);
end

%%
if strcmp(imaging_type,'3D')
    
    % Calculate the mask
    I=eye(r);
    mask=~I;
    
    if options.symmetrize==1
        mask=triu(mask);
    end
    ind=find(mask);
    
    n_connections=numel(ind);
    
    % Pre-allocate memory for table
    T=zeros(h,n_connections);
    
    % Populate the table
    for i=1:h
        local_M=squeeze(fconn(:,:,i));
        T(i,:)=local_M(ind);
    end
    
end
Y=T;
Y=array2table(Y);

BrainFeatures_table=table((1:n_connections)','VariableNames',{'BrainFeature'});