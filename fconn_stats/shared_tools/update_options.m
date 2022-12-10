function options=update_options(user_provided_options)
%%
whos_options=whos('user_provided_options');

switch whos_options.class
    case 'char'
        run(user_provided_options)
        
    case 'double'
        options=user_provided_options;
    case 'struct'
        options=user_provided_options;
        
    otherwise
        
end
