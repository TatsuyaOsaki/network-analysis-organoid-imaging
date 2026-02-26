function [G, rez, data] = graphBasic_dlx_tagged(data, th)

param.threshold = th;
param.matType = 'weighted'; % weighted, nonweighted
param.searchGam = 0:0.2:3;
param.nBoot = 100;
param.dataType = 'null';% null, empirical

cMat = abs(corr(zscore(data.deltaF),'type','Pearson'));
rez.cMat=cMat;
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
        random_dlx_index =data.dlx_index(randperm(length(data.dlx_index)));
        data.dlx_index=random_dlx_index ;

    case 'empirical'
        data.dlx_index = data.dlx_index ;
        
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


ex_neuron = [];

% Subgroup excitatroy neuron
% Loop through each row of the array
for row = 1:size(data.dlx_index, 1)
    % Check if the value is present in the current row
    if any(data.dlx_index(row, :) == 0)
        % If the value is found, store the row number
        ex_neuron = [ex_neuron row];
    end
end

ih_neuron = [];

% Subgroup excitatroy neuron
% Loop through each row of the array
for row = 1:size(data.dlx_index, 1)
    % Check if the value is present in the current row
    if any(data.dlx_index(row, :) == 1)
        % If the value is found, store the row number
        ih_neuron = [ih_neuron row];
    end
end
% 
% rez.G_ex_neuron = subgraph(G,ex_neuron);
% rez.G_ih_neuron = subgraph(G,ih_neuron);
 rez.ex_node=ex_neuron';
 rez.ih_node=ih_neuron';

del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.ex_node == sOut) && any(rez.ex_node == tOut))) || ((any(rez.ih_node == sOut) && any(rez.ih_node == tOut)))

        
        del_edge_index=vertcat(del_edge_index, EdgeID);


    end
    rez.G_ex_ih = rmedge(G,del_edge_index);
    
end
del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.ex_node == sOut) && any(rez.ex_node == tOut))) || ((any(rez.ih_node == sOut) && any(rez.ex_node == tOut))) || ((any(rez.ex_node == sOut) && any(rez.ih_node == tOut)))

        del_edge_index=vertcat(del_edge_index, EdgeID);
    end

    rez.G_ih_neuron = rmedge(G,del_edge_index);
    
   
end

del_edge_index=[];
for EdgeID=1:numedges(G)
    [sOut,tOut]=findedge(G,EdgeID);
    
    if ((any(rez.ih_node == sOut) && any(rez.ih_node == tOut))) || ((any(rez.ih_node == sOut) && any(rez.ex_node == tOut))) || ((any(rez.ex_node == sOut) && any(rez.ih_node == tOut)))

        del_edge_index=vertcat(del_edge_index, EdgeID);
    end

    rez.G_ex_neuron = rmedge(G,del_edge_index);
    
   
end


%%
%[cMat_,idx] = graph.find0nodes(cMat);
% if isempty(varargin)
%     M = []; Q = [];
%     for booti = 1:param.nBoot
%         for g = 1:length(param.searchGam)
%             [M{booti,g},Q(booti,g)]= graph.community_louvain(cMat_,param.searchGam(g));
%         end
%     end
%     rez.M = M;
%     rez.Q = Q;
% end

%M_all = graph.community_louvain(cMat_);

% modules=louvainCommunityFinding(cMat_)

%%
% 
% %cmap = getPyPlot_cMap('nipy_spectral',max(M_all)+1);
% cmap = colormap(jet(max(M_all)));
% 
% [xynew, XY, xyc] = graph.FRKK(sparse(double(cMat)),M_all,0.01);
% 
% f=figure();
% f.Color           = 'w';
% f.InvertHardcopy  = 'off';
% f.Name            = 'Neuronal networks';
% 
% graphplot2D(xynew,sparse(double(cMat_)), 0.5);
% hold on;
% for i = 1:max(M_all)
%     idx = find(M_all == i);
%     scatter(xynew(idx,1),xynew(idx,2), ...
%         'Marker','o', ...
%         'MarkerEdgeColor',[0.2 0.2 0.2],...
%         'MarkerFaceColor',cmap(i,:), ...
%         'SizeData',100, ...
%         'LineWidth',3);
% end
% ax = fig.figMod;
% 
% ax.XAxis.Visible = 'off';
% ax.YAxis.Visible = 'off';
% axis square;
% 
% %set(gcf,"Position",[1707 619 544 520]);
% 
% 
% [~,i] = sort(M_all);
% %figure();
% %imagesc(cMat_(i,i))




end