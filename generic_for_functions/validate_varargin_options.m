function option=validate_varargin_options(provided,menu,case_text)
% Oscar Miranda-Dominguez
% First line of code, Feb 2, 2018

if ismember(provided,menu)
    option=provided;
else
    t1=['Unknown option for ''' case_text ''', only available options are: '];
    n_menu=length(menu);
    t2=cell(n_menu,1);
    part1=['\n - '];
    for i=1:n_menu
        if isnumeric(menu{i})
            part2=num2str(menu{i});
        else
            part2=(menu{i});
        end
        
        t2{i}=[part1 part2 ' '];  
        t1=[t1 t2{i}];
    end
    
    
%     t=cat(1,t1,t2)
    
    error('validate_varargin_options:invalid_option',t1)
end