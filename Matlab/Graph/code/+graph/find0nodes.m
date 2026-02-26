function [M,idx] = find0nodes(M)

s = sum(M);
idx = find(s == 1);

M(idx,:) = [];
M(:,idx) = [];

end