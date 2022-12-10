function Z=nanzscore(X)
Z=(X-nanmean(X))./nanstd(X);
