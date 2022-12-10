function my_color = get_my_color(n)

if n==3
    my_color=[27,158,119
        117,112,179
        217,95,2]/255;
else
    my_color=parula(n);
end
