function A=quotes_if_space(A)


%% Oscar Miranda-Domínguez
%% Add quotes to filenames if spaces (A windows thing to execute programs using eval or system)
if A(1)=='"'
else
    if sum(ismember(A,' '))>0
        
        A=['"' A '"'];
        
    end
end