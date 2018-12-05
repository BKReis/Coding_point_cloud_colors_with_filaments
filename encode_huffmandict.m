%Função feita para codificar o dicionário de huffman
%bitstream - Dicionário de Huffman codificado com todos os valores necessários para decodificados já associados a ele
%dictionary  - Dicionário no formato gerado pela função huffmandict do matlab
function bitstream = encode_huffmandict(dictionary)
    dict_length_encoded = dec2bin(size(dictionary,1),8);
    aux = -255;
    bitstream = [dict_length_encoded];
    symbols_bitstream = [];
    
    for i=1:size(dictionary,1)
        %bits_left representa qual o valor que falta do valor aux para o
        %código do dicionário
        bits_left = dictionary{i,1} - aux;
        
        if(bits_left > 255)
           code_length = 0;
           bits_left = 255;
        else 
            code_length = length(dictionary{i,2});
            
        end
        
        aux = dictionary{i,1};
         
        encoded_bits_left = dec2bin(bits_left,8);
        encoded_code_length = dec2bin(code_length,8);
        
        encoded_symbol = convertStringsToChars(strrep(join(string(dictionary{i,2})),' ',''));
        symbols_bitstream = [symbols_bitstream encoded_symbol];
        
        bitstream = [bitstream encoded_bits_left];
        bitstream = [bitstream encoded_code_length];
        
    end
  
    bitstream = [bitstream symbols_bitstream];
end

