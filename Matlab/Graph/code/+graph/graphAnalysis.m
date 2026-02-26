function [rez] = graphAnalysis(data,varargin)

param.threshold = 0.6;
param.matType = 'nonweighted'; % weighted, nonweighted
param.searchGam = 0:0.2:3;
param.nBoot = 100;

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

[rez.SWP, rez.cc_rand, rez.pl_rand] = graph.small_world_propensity(double(cMat),'O');
% [expectedC,expectedL] = ER_Expected_L_C(mean(rez.degree),rez.nNodes);
% [rez.sw] = small_world_ness(cMat,expectedL,expectedC,1); 
% 
% [Lrand,CrandWS] = NullModel_L_C(rez.nNodes,sum(rez.degree)/2,1000,1);
% Lrand_mean = mean(Lrand(Lrand < inf));
% [S_ws_MC,~,~] = small_world_ness(cMat,Lrand_mean,mean(CrandWS),1);

rez.centrality = centrality(G,'betweenness');

%%
[cMat_,idx] = graph.find0nodes(cMat);
if isempty(varargin)
    M = []; Q = [];
    for booti = 1:param.nBoot
        for g = 1:length(param.searchGam)
            [M{booti,g},Q(booti,g)]= graph.community_louvain(cMat_,param.searchGam(g));
        end
    end
    rez.M = M;
    rez.Q = Q;
end

M_all = graph.community_louvain(cMat_);

%%

% cmap = getPyPlot_cMap('nipy_spectral',max(M_all)+1);
% [xynew, XY, xyc] = graph.FRKK(sparse(double(cMat_)),M_all,0.01);
% figure();
% graphplot2D(xynew,sparse(double(cMat_)),0.5);
% hold on;
% for i = 1:max(M_all)
%     idx = find(M_all == i);
%     scatter(xynew(idx,1),xynew(idx,2),'Marker','o','MarkerEdgeColor',[0.2 0.2 0.2],...
%         'MarkerFaceColor',cmap(i+1,:),'SizeData',100,'LineWidth',3);
% end
% ax = fig.figMod;
% ax.XAxis.Visible = 'off';
% ax.YAxis.Visible = 'off';
% axis square;
% 
% set(gcf,"Position",[1707 619 544 520]);
% 
% 
% [~,i] = sort(M_all);
% figure();
% imagesc(cMat_(i,i))

end