function graphAnalysis_allconditions(data)
nBoot = 100;

rez = [];
rsw = [];
sw = [];
nsw = [];
cent = [];
for i = 1:length(data.Data_summary)
    rez{i} = graph.graphAnalysis(data.Data_summary{i}.Processed_Data);
    sw(i) = rez{i}.SWP;
    cent{i}(:) = rez{i}.centrality;

%     for booti = 1:nBoot;
%         data_ = graph.createRndomData(data.Data_summary{i}.Processed_Data);
%         rez_random{i} = graph.graphAnalysis(data_,'non');
%         rsw(i,booti) = rez_random{i}.smallWorldness;
%     end

    for booti = 1:nBoot
        rez_random{i} = graph.graphAnalysis_null(data.Data_summary{i}.Processed_Data,'non');
        nsw(i,booti) = rez_random{i}.SWP;
        ncent{i}(:,booti) = rez_random{i}.centrality;
    end
end

%% small worldness

figure();
hold on;
plot(sw,'Marker','o','Color','#CB0000','MarkerFaceColor','#CB0000','LineStyle','none');
errorbar(mean(nsw','omitnan'),nanstd(nsw')*2,'Color','#50312f','CapSize',0,LineWidth=2,LineStyle='none');
fig.figMod;
ylabel('Small worldness');
xlim([0.5 length(sw)+0.5]);

%% centrality 

edges = 0:0.1:1;
figure();
tiledlayout(1,length(sw),"TileSpacing","compact","Padding","compact");
for i = 1:length(sw)
    nexttile;
    hold on;
    tmp = normalize([cent{i}' ; ncent{i}(:)],'range');
    real = tmp(1:length(cent{i}));
    shuf = tmp(length(cent{i})+1:end);
    histogram(real,edges,'Normalization','probability','EdgeColor','#CB0000','FaceColor','#CB0000');
    histogram(shuf,edges,'Normalization','probability','EdgeColor','#50312f','FaceColor','#50312f');
% 
%     histogram(normalize(cent{i},'range'),edges,'Normalization','probability','EdgeColor','#CB0000','FaceColor','#CB0000');
%     histogram(normalize(ncent{i}(:),'range'),edges,'Normalization','probability','EdgeColor','#50312f','FaceColor','#50312f');
end


%% degree distribution

figure();
tiledlayout(2,length(sw),"TileSpacing","compact","Padding","compact");
for i = 1:length(sw)
    nexttile;
    hold on;
    degree = rez{i}.degree;
    h = histogram(degree,'Normalization','probability','BinWidth',1,'FaceColor','k');
%     histfit(degree,h.NumBins+10,'poisson');
    degree = rez_random{i}.degree;
    histogram(degree,'Normalization','probability','BinWidth',1);
end


end