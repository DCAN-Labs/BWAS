function score=get_score(sample1,standar,to_score)

% Oscar Miranda-Dominguez
% First line of code, Feb 2, 2018


switch to_score
    case 'diff'
        score=(sample1-standar(1))/standar(2);
end
