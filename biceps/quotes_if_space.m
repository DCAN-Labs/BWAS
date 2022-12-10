function A=quotes_if_space(A)

if A(1)=='"'
else
    if sum(ismember(A,' '))>0
        
        A=['"' A '"'];
        
    end
end