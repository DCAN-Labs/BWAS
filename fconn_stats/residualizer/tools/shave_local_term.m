function to_compare=shave_local_term(local_term)
%%
k = strfind(local_term,'_');
k=k(end);
to_compare=local_term(1:k-1);