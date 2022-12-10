function f=bivariate_score(x,y)
% Thuis function calculate the score from a bivariate distribution
% x contains the 5 parameters that uniquely describe a bivariate
% distribution (2 means, 2 stad dev and corr coef). y contains the points
% which will be scored

m1=x(1);
m2=x(2);
s1=x(3);
s2=x(4);
r=x(5);



x1=y(:,1);
x2=y(:,2);



sr=sqrt(1-r^2);
d=2*pi*s1*s2*sr;
c=-1/(2*sr^2);

Q=((x1-m1)/s1).^2+((x2-m2)/s2).^2-2*r*((x1-m1)/s1).*((x2-m2)/s2);
f=exp(c*Q)/d;
