function graphBasic_all(path)
params = [];
params.threshold = 0.2;
params.nBoot = 100;


d = dir(path);
dataname = {d.name};
dataname(~contains(dataname,'.mat')) = [];

clear rez rez_null;
for datai = 1:length(dataname)
    data = load(fullfile(path,dataname{datai}));
    for i = 1:length(data.Data_summary)
        [rez(datai,i) rez_null(datai,i)] = graph.basicGraphData(data.Data_summary{i}.Processed_Data.deltaF,params);
    end
end

%% SWP

dataShape = {'o','^','s','pentagram'};

for i = 1:size(rez,1)
    for j = 1:size(rez,2)
        swp(i,j) = rez(i,j).SWP;
        swp_null(i,j) = mean(rez_null(i,j).SWP);
    end
end

figure();
hold on;
for i = 1:size(rez,1)
    scatter([1:size(swp,2)]+0.1*(i-1),swp(i,:),dataShape{i},'MarkerEdgeColor','#CB0000', ...
        'MarkerFaceColor','none','SizeData',100,'LineWidth',2);
%     scatter([1:size(swp,2)]+0.07*(i-1),swp_null(i,:),dataShape{i},'MarkerEdgeColor','#50312F', ...
%         'MarkerFaceColor','none','SizeData',100,'LineWidth',2);
    for j = 1:size(rez,2)
        x = rez_null(i,j).SWP;
        errorbar(j+0.1*(i-1),mean(x),std(x)*2,'Marker',dataShape{i},'LineWidth',2, ...
            'LineStyle','none','Color','#50312F','MarkerSize',10);
    end
end
fig.figMod;
ylabel('Small world propensity');
xlim([.5 size(swp,2)+0.5]);

%% small worldness

dataShape = {'o','^','s','pentagram'};

for i = 1:size(rez,1)
    for j = 1:size(rez,2)
        sw(i,j) = rez(i,j).pathLength;
        sw_null(i,j) = mean(rez_null(i,j).pathLength);
    end
end

figure();
hold on;
for i = 1:size(rez,1)
    scatter([1:size(sw,2)]+0.1*(i-1),sw(i,:),dataShape{i},'MarkerEdgeColor','#CB0000', ...
        'MarkerFaceColor','none','SizeData',100,'LineWidth',2);
%     scatter([1:size(swp,2)]+0.07*(i-1),swp_null(i,:),dataShape{i},'MarkerEdgeColor','#50312F', ...
%         'MarkerFaceColor','none','SizeData',100,'LineWidth',2);
    for j = 1:size(rez,2)
        x = rez_null(i,j).pathLength;
        errorbar(j+0.1*(i-1),mean(x),std(x)*2,'Marker',dataShape{i},'LineWidth',2, ...
            'LineStyle','none','Color','#50312F','MarkerSize',10);
    end
end
fig.figMod;
ylabel('Mean local clustering');
xlim([.5 size(sw,2)+0.5]);




end