function save_planB(filename,data)

keep_trying=1;
s = inputname(2);
eval([s '= data;']);

% get size of the variable to determine how to save
temp=whos('data');
data_inGB=temp.bytes*1e-9;
gt_2GB_flag=data_inGB>1.9;

% Save as default
if gt_2GB_flag==0
    save(filename,s);
    keep_trying=0;
else
    try
        % Save as version 7.3
        save(filename,s,'-v7.3')
        keep_trying=0;
    end
end


% Save individually
if keep_trying==1
    try
%         disp('Trying saving data individually')
        [filepath,name,ext] = fileparts(filename);
        N=size(data);
        if iscell(data)
            n=N(1);
        else
            n=N(end);
        end
        
        for i=1:n
            new_name=[name '_' num2str(i)];
            new_filename=[filepath filesep new_name ext];
            if iscell(data)
                new_data=data(i,:);
            else
                new_data=squeeze(data(:,:,i));
            end
            eval([s '= new_data;']);
            save(new_filename,s)
        end
    catch
        disp([filename 'could not be saved'])
        
    end
end