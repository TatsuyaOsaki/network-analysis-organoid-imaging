function [C,rC,C_sub] = calcCorr(data)
%%
nCond = length(data);
nBoot = 100;

%%
C =[];rC = [];
C_sub.EE = [];
C_sub.EI = [];
C_sub.II = [];
for i = 1:nCond
    sig = data{i}.Processed_Data.deltaF;
    zSig = zscore(sig);

    c = corr(zSig,'type','Pearson');
    C.Pearson{i} = c(triu(ones(size(c)),1) == 1);

    for booti = 1:nBoot
        idx = [];
        for j = 1:size(zSig,2)
            idx(:,j) = randperm(size(zSig,1))';
        end
        rzSig = zSig(idx);
        c = corr(rzSig,'type','Pearson');
        rC.Pearson{i}(:,booti) = c(triu(ones(size(c)),1) == 1);
    end

    if isfield(data{i}.Processed_Data,'dlx_index')
        idx_inh = find(data{i}.Processed_Data.dlx_index);
        idx_exc = find(data{i}.Processed_Data.dlx_index ~= 1);

        % exc-exc
        sig_ = zSig(idx_exc,idx_exc);
        c = corr(sig_,'type','Pearson');
        C_sub.EE{i} = c(triu(ones(size(c)),1) == 1);

        % inh-inh
        sig_ = zSig(idx_inh,idx_inh);
        c = corr(sig_,'type','Pearson');
        C_sub.II{i} = c(triu(ones(size(c)),1) == 1);

        % exc-inh
        c = corr(zSig,'type','Pearson');
        tmp = c(idx_inh,idx_exc);
        C_sub.EI{i} = tmp(:);
    else
        C_sub.EE{i} = nan;
        C_sub.II{i} = nan;
        C_sub.EI{i} = nan;
    end

end

end