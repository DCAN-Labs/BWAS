function save_options_as_text(options,filename)

if nargin<2
    filename='options.txt';
end

T=evalc('disp(options)');

fileID = fopen(filename,'w');
fprintf(fileID,'%s', T);
fclose(fileID);