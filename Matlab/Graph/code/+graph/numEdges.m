function m = numEdges(adj)

sl=sum(diag(adj)); % counting the number of self-loops

if isSymmetric(adj) & sl==0    % undirected simple graph
    m=sum(sum(adj))/2;
    
elseif isSymmetric(adj) & sl>0
    m=(sum(sum(adj))-sl)/2+sl; % counting the self-loops only once

elseif not(isSymmetric(adj))   % directed graph (not necessarily simple)
    m=sum(sum(adj));
    
end
end

function S = isSymmetric(mat)
S = false; % default
if mat == transpose(mat); S = true; end
end