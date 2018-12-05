function [bitstream] = encode_first_elements(first_element_vector, idx_aux)
    vector_size = size(first_element_vector,2);
    idx_aux_size = size(idx_aux,1);
    encoded_size = dec2bin(vector_size,8);
    
    bitstream = encoded_size;
    
    for i=1:idx_aux_size
        encoded_element = dec2bin(idx_aux(i),16);
        bitstream = [bitstream encoded_element];
    end
    
    
    for i=1:vector_size
        encoded_element = dec2bin(first_element_vector(i),8);
        bitstream = [bitstream encoded_element];
    end
    
end

