function dist=JSDiv(P,Q)
if size(P,2)~=size(Q,2)
    error('the number of columns in P and Q should be the same');
end
Q = Q ./sum(Q);
Q = repmat(Q,[size(P,1) 1]);
P = P ./repmat(sum(P,2),[1 size(P,2)]);
M = 0.5.*(P + Q);
dist = 0.5.*corr_organoid.KLDiv(P,M) + 0.5*corr_organoid.KLDiv(Q,M);
end