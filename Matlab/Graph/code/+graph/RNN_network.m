function RNN_network(path)

params = [];
params.threshold = 0.5;
params.nBoot = 50;

d = dir(path);
name = {d.name};
name(~contains(name,'.mat')) = [];

clear rez rez_null;
for datai = 1:length(name)
    data = load(fullfile(path,name{datai}));
    y = [];
    for i = 1:size(data.y,3)
        tmp = squeeze(data.y(:,:,i))';
        y(i,:) = tmp(:)';
    end
    [rez(datai), rez_null(datai)] = graph.basicGraphData(y',params);
end


%%

dataShape = {'o','^','s','pentagram'};

figure();
hold on;
for i = 1:length(rez)
    scatter(1+0.1*i,rez(i).SWP,dataShape{i},'MarkerEdgeColor','#CB0000', ...
        'MarkerFaceColor','none','SizeData',100,'LineWidth',2);
    x = rez_null(i).SWP_raw;
    errorbar(1+0.1*i,mean(x),std(x)*2,'Marker',dataShape{i},'LineWidth',2, ...
        'LineStyle','none','Color','#50312F','MarkerSize',10);
end
fig.figMod;
ylabel('Small world propensity');
xlim([.5 1.5]);
ylim([0 1]);

end