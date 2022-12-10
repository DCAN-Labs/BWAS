function flag =compare_models(prelim_model,model)


prelim_model(prelim_model==' ')='';
model(model==' ')='';
delimiter={' ','-','~','+'};
A=split(prelim_model,delimiter);
B=split(model,delimiter);

A=sort(A);
B=sort(B);
try
    C=strcmp(A,B);
    flag=prod(C);
catch
    flag=0;
end
flag=flag==1;