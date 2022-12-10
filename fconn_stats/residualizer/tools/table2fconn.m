function [fconn_R] = table2fconn(R,options, imaging_type, ind, sz)



%% fold 2D
if strcmp(imaging_type,'2D')
    fconn_R=R;
    if isvector(fconn_R)
        fconn_R=fconn_R';
    end   
end

%% fold 3D

if strcmp(imaging_type,'3D')
    n=size(R,1);
    fconn_R=nan(sz(1),sz(2),n);
    
    for i=1:n
        subject_data=R(i,:);
        localR=reformat_fconn(subject_data,options,sz,ind);
        fconn_R(:,:,i)=localR;
    end

    
end

function localR=reformat_fconn(subject_data,options,sz,ind)
localR=nan(sz(1),sz(2));
localR(ind)=subject_data;

if options.symmetrize==1
    [row,col]=ind2sub(sz,ind);
    new_ind=sub2ind(sz,col,row);
    localR(new_ind)=subject_data;
end