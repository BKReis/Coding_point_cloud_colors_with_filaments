function [huff, dict] = comprime_cor_huffman(cor)
    valores = unique(cor);
    
    ocorrencias = zeros(size(valores));
    
    for (i = 1:1:length(valores))
        ocorrencias(i) = sum( cor == valores(i));
    end
    
    frequencias = ocorrencias/length(cor);
    
    if length(valores) == 1
         huff = 0;
         dict = {num2str(valores), 0};
    else
        dict = huffmandict(valores, frequencias);
        huff = huffmanenco(cor, dict);
    end