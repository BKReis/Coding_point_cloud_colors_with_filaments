clearvars
clc

filename = sprintf("ply/redandblack_vox10_1555.ply", i);
PtCloud = pcread(filename);
zs = PtCloud.ZLimits;
z_min = zs(1);
z_max = zs(2);
corte_xyz(filename, 'z');
bitstream = [];
idx = [];


for j = z_min:z_max
    first_red_element = [];
    first_green_element = [];
    first_blue_element = [];
    
    diffencodedredfinal = [];
    diffencodedgreenfinal = [];
    diffencodedbluefinal = [];
    
    %Formata o nome do diretório com o arquivo para slice
    slice = sprintf('cortes/corte_z=%d.png', j);
    [filamentos, eixo, val_eixo] = obtem_filamentos(slice);
    
    %Calcula tamanho dos filamentos e bota em um vetor para gerar
    %histograma posteriormente
    idx_aux = sum(~cellfun(@isempty,filamentos),2);
    idx = [idx
        idx_aux];

    num_filamentos = length(filamentos(:,1));
   

    %idx = sum(~cellfun(@isempty,filamentos),2);
    %Itera sobre os filamentos para pegar o vetor de cores
    for k = 1:num_filamentos
        cores = obtem_cores(PtCloud, filamentos(k,:), eixo, val_eixo);
        red = cores(:,1)';
        green = cores(:,2)';
        blue = cores(:,3)';
        
        %Codifica diferencialmente o elemento
        diffencodedred = diffencodevec(red);
        diffencodedgreen = diffencodevec(green);
        diffencodedblue = diffencodevec(blue);
        
        %Monta o vetor com o valor do primeiro elemento para cada filamento
        first_red_element = [first_red_element diffencodedred(1)];
        first_green_element = [first_green_element diffencodedgreen(1)];
        first_blue_element = [first_blue_element diffencodedblue(1)];
        
        %Remove o valor codificado diferencialmente do bitstream que será
        %escrito
        diffencodedred(1) = [];
        diffencodedgreen(1) = [];
        diffencodedblue(1) = [];
        
        %Transforma todas as cores em somente um vetor único para
        %codifição por Huffman
 
        diffencodedredfinal = [diffencodedredfinal diffencodedred];
        diffencodedgreenfinal = [diffencodedgreenfinal diffencodedgreen];
        diffencodedbluefinal = [diffencodedbluefinal diffencodedblue];
    end
    
        encoded_blue_first_elements = encode_first_elements(first_blue_element,idx_aux);
        encoded_green_first_elements = encode_first_elements(first_green_element,idx_aux);
        encoded_red_first_elements = encode_first_elements(first_red_element,idx_aux);
        
        bitstream = [bitstream encoded_red_first_elements];        
        bitstream = [bitstream encoded_green_first_elements];
        bitstream = [bitstream encoded_blue_first_elements];
        
        
    %Codificação Huffman e escrita em arquivo da cor vermelha
        [redhuf reddict] = comprime_cor_huffman(diffencodedredfinal);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        red_dict_bitstream = (encode_huffmandict(reddict));
        bitstream = [bitstream red_dict_bitstream];
        
        redhuf = strrep(join(num2str(redhuf)),' ','');
        redhuf = [dec2bin(length(redhuf),16) redhuf];
        bitstream = [bitstream redhuf];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Codificação Huffman e escrita em arquivo da cor verde
        [greenhuf greendict] = comprime_cor_huffman(diffencodedgreenfinal);
      
        
        green_dict_bitstream = encode_huffmandict(greendict);
        bitstream = [bitstream green_dict_bitstream];
        
        greenhuf = strrep(join(num2str(greenhuf)),' ','');
        greenhuf = [dec2bin(length(greenhuf),16) greenhuf];
        bitstream = [bitstream greenhuf];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Codificação Huffman e escrita em arquivo da cor azul
        [bluehuf bluedict] = comprime_cor_huffman(diffencodedbluefinal);
                 
        blue_dict_bitstream = (encode_huffmandict(bluedict));
        bitstream = [bitstream blue_dict_bitstream];

        bluehuf = strrep(join(num2str(bluehuf)),' ','');
        bluehuf = [dec2bin(length(bluehuf),16) bluehuf];
        bitstream = [bitstream bluehuf];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
end

bitstream = strrep(join(bitstream),' ','');
writeBitstreamToFile(bitstream,'encodedFileRedAndBlackMTDC.bin');




