function fconn_same_size_R=blow_fconn_as_provided(fconn,fconn_R,ix_to_include,imaging_type)


%%

fconn_same_size_R=nan(size(fconn));
%% fold 2D
if strcmp(imaging_type,'2D')
      fconn_same_size_R(ix_to_include,:)=fconn_R;
end

%% fold 3D

if strcmp(imaging_type,'3D')
    fconn_same_size_R(:,:,ix_to_include)=fconn_R; 
end
