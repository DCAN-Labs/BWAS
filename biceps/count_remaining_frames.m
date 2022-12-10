function handles = count_remaining_frames(handles)
n=handles.participants.N;
motions=handles.mc.motions;
skip=handles.mc.skip;
n_ar=handles.connectotyping_settings.n_ar;
n_surv_frames=zeros(n,2);
tick=handles.mc.tick;
surv_std=cell(n,1);
surv_mb=cell(n,1);
handles.mc.min_frames=floor(handles.mc.min_time_minutes*60/handles.mc.TR);

for i=1:n
    frames=handles.mc.frames{i};
    n_resting=length(frames);
    skip_mask=[];
    ar_mask=[];
    for j=1:n_resting
        dummy=zeros(frames(j),1);
        n_dummy=length(dummy);
        dummy_skip=dummy;
        dummy_ar=dummy;
        %         dummy_skip(1:j)=1;
        up_to=min(n_dummy,skip);
        dummy_skip(1:up_to)=1;
        skip_mask=[skip_mask; dummy_skip];
        
        up_to=min(n_dummy,n_ar);
        dummy_ar(1:up_to)=1;
        ar_mask=[ar_mask; dummy_ar];
    end
    
    if motions(1)
        surv_std{i,1}=~skip_mask;
        surv_mb{i,1}=~double(or(skip_mask,ar_mask)); 
    else
        dummy=handles.mc.frame_removal{i};
        dummy=dummy(tick,:);
        temp=or(dummy(:),skip_mask(:));
        surv_std{i,1}=~temp;
        
        temp=or(temp(:),ar_mask(:));
        surv_mb{i,1}=~temp;
    end
    
    n_surv_frames(i,1)=sum(surv_std{i,1});
    n_surv_frames(i,2)=sum(surv_mb{i,1});
end
handles.mc.surv_std=surv_std;
handles.mc.surv_mb=surv_mb;
handles.mc.n_surv_frames=n_surv_frames;
handles.mc.surv_ix=n_surv_frames>handles.mc.min_frames;
