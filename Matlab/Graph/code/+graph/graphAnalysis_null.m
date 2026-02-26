function [rez] = graphAnalysis_null(data,varargin)

param.threshold = 0.3;
param.matType = 'nonweighted'; % weighted, nonweighted
param.searchGam = 0:0.2:3;
param.nBoot = 100;

cMat = abs(corr(zscore(data.deltaF)));
cMat(cMat>param.threshold) = 1;
cMat(cMat<=param.threshold) = 0;

switch param.matType
    case 'nonweighted'
        cMat = cMat;
    case 'weighted'
        cMat = cMat*abs(corr(zscore(data.deltaF)));
end

idx = find(triu(ones(size(cMat)),1) == 1);

tmp = cMat(idx);
tmp = tmp(randperm(length(tmp)));
tmp_ = [];
I = 1;
for i = 1:length(cMat)
    for j = 1:length(cMat)
        if i > j
            tmp_(i,j) = tmp(I);
            tmp_(j,i) = tmp(I);
            I = I + 1;
        else if i == j
                tmp_(i,i) = 1;
        end
        end
    end
end

cMat = tmp_;
for i = 1:length(cMat)
    cMat(i,i) = 0;
end

G = graph(cMat,'omitselfloops');

rez.nNodes = length(cMat);
rez.degree = degree(G);
rez.shortestPath = distances(G);
rez.shortestPath(isinf(rez.shortestPath)) = 0;
rez.pathLength = sum(rez.shortestPath(:))/(rez.nNodes*(rez.nNodes-1));
% rez.globalEff = (sum(sum(1./(D+eye(rez.nNodes)))) - rez.nNodes)/(rez.nNodes*(rez.nNodes-1));

C=graph.clustering_coef_bu(cMat);

rez.nTriangles = 3*graph.loops3(cMat)/(graph.numConnTriples(cMat)+2*graph.loops3(cMat));
rez.meanLocalCluster = mean(C);
rez.clusterCoeff = C;

rez.smallWorldness = rez.meanLocalCluster/rez.pathLength;
rez.SWP = graph.small_world_propensity(double(cMat),'bin');

rez.centrality = centrality(G,'betweenness');

%%
if isempty(varargin)
    M = []; Q = [];
    for booti = 1:param.nBoot
        for g = 1:length(param.searchGam)
            [M{booti,g},Q(booti,g)]= graph.community_louvain(cMat,param.searchGam(g));
        end
    end
    rez.M = M;
    rez.Q = Q;
end

%%

% figure();
% plot(G,'Layout','subspace')



end