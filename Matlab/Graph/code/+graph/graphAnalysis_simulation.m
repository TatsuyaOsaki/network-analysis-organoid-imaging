function [rez] = graphAnalysis_simulation(cMat,f)

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

rez.centrality = centrality(G,'betweenness');

%%
[cMat_,idx] = graph.find0nodes(cMat);
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

[M_all,Q] = graph.community_louvain(cMat_);
rez.M = M_all;
rez.Q = Q;

%%

%cmap = getPyPlot_cMap('nipy_spectral',7);
cmap = colormap(hsv(7));

[xynew, XY, xyc] = graph.FRKK(sparse(double(cMat_)),M_all,0.01);
if f == 1
    figure();
end
graphplot2D(xynew,sparse(double(cMat_)),0.5);
hold on;
for i = 1:max(M_all)
    idx = find(M_all == i);
%     scatter(xynew(idx,1),xynew(idx,2),'Marker','o','MarkerEdgeColor',[0.2 0.2 0.2],...
%         'MarkerFaceColor',cmap(i+1,:),'SizeData',100,'LineWidth',3);
    scatter(xynew(idx,1),xynew(idx,2),'Marker','o','MarkerEdgeColor','none',...
        'MarkerFaceColor',cmap(i+1,:),'SizeData',50,'LineWidth',3);
end
ax = fig.figMod;
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
axis square;

set(gcf,"Position",[1707 619 544 520]);





end