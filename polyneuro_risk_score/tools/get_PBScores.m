function PBScores = get_PBScores(n_subjects,...
    n_th,...
    betas,...
    fconn,...
    IX)
    


%% Pre-allocate memory for scores
PBScores=nan(n_subjects,n_th);


%% Estimathe the scores

W=repmat([betas.Estimate]',n_subjects,1);
P=W.*fconn;
for i=1:n_th
    PBScores(:,i)=mean(P(:,IX(i,:)==1),2);
end