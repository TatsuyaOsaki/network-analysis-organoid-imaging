function [rez,rez_null] = basicGraphData(data,params)

cMat = abs(corr(double(data),'type','Pearson'));
for i = 1:length(cMat)
    cMat(i,i) = 0;
end

cMat(cMat>params.threshold) = 1;
cMat(cMat<=params.threshold) = 0; 

%%
G = graph(cMat,'omitselfloops');

rez = [];
rez.nNodes = length(cMat);
rez.degree = sum(cMat);
rez.shortestPath = distances(G);
rez.shortestPath(isinf(rez.shortestPath)) = 0;
rez.pathLength = sum(rez.shortestPath(:))/(rez.nNodes*(rez.nNodes-1));
rez.clusterCoeff=graph.clustering_coef_bu(cMat);
rez.nTriangles = 3*graph.loops3(cMat)/(graph.numConnTriples(cMat)+2*graph.loops3(cMat));
rez.meanLocalCluster = mean(rez.clusterCoeff);
rez.smallWorldness = rez.meanLocalCluster/rez.pathLength;
for i = 1:params.nBoot
    [rez.SWP_raw(i)] = graph.small_world_propensity(double(cMat),'O');
end
rez.SWP = mean(rez.SWP_raw,'omitnan');
rez.centrality = centrality(G,'closeness');


%% null model 

rez_null = [];

for booti = 1:params.nBoot
    idx = find(triu(ones(size(cMat)),1) == 1);
    tmp = cMat(idx);
    tmp_ = tmp(randperm(length(tmp)));
    [i1 i2] = find(triu(ones(size(cMat)),1) == 1);
    cMat_null = zeros(size(cMat));
    for i = 1:length(i1)
        cMat_null(i1(i),i2(i)) = tmp_(i);
        cMat_null(i2(i),i1(i)) = tmp_(i);
    end
    G = graph(cMat_null,'omitselfloops');

    rez_null.nNodes = length(cMat_null);
    rez_null.degree(:,booti) = sum(cMat_null)';
    rez_null.shortestPath = distances(G);
    rez_null.shortestPath(isinf(rez_null.shortestPath)) = 0;
    rez_null.pathLength(booti) = sum(rez_null.shortestPath(:))/(rez_null.nNodes*(rez_null.nNodes-1));
    rez_null.clusterCoeff(:,booti)=graph.clustering_coef_bu(cMat_null);
    rez_null.nTriangles(booti) = 3*graph.loops3(cMat_null)/(graph.numConnTriples(cMat_null)+2*graph.loops3(cMat_null));
    rez_null.meanLocalCluster(booti) = mean(rez_null.clusterCoeff(:,booti));
    rez_null.smallWorldness(booti) = rez_null.meanLocalCluster(booti)/rez_null.pathLength(booti);
    for i = 1:params.nBoot
        [rez_null.SWP_raw(i)] = graph.small_world_propensity(double(cMat_null),'O');
    end
    rez_null.SWP(booti) = mean(rez_null.SWP_raw);
    rez_null.centrality(:,booti) = centrality(G,'closeness');
end



end