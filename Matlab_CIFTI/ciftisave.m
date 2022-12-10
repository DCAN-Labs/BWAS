function [ output_args ] = ciftisave(cifti,filename,caret7command)
%Save a CIFTI file as a GIFTI external binary and then convert it to CIFTI


save(cifti,[filename '.gii'],'ExternalFileBinary')


%unix(['/media/1TB/matlabsharedcode/ciftiunclean.sh ' filename '.gii ' filename '_.gii']);

%unix(['mv ' filename '_.gii ' filename '.gii']);


unix([caret7command ' -cifti-convert -from-gifti-ext ' filename '.gii ' filename]);


try
    delete([filename '.gii']);
    delete([filename '.dat']);
catch
    unix([' /bin/rm ' filename '.gii ' filename '.dat ']);
end

end

