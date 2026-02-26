function simulation
%% parameters

params.N = 100;
params.K = 20;
params.noise = 0.05;
params.sparseness = 0.6;

N_modules = 5;

figure();
% noise 0.05
subplot(2,5,1);
axis tight;
params.noise = 0.05;
[A,cl] = createSimulationData(params,N_modules);
rez{1} = graph.graphAnalysis_simulation(A,0);
rez{1}.noise = 0.05;
subplot(2,5,6);
axis tight;
drawCorrMat(A);
[rez{1}.SWP,delta_C,delta_L] = graph.small_world_propensity(A);

% noise 0.1
subplot(2,5,2);
axis tight;
params.noise = 0.1;
[A,cl] = createSimulationData(params,N_modules);
rez{2} = graph.graphAnalysis_simulation(A,0);
rez{2}.noise = 0.1;
subplot(2,5,7);
axis tight;
drawCorrMat(A);
[rez{2}.SWP,delta_C,delta_L] = small_world_propensity(A);

% noise 0.2
subplot(2,5,3);
axis tight;
params.noise = 0.2;
[A,cl] = createSimulationData(params,N_modules);
rez{3} = graph.graphAnalysis_simulation(A,0);
rez{3}.noise = 0.2;
subplot(2,5,8);
axis tight;
drawCorrMat(A);
[rez{3}.SWP,delta_C,delta_L] = small_world_propensity(A);

% noise 0.3
subplot(2,5,4);
axis tight;
params.noise = 0.3;
[A,cl] = createSimulationData(params,N_modules);
rez{4} = graph.graphAnalysis_simulation(A,0);
rez{4}.noise = 0.3;
subplot(2,5,9);
axis tight;
drawCorrMat(A);
[rez{4}.SWP,delta_C,delta_L] = small_world_propensity(A);

% noise 0.5
subplot(2,5,5);
axis tight;
params.noise = 0.5;
[A,cl] = createSimulationData(params,N_modules);
rez{5} = graph.graphAnalysis_simulation(A,0);
rez{5}.noise = 0.5;
subplot(2,5,10);
axis tight;
drawCorrMat(A);
[rez{5}.SWP,delta_C,delta_L] = small_world_propensity(A,'bin');

latmio_und

end

function [A,cl] = createSimulationData(param,N_modules)
A = zeros(param.N,param.N);

cl = randi(N_modules,param.N,1);

for i = 1:max(cl)
    idx = find(cl==i);
    C = nchoosek(idx,2);
    n = size(C,1);
    C = C(randperm(n,ceil(n*param.sparseness)),:);
    for j = 1:size(C,1)
        A(C(j,1),C(j,2)) = 1;
        A(C(j,2),C(j,1)) = 1;
    end

    idx_others = setdiff(1:length(A),idx);
    C = combvec(idx',idx_others);
    n = size(C,2);
    C = C(:,randperm(n,ceil(n*param.noise)))';
    for j = 1:size(C,1)
        A(C(j,1),C(j,2)) = 1;
        A(C(j,2),C(j,1)) = 1;
    end

end

for i = 1:length(A)
    A(i,i) = 1;
end


[~,i] = sort(cl);
A = A(i,i);
% figure();imagesc(A(i,i))


end

function drawCorrMat(M)

% figure();
imagesc(M);
colormap([ 1 1 1 ; 0.3 0.3 0.3]);
axis square;
ax = fig.figMod;
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
set(gcf,"Position",[1200 600 300 300]);

end

function h = WattsStrogatz(N,K,beta)
% H = WattsStrogatz(N,K,beta) returns a Watts-Strogatz model graph with N
% nodes, N*K edges, mean node degree 2*K, and rewiring probability beta.
%
% beta = 0 is a ring lattice, and beta = 1 is a random graph.

% Connect each node to its K next and previous neighbors. This constructs
% indices for a ring lattice.
s = repelem((1:N)',1,K);
t = s + repmat(1:K,N,1);
t = mod(t-1,N)+1;

% Rewire the target node of each edge with probability beta
for source=1:N    
    switchEdge = rand(K, 1) < beta;
    
    newTargets = rand(N, 1);
    newTargets(source) = 0;
    newTargets(s(t==source)) = 0;
    newTargets(t(source, ~switchEdge)) = 0;
    
    [~, ind] = sort(newTargets, 'descend');
    t(source, switchEdge) = ind(1:nnz(switchEdge));
end

h = graph(s,t);
end