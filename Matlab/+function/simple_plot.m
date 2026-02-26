function simple_plot(Matrix)
fig = figure;
fig.PaperUnits      = 'centimeters';
fig.Units           = 'centimeters';
fig.Color           = 'w';
fig.InvertHardcopy  = 'off';
fig.Name            = 'Plot_data'
fig.NumberTitle     = 'off';
set(fig,'defaultAxesXColor','k');
figure(fig);


num_neurons=size(Matrix,2);
cmap = bone(num_neurons); 

for i=1:num_neurons
    plot(Matrix(:, i), 'Color', 'black');
    hold on
end
hold off
end