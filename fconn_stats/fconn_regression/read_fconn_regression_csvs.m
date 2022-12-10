function t=read_fconn_regression_csvs(path_filename)

%%


[num,txt,raw]=xlsread(path_filename);
%%
[r, c]=size(raw);
for i=2:r
    for j=2:c
        if ~isnumeric(raw{i,j})
            raw{i,j}=nan(1);
        end
    end
end


t=cell2table(raw(2:end,:));

    

t.Properties.VariableNames=raw(1,:);
