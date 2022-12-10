function save_model(filepath,model,filename)

% Oscar Miranda-Dominguez
fs=filesep;
if nargin<3
    filename='model';
end

if ~isfolder(filepath)
    mkdir(filepath)
end

save([filepath fs filename '.mat'],'model')
fid = fopen([filepath fs filename '.txt'],'wt');
fprintf(fid, model);
fclose(fid);