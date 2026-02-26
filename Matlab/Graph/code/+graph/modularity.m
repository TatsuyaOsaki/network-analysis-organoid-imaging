function [varargout] = modularity(A, g)


nGroups = numel(unique(g));
nNodes = length(g);
nargoutchk(0,2)
e = zeros(nGroups); 
for i = 1:nNodes
    for j = 1:nNodes
        e(g(i), g(j)) = e(g(i), g(j)) + A(i, j);
    end
end
nLinks = sum(A(:));
a_out = sum(e, 2);
a_in = (sum(e, 1))';
a = a_in.*a_out/nLinks^2;
Q = trace(e)/nLinks - sum(a);
Qv = diag(e)/nLinks - a;
if nargout <= 1
    varargout{1} = Q;
elseif nargout == 2
    varargout{1} = Q;
    varargout{2} = Qv;
end




end

