function Y = complete_sort_sort_matrix(M,bins,plot_option)
% This function
if nargin<3
    plot_option=1;
end
if nargin<2
    bins=20;
end


[X1 MM1 MNC1]=scout_correlation(M,bins,[],[],0);

X=X1./MNC1;
Y=X+not(eye(length(X))).*X';
Y(isnan(Y))=0;
if plot_option
    
    subplot 121
    imagesc(X1)
    colorbar
    title('Original count')
    
    subplot 122
    imagesc(Y)
    colorbar
    title ({'Duplicated and normalized by','maximum number of connections'})
end