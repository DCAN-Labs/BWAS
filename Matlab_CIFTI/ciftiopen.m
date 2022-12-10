function [ cifti ] = ciftiopen(filename,caret7command)
%Open a CIFTI file by converting to GIFTI external binary first and then
%using the GIFTI toolbox

grot=fileparts(filename);
grot=pwd;% added to save the temporary tmpname "here" (pwd). That file is deleted in line 19 | OM | Nov 9, 2017
if (size(grot,1)==0)
    grot='.';
end
tmpname = tempname(grot);


unix([caret7command ' -cifti-convert -to-gifti-ext ' filename ' ' tmpname '.gii']);



cifti = gifti([tmpname '.gii']);

if ispc
    dos(['del ' tmpname '.gii ' tmpname '.gii.data']);
else
    unix(['rm ' tmpname '.gii ' tmpname '.gii.data']);
end

end

