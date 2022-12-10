function [FD, cat_FD, FD_TR, frame_removal]=read_motion_data(filename,ticks);
if nargin<2
    ticks=51;
end

load(filename);
try 
    mot=FD_data;
end
try 
    mot=motion_data;
end
cat_FD=mot;
FD_TR=mot{1}.epi_TR;
[r c v]=size(mot);

if v==1
  FD=zeros(1,ticks);
  frame_removal=zeros(c,length(mot{1}.frame_removal));
end

for j=1:ticks
    FD(j)=mot{j}.remaining_frame_count;
    frame_removal(j,:)=mot{j}.frame_removal;
end
