function m_density1 =verify_matrix_density(M);

[r, c]=size(M);
tpc1=r*(c-1); % total possible connections
pc1=M(M(:)>0);% positive connections
n_pc1=length(pc1);% number of positive connections
nc1=M(M(:)<0);% negative connections
n_nc1=length(nc1);
m_density1=(n_pc1+n_nc1)/tpc1;


hist(pc1,21)
hold on
hist(nc1,21)
hold off
xlim([min(M(:)) max(M(:))])
title (['Matrix density = ', num2str(100*m_density1,'%4.2f'), '%'])
