function Rcoeff=norm_corr(deltaF)

% Computation of the correlation coefficients
norm_deltaF=normalize(deltaF,"zscore");
Rcoeff = corr(norm_deltaF); % Supported for code generation
% Rcoeff_matrix = corr(series.Data); % Not supported for code generation
% Graphical results

end