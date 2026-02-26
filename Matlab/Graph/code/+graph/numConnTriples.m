function c=numConnTriples(adj)

c=0;  % initialize

for i=1:length(adj)
    neigh=graph.kneighbors(adj,i,1);
    if length(neigh)<2; continue; end  % handle leaves, no triple here
    c=c+nchoosek(length(neigh),2);
end

c=c-2*graph.loops3(adj); 
end