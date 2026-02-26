%% data loading
clear all
data =load('Graph\data\Data1_plus_idx.mat');

%% correlation coefficients
corr_organoid.calcCorr(data.Data_summary)
%% basic analysis 
for k = 1:4
graph.graphBasic(data.Data_summary{k}.Processed_Data)
end

%% graph theory 

% actual data
graph.graphAnalysis_allconditions(data)
% simulation
graph.simulation;


%% graph theory 20230602
sampleID=1;

fig = figure;
fig.PaperUnits      = 'centimeters';
fig.Units           = 'centimeters';
fig.Color           = 'w';
fig.InvertHardcopy  = 'off';
fig.Name            = ['Graph weighted #' num2str(sampleID)];
fig.NumberTitle     = 'off';
set(fig,'defaultAxesXColor','k'); 
figure(fig);

sampleID=1;
for k=1:4
    sampleID=k;


    subplot(2, 2, k);

    [G, rez]=graph.graphBasic_dlx_tagged(data.Data_summary{sampleID}.Processed_Data, 0.25);
    temp_data=data.Data_summary{sampleID}.Processed_Data;
  
    LWidths = ((G.Edges.Weight+1).^10)/100;
    cmap=hsv(3);
    ClusterColor=[];

            for i=1:length(temp_data.dlx_index)
            temp_color=cmap(temp_data.dlx_index(i, 1)+1, :);
            ClusterColor(i, :)=temp_color;
        end
    
    p=plot(G, 'LineWidth',LWidths, "Layout","force", 'NodeColor', ClusterColor, 'MarkerSize', 5);
    wbc=rez.centrality_betweenness;
    n = numnodes(G);
    %p.NodeCData =2*wbc./((n-2)*(n-1));
    colormap jet
    colorbar
    set(gca,'xcolor','w','ycolor','w', 'zcolor','w'  );
    set(gca,'box','off', 'XTick', [], 'YTick', []);
    daspect([1 1 1])

end



%%
fig = figure;
fig.PaperUnits      = 'centimeters';
fig.Units           = 'centimeters';
fig.Color           = 'w';
fig.InvertHardcopy  = 'off';
fig.Name            = ['Correlation matrix'];
fig.NumberTitle     = 'off';
set(fig,'defaultAxesXColor','k'); 

sampleID=2;

for k=1:4
    sampleID=k;
    [G, rez]=graph.graphBasic_dlx_tagged(data.Data_summary{sampleID}.Processed_Data, 0.25);
    
    
    subplot(4, 4, 4*k-3)
    adMatrix=adjacency(G, double(G.Edges.Weight));
    heatmap(zscore(adMatrix), 'GridVisible','on');
    colormap('jet')
    
    subplot(4, 4, 4*k-2)
    adMatrix=adjacency(rez.G_ex_neuron, double(rez.G_ex_neuron.Edges.Weight));
    heatmap(zscore(adMatrix));
    colormap('jet')
    
    subplot(4, 4, 4*k-1)
    adMatrix=adjacency(rez.G_ih_neuron, double(rez.G_ih_neuron.Edges.Weight));
    heatmap(zscore(adMatrix));
    colormap('jet')
    
    subplot(4, 4, 4*k)
    adMatrix=adjacency(rez.G_ex_ih, double(rez.G_ex_ih.Edges.Weight));
    heatmap(zscore(adMatrix));
    colormap('jet')
end
%%
