function [data] = createRndomData(data)

idx = [];
for j = 1:size(data.deltaF,2)
    idx(:,j) = randperm(size(data.deltaF,1))';
end
data.deltaF = data.deltaF(idx);


end