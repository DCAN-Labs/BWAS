function ylab=downsize_fontsize_additionall_rows(ylab,fontsize)

delta=.5;
if iscell(ylab)
    n=numel(ylab);
    for i=2:n
        ylab{i}=['\fontsize{' num2str(fontsize-i*delta) '}' ylab{i}];
    end
end