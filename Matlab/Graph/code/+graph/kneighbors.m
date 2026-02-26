function neighbors = kneighbors(A,ind,k)
adjk = A;
for i=1:k-1 
    adjk = adjk*A; 
end
neighbors = find(adjk(ind,:)>0);
end