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
    %Formata o nome do diretório com o arquivo para slice
    slice = sprintf('cortes/corte_z=%d.png', j);
    [filamentos, eixo, val_eixo] = obtem_filamentos(slice);

    num_filamentos = length(filamentos(:,1));
    
    %Calcula tamanho dos filamentos e bota em um vetor para gerar
    %histograma posteriormente
    idx_aux = sum(~cellfun(@isempty,filamentos),2);
    idx = [idx
        idx_aux];

    num_filamentos = length(filamentos(:,1));
   

    %Itera sobre os filamentos para pegar o vetor de cores
    for k = 1:num_filamentos
        cores = obtem_cores(PtCloud, filamentos(k,:), eixo, val_eixo);
        red = cores(:,1)';
        green = cores(:,2)';
        blue = cores(:,3)';
        
        diffencodedred = diffencodevec(red);
        diffencodedgreen = diffencodevec(green);
        diffencodedblue = diffencodevec(blue);
        
        %Codificação Huffman e escrita em arquivo da cor vermelha
        [redhuf reddict] = comprime_cor_huffman(diffencodedred);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Preparação do dicionário para escrita
%         redcodes = {reddict{:,2}};
%         for (i = 1:length(redcodes(1,:)))
%             redcodesvector(1,i) = strrep(join(string(cell2mat(redcodes(1,i)))),' ','');
%         end
      
%         redsymbols = cell2mat(reddict(:,1));
        %Transpose matrix
%         redsymbols = redsymbols.';
        red_dict_bitstream = (encode_huffmandict(reddict));
        bitstream = [bitstream red_dict_bitstream];
        
        redhuf = strrep(join(num2str(redhuf)),' ','');
        red_aux = dec2bin(length(redhuf),16);
%         redhuf = [dec2bin(length(redhuf),16) redhuf];
        bitstream = [bitstream red_aux redhuf];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Codificação Huffman e escrita em arquivo da cor verde
        [greenhuf greendict] = comprime_cor_huffman(diffencodedgreen);
         
        green_dict_bitstream = encode_huffmandict(greendict);
        bitstream = [bitstream green_dict_bitstream];
        
        greenhuf = strrep(join(num2str(greenhuf)),' ','');
%         greenhuf = [dec2bin(length(greenhuf),16) greenhuf];
        green_aux = dec2bin(length(greenhuf),16);
        bitstream = [bitstream green_aux greenhuf];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Codificação Huffman e escrita em arquivo da cor azul
        [bluehuf bluedict] = comprime_cor_huffman(diffencodedblue);

        
        blue_dict_bitstream = (encode_huffmandict(bluedict));
        bitstream = [bitstream blue_dict_bitstream];

        bluehuf = strrep(join(num2str(bluehuf)),' ','');
%         bluehuf = [dec2bin(length(bluehuf),16) bluehuf];
        blue_aux = dec2bin(length(bluehuf),16);
        bitstream = [bitstream blue_aux bluehuf];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    
end
% 
% bitstream = strrep(join(num2str(bitstream)),' ','');
bitstream = strrep(join(bitstream),' ','');
writeBitstreamToFile(bitstream,'encodedFileRedAndBlackMTDF.bin');

figure;
histogram(idx);


