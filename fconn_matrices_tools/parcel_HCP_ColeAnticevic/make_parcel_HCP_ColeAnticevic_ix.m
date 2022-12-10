
addpath(genpath('P:\code\internal\utilities\OSCAR_WIP\'))
%%
cd 'P:\code\internal\utilities\OSCAR_WIP\fconn_matrices_tools\parcel_HCP_ColeAnticevic'
clc
Dictionary_filename='dictionary_HCP_ColeAnticevic_names.csv';
tidyData_filename='HCP_ColeAnticevic_names.csv';
[T, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);

%%
Dictionary_filename='dictionary_HCP_ColeAnticevic_ix.csv';
tidyData_filename='HCP_ColeAnticevic_ix.csv';
[ix, Dictionary] = import_tidyData_with_Dictionary(Dictionary_filename,tidyData_filename);
ix=ix{:,1};
%%
n=size(T,1);
parcel(n).name=[];
parcel(n).shortname=[];
parcel(n).RGB=[];
for i=1:n
    parcel(i).name=T.name(i,:);
    parcel(i).shortname=T.shortname(i,:);
    parcel(i).RGB=T{i,end-2:end}/255;
    local_ix=find(ix==i);
    parcel(i).ix=local_ix;
    parcel(i).n=numel(local_ix);
end
summarize_parcel(parcel)
%% Resort by name
rT=sortrows(T,3);
new_ix=rT{:,1};
new_ix(10)=[];
new_ix(end+1)=n

newparcel=parcel;
for i=1:n
    newparcel(i)=parcel(new_ix(i));
end
summarize_parcel(newparcel)

%%
parcel=newparcel;
save('HCP_ColeAnticevic.mat','parcel')
%%
load('V:\FAIR_HORAK\Projects\Martina_RO1\standard\Functional\List_MCMethod_power_2014_FD_only_FD_th_0_20_min_frames_150_skip_frames_5_TRseconds_2_00\HCP_subcortical\fconn_all_surv_frames.mat')

M=get_mean_M(fconn);
delta=.01;
clims=get_ptiles_M(M,delta);
showM(M,'parcel',parcel,'clims',clims)
%%
combined_parcel=parcel;
combined_parcel(12)=[];
combined_parcel(11).ix=sort(cat(1,parcel(11).ix,parcel(12).ix));
combined_parcel(11).n=length(combined_parcel(11).ix);
combined_parcel(11).name='Visual';
combined_parcel(11).shortname='Vis';
summarize_parcel(combined_parcel)
showM(M,'parcel',combined_parcel,'clims',clims)

save('HCP_ColeAnticevic.mat','parcel','combined_parcel')
