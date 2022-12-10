function standar=get_standar(sample2,to_score)
% Oscar Miranda-Dominguez
% First line of code, Feb 2, 2018


switch to_score
    case 'diff'
        standar=ones(2,1);
        standar(1)=mean(sample2);
        standar(2)=std(sample2);
        if standar(2)==0
            standar(2)=1;
        end
end