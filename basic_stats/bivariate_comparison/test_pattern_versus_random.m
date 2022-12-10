function test_pattern_versus_random(M,iter,bins);
if nargin<3
    bins=20;
end

if nargin<2
    iter=500;
end


Y = complete_sort_sort_matrix(M,bins);
x=run_fit_2d_gauss(Y);

[R eff]=randmio_und(M1, 2);