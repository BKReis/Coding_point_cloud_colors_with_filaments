%Fun??o inspirada do c?digo do VLC passado no moodle
%function writeBitstreamToFile(bitstream, filename)
%
%  Escreve o bitstream em um arquivo bin?rio.
%
% - Recebe como par?metro:
%   bitstream: o bitstream a ser escrito.
%   filename : o nome do arquivo.
%
% O formato do arquivo ? o seguinte: 
%
%  Header: 2 bytes (16 bits) com o n?mero de bits no bitstream
%  Data  : os dados do bitstream. Os ?ltimos bits s?o colocados como 0, at?
%  o pr?ximo m?ltiplo de 8.
% 
function writeBitstreamToFile(bitstream, filename)

%Pega o tamanho do bitstream.
n = length(bitstream);

%Calcula quantos headers ser?o necess?rios para escrever a quantidade de
%bits
if (n > 65535)
    numberOfTimes = ceil(n/65535);
else
    numberOfTimes = 1;
end

%Calcula o n?mero de bytes a escrever.
n8 = ceil(n/8);

%Concatena zeros para completar um m?ltiplo de 8.
bitstream = [bitstream dec2bin(0,n8*8 - n)];
% bitstream = bitstream.';

%Transforma o bitstream que est? em bits para um array de uint8.
bitstream2 = zeros(ceil(n/8),1);
for (i = 1:1:length(bitstream2))
    bitstream2(i) = bin2dec(bitstream((i-1)*8 + 1: i*8));    
end

auxN = n;
auxMax = 65535;
%Abre arquivo
fid = fopen(filename,'wb');

%Escreve primeiro quantos headers s?o necess?rios para escrever todos os
%bits e depois escreve header por header de 65535 bits, at? o ?ltimo que
%completa a quantidade total de bits que ser?o escritas
fwrite(fid, numberOfTimes, 'uint8');
for(i=1:1:numberOfTimes)
    if numberOfTimes ~= i
        fwrite(fid, auxMax, 'uint16');
        auxN = auxN - 65535;
    else
        fwrite(fid, auxN, 'uint16');
    end
end
fwrite(fid, bitstream2, 'uint8');
fclose(fid);

