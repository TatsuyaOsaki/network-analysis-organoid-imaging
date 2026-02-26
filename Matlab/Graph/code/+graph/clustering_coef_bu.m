function C=clustering_coef_bu(G)

n=length(G);
C=zeros(n,1);
for u=1:n
    V=find(G(u,:));
    k=length(V);
    if k>=2                 %degree must be at least 2
        S=G(V,V);
        C(u)=sum(S(:))/(k^2-k);
    end
end