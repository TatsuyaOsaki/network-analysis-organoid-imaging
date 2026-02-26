function calcCorr(data)
%%
nCond = length(data);
nBoot = 100;

%%

C =[];rC = [];
for i = 1:nCond
    sig = data{i}.Processed_Data.deltaF;
    zSig = zscore(sig);

    c = corr(zSig,'type','Pearson');
    C.Pearson{i} = c(triu(ones(size(c)),1) == 1);
    c = corr(zSig,'type','Kendall');
    C.Kendall{i} = c(triu(ones(size(c)),1) == 1);
    c = corr(zSig,'type','Spearman');
    C.Spearman{i} = c(triu(ones(size(c)),1) == 1);

    idx_shuf = 1:size(zSig,1);
    idx_shuf = reshape(idx_shuf,[10 size(zSig,1)/10]);

    for booti = 1:nBoot
        idx = [];
        for j = 1:size(zSig,2)
            ii = randperm(size(idx_shuf,2));
            idx_shuf_ = idx_shuf(:,ii);
            idx(:,j) = idx_shuf_(:);
%             idx(:,j) = randperm(size(zSig,1))';
        end
        rzSig = zSig(idx);
        c = corr(rzSig,'type','Pearson');
        rC.Pearson{i}(:,booti) = c(triu(ones(size(c)),1) == 1);
        c = corr(rzSig,'type','Kendall');
        rC.Kendall{i}(:,booti) = c(triu(ones(size(c)),1) == 1);
        c = corr(rzSig,'type','Spearman');
        rC.Spearman{i}(:,booti) = c(triu(ones(size(c)),1) == 1);
    end
end

%%

target = 'Pearson';
edges = -1:0.05:1;

figure();
tiledlayout(1,nCond,'TileSpacing','compact','Padding','compact');
for i = 1:nCond
    nexttile;
    hold on;
    histogram(rC.(target){i}(:),edges,'Normalization','probability','EdgeColor','#50312f','FaceColor','#50312f');
    histogram(C.(target){i},edges,'Normalization','probability','EdgeColor','#CB0000','FaceColor','#CB0000');
    fig.figMod;
    ylabel('Prob');
    xlabel('Corr. coef.');
end

%%

nansem = @(x) nanstd(x)/sqrt(length(x));

figure();
hold on;
mm = [];
for i = 1:nCond
    d = abs(C.(target){i});
    errorbar(i-0.1,mean(d),nanstd(d),'Color','#CB0000','LineWidth',2,'CapSize',0,'Marker','.','MarkerSize',30);
    d = abs(rC.(target){i}(:));
    errorbar(i+0.1,mean(d),nanstd(d),'Color','#50312f','LineWidth',2,'CapSize',0,'Marker','.','MarkerSize',30);

    m = mean(abs(C.(target){i}))+nanstd(abs(C.(target){i}));
    p = ranksum(abs(C.(target){i})',abs(rC.(target){i}(:))');
    if p<0.05 & p>0.01
        text(i,m+0.1,'*','FontSize',20,'FontName','Arial');
    else if p<0.01 & p>0.001
            text(i,m+0.1,'**','FontSize',20,'FontName','Arial');
    else if p<0.001
            text(i,m+0.1,'***','FontSize',20,'FontName','Arial');
    end
    end
    end
    mm = [mm m];
end
fig.figMod;
ylim([0 max(mm)+0.1]);
ylabel('Abs(corr. coef.)');

end