function [Corrected_matrix, num_neurons] = deltaF_norm(M)
num_neurons=size(M,2);

for i=1:num_neurons
    matrix=M(:,i);
    Corrected_matrix(:,i)=(matrix-mean(matrix))/mean(matrix);
end

end