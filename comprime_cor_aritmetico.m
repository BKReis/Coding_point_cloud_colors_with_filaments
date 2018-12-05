function [arit, valores, ocorrencias] = comprime_cor_aritmetico(cor)
    valores = unique(cor);
    ocorrencias = histcounts(cor, length(valores));
    [~,idx] = ismember(cor, valores);
    
    arit = arithenco(idx, ocorrencias);

    %arit é o comprimido
    %valores quais possivelmente ocorrem
    %ocorrencias de cada valor