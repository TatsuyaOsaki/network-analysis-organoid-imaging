function corrCoef_all(path)

d = dir(path);
dataname = {d.name};
dataname(~contains(dataname,'.mat')) = [];

C = [];
rC = [];
C_sub = [];
for datai = 1:length(dataname)
    data = load(fullfile(path,dataname{datai}));
    [C_,rC_,C_sub_] = graph.calcCorr(data.Data_summary);
    C{datai} = C_.Pearson;
    rC{datai} = rC_.Pearson;
    C_sub.EE{datai} = C_sub_.EE;
    C_sub.II{datai} = C_sub_.II;
    C_sub.EI{datai} = C_sub_.EI;
end

%% peason's corr

for datai = 1:length(dataname)
    for i = 1:length(C{datai})
        C_mean(datai,i) = mean(abs(C{datai}{i}));
        rC_mean(datai,i) = mean(abs(rC{datai}{i}(:)));
        C_sub_mean.EE(datai,i) = mean(abs(C_sub.EE{datai}{i}(:)));
        C_sub_mean.EI(datai,i) = mean(abs(C_sub.EI{datai}{i}(:)));
        C_sub_mean.II(datai,i) = mean(abs(C_sub.II{datai}{i}(:)));
    end
end

figure();
hold on;
errorbar(mean(C_mean),nanstd(C_mean),'Color','#CB0000','LineWidth',2,'Marker','o',...
    'MarkerEdgeColor','#CB0000','MarkerFaceColor','#CB0000','LineStyle','none');
errorbar(mean(rC_mean),nanstd(rC_mean),'Color','#50312F','LineWidth',2,'Marker','o',...
    'MarkerEdgeColor','#50312F','MarkerFaceColor','#50312F','LineStyle','none');
fig.figMod;
xlim([0.5 size(C_mean,2)+0.5]);
ylabel('Abs. Corr. Coef.');


figure();
hold on;
errorbar([1:size(C_sub_mean.EE,2)]-0.1,mean(C_sub_mean.EE,'omitnan'),nanstd(C_sub_mean.EE),...
    'Color','#CB0000','LineWidth',2,'Marker','o',...
    'MarkerEdgeColor','#CB0000','MarkerFaceColor','#CB0000','LineStyle','none');
errorbar([1:size(C_sub_mean.EE,2)],mean(C_sub_mean.EI,'omitnan'),nanstd(C_sub_mean.EI),...
    'Color','#CB0000','LineWidth',2,'Marker','s',...
    'MarkerEdgeColor','#CB0000','MarkerFaceColor','#CB0000','LineStyle','none');
errorbar([1:size(C_sub_mean.EE,2)]+0.1,mean(C_sub_mean.II,'omitnan'),nanstd(C_sub_mean.II),...
    'Color','#CB0000','LineWidth',2,'Marker','^',...
    'MarkerEdgeColor','#CB0000','MarkerFaceColor','#CB0000','LineStyle','none');
fig.figMod;
xlim([0.5 size(C_mean,2)+0.5]);
ylabel('Abs. Corr. Coef.');

%% example distribution 

for datai = 1:length(dataname)
    for i = 1:length(C{datai})
        C_mean(datai,i) = mean((C{datai}{i}));
        rC_mean(datai,i) = mean((rC{datai}{i}(:)));
    end
end

datai = 1;
D = C{datai};
rD = rC{datai};

edges = -1:0.05:1;
e = edges - (edges(2)-edges(1))/2;
e(end+1) = edges(end)+(edges(2)-edges(1))/2;
figure();
tiledlayout(1,4,'TileSpacing','compact','Padding','compact');
for i = 1:length(D)
    nexttile;
    c = histcounts(D{i},e,'Normalization','probability');
    plot(edges,c,'LineWidth',2,'Color','#CB0000');
    hold on;
    c = histcounts(rD{i}(:),e,'Normalization','probability');
    plot(edges,c,'LineWidth',2,'Color','#50312F');
    fig.figMod;
end
    





