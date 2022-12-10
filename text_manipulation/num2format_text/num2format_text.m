function text_array=num2format_text(num_array,res)


%% using 2 decimals as default resolution
if nargin<2
    res='0.2';
end
%%

[r,c]=size(num_array);
text_array=cell(r,c);

%% res needs to be provided as number dot number

delimiter='.';
newStr = split(res,delimiter);

n_newStr=size(newStr,1);
if n_newStr>1
    pot=str2num(newStr{end});
    
    frac_th=10^(-pot);
end
%%

for i=1:r
    for j=1:c
               
        if n_newStr>1
            
            local_num=num_array(i,j);
            formatSpec=['%4.' num2str(pot) 'f'];
            
            if abs(local_num)<=frac_th
%                 formatSpec=['%4.' num2str(pot) 'e'];
                formatSpec=['%4.' num2str(1) 'e'];
            end
            
            if abs(local_num)<=realmin
                formatSpec=['%4.' num2str(pot) 'f'];
            end
            local_text=num2str(local_num,formatSpec);
            text_array{i,j}=local_text;
            
            
        end
    end
end

text_array=char(text_array);