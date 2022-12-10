function saveall_planB()
vars=whos;
%%
n=size(vars,1);
for i=1:n
    name=vars(i).name;
    filename=[name '.mat'];
    text_to_eval=['save_planB(filename,' name ');'];
    evalc(text_to_eval);
end
