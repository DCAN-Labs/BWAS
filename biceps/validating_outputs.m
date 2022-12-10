%%

i=2;% participant
j=3;% surviving frames

k=[3 1 2];
%

parcel='HCP_subcortical';
f=filesep;

list=dir([parcel f 'fconn*']);

load([pwd f parcel f list(k(j)).name])
load([pwd f parcel f 'raw_timecourses.mat'])
%
clc
cellfun(@sum,mask)
ix=find(mask{i,j});


x=raw_tc{i};
whos ix x

R=corr(x(ix,:));
RR=fconn(:,:,i);
corr(R(:),RR(:))

list(k(j)).name
%%
%%

for i=1:2;% participant
    for j=1:3;% surviving frames
        
        k=[3 1 2];
        %
        
        parcel='HCP_subcortical';
        f=filesep;
        
        list=dir([parcel f 'fconn*']);
        
        load([pwd f parcel f list(k(j)).name])
        load([pwd f parcel f 'raw_timecourses.mat'])
        %
        clc
        cellfun(@sum,mask)
        ix=find(mask{i,j});
        
        
        x=raw_tc{i};
        whos ix x
        
        R=corr(x(ix,:));
        RR=fconn(:,:,i);
        corr(R(:),RR(:))
        
        list(k(j)).name
        pause
    end
end