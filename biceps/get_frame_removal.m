function [FD cat_FD FD_TR]=get_frame_removal(filename,ticks);
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
end

for j=1:ticks
    FD(j)=mot{j}.remaining_frame_count;
end
