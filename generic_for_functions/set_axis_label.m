function axis_label=set_axis_label(yl)

res=0;

foo=abs(yl);

for i=1:length(foo)
    
    if foo(i)<=eps(1) % stupid floating point error
        foo(i)=0;
    end
    
    temp=num2str(foo(i));
    
    dot_ix=find(temp=='.');
    if isempty(dot_ix)
        temp_res=0;
         if temp_res>res
            res=temp_res;
        end
    else
        temp(1:dot_ix)=[];
        temp_res=length(temp);
        
        if temp_res>res
            res=length(temp);
        end
    end
    
    
end



formatSpec=['%4.' num2str(res) 'f'];


axis_label=num2str(yl',formatSpec);

%% COnflicted, might work better
% res=0;
% foo=abs(yl);
% for i=1:length(foo)
%     
%     if foo(i)<1e-16 % stupid floating point error
%         foo(i)=0;
%     end
%     
%     temp=num2str(foo(i));
%     
%     dot_ix=find(temp=='.');
%     
%     if isempty(dot_ix)
%         temp=[];
%     else
%         temp(1:dot_ix)=[];
%     end
%     
%     temp_res=length(temp);
%     
%     if temp_res>res
%         res=length(temp);
%     end
%     
% end
% 
% 
% 
% formatSpec=['%4.' num2str(res) 'f'];
% 
% 
% axis_label=num2str(yl',formatSpec);
% 
