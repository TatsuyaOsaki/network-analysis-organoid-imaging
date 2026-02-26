function [G, rez, data] = graphBasic_mosaic_EGFP_index(data, th)

param.threshold = th;
param.matType = 'weighted'; % weighted, nonweighted
param.searchGam = 0:0.2:3;
param.nBoot = 100;
param.dataType = 'null';% null, empirical

cMat = abs(corr(zscore(data.deltaF),'type','Pearson'));
cMat(cMat>param.threshold) = 1;
cMat(cMat<=param.threshold) = 0;

for i = 1:length(cMat)
    cMat(i,i) = 0;
end


switch param.matType
    case 'nonweighted'
        cMat = cMat;
    case 'weighted'
        cMat = cMat.*abs(corr(zscore(data.deltaF)));
end

switch param.dataType
    case 'null'
        random_dlx_index =data.EGFP_index(randperm(length(data.EGFP_index)));
        data.EGFP_index=random_dlx_index ;

    case 'empirical'
        data.EGFP_index = data.EGFP_index ;
        
end


G = graph(cMat,'omitselfloops', 'upper');

rez.nNodes = length(cMat);
rez.degree = sum(cMat)';
rez.shortestPath = distances(G);
rez.shortestPath(isinf(rez.shortestPath)) = 0;
rez.pathLength = sum(rez.shortestPath(:))/(rez.nNodes*(rez.nNodes-1));
% rez.globalEff = (sum(sum(1./(D+eye(rez.nNodes)))) - rez.nNodes)/(rez.nNodes*(rez.nNodes-1));

C=graph.clustering_coef_bu(cMat);

c=graph.numConnTriples(double(cMat));

rez.nTriangles = 3*graph.loops3(cMat)/(graph.numConnTriples(cMat)+2*graph.loops3(cMat));
rez.meanLocalCluster = mean(C);
rez.clusterCoeff = C;

rez.smallWorldness = rez.meanLocalCluster/rez.pathLength;

for i = 1:param.nBoot
    [rez.SWP_raw(i)] = graph.small_world_propensity(double(cMat),'O');
end
rez.SWP = mean(rez.SWP_raw);

[expectedC,expectedL] = ER_Expected_L_C(mean(rez.degree),rez.nNodes);
[rez.sw] = small_world_ness(cMat,expectedL,expectedC,1); 

%[Lrand,CrandWS] = NullModel_L_C(rez.nNodes,sum(rez.degree)/2,1000,1);
%Lrand_mean = mean(Lrand(Lrand < inf));
%[S_ws_MC,~,~] = small_world_ness(cMat,Lrand_mean,mean(CrandWS),1);

rez.centrality_closeness = centrality(G,'closeness', 'Cost', double(G.Edges.Weight));
rez.centrality_betweenness = centrality(G,'betweenness', 'Cost', double(G.Edges.Weight));


WT_neuron = [];

% Subgroup excitatroy neuron
% Loop through each row of the array
for row = 1:size(data.EGFP_index, 1)
    % Check if the value is present in the current row
    if any(data.EGFP_index(row, :) == 0)
        % If the value is found, store the row number
        WT_neuron = [WT_neuron row];
    end
end

Mut_neuron = [];

% Subgroup excitatroy neuron
% Loop through each row of the array
for row = 1:size(data.EGFP_index, 1)
    % Check if the value is present in the current row
    if any(data.EGFP_index(row, :) == 1)
        % If the value is found, store the row number
        Mut_neuron = [Mut_neuron row];
    end
end
% 
% rez.G_ex_neuron = subgraph(G,ex_neuron);
% rez.G_ih_neuron = subgraph(G,ih_neuron);
 rez.WT_node=WT_neuron';
 rez.Mut_node=Mut_neuron';

del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.WT_node == sOut) && any(rez.WT_node == tOut))) || ((any(rez.Mut_node == sOut) && any(rez.Mut_node == tOut)))

        
        del_edge_index=vertcat(del_edge_index, EdgeID);


    end
    rez.G_mosaic = rmedge(G,del_edge_index);
          
end
del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.WT_node == sOut) && any(rez.WT_node == tOut))) || ((any(rez.Mut_node == sOut) && any(rez.WT_node == tOut))) || ((any(rez.WT_node == sOut) && any(rez.Mut_node == tOut)))

        del_edge_index=vertcat(del_edge_index, EdgeID);
    end

    rez.G_Mut_neuron = rmedge(G,del_edge_index);
   
end

del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.Mut_node == sOut) && any(rez.Mut_node == tOut))) || ((any(rez.Mut_node == sOut) && any(rez.WT_node == tOut))) || ((any(rez.WT_node == sOut) && any(rez.Mut_node == tOut)))

        del_edge_index=vertcat(del_edge_index, EdgeID);
    end

    rez.G_WT_neuron = rmedge(G,del_edge_index);
   
end



end