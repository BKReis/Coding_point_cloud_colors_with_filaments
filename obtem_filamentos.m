% TODO: armazenar esses pontos de alguma forma
% TODO: fazer uma forma de pegar um ponto dos extremos
% TODO: definir um limiar bom
function [ret, eixo, val_eixo] = obtem_filamentos(corte)
    % Descobre de qual eixo é o corte e seu valor
    axis = sscanf(corte, 'cortes/corte_%c=%d.jpeg');
    
    % Lê o arquivo e pega as posicoes com pontos
    G = imread(corte);
    F = G(:,:) == 0;
    [x, y] = find(F);
    posicoes = [x-1, y-1];
    eixo = axis(1);
    val_eixo = axis(2);
    % le o primeiro ponto arbitrariamente e comeca a montar os pontos mais
    % proximos
    index = 1;
    i = 1;
    j = 1;
    limiar = 10;
    while ~isempty(posicoes)
        % adiciona o ponto escolhido a lista de pontos e o remove da lista
        % de posicoes para calcular o ponto mais proximo
        pontos{j,i} = posicoes(index,:);
        posicoes(index,:) = [];
        % escolhe o ponto mais proximo e sua distancia
        if ~isempty(posicoes)
            [index, dist] = ponto_mais_proximo(pontos{j,i},posicoes);
        else
            dist = 0;
        end
%         % adiciona a coordenada do corte ao ponto
%         if (axis(1) == 'x') pontos{j,i} = [axis(2) pontos{j,i}];  end
%         if (axis(1) == 'y') 
%             pontos{j,i} = [pontos{j,i}(1) axis(2) pontos{j,i}(2)];
%         end
%         if (axis(1) == 'z') pontos{j,i} = [pontos{j,i} axis(2)];  end
        
        i = i + 1;
        % se o ponto for mais distante que o limiar comeca uma nova linha
        % de pontos
        if dist > limiar
%             if i==2
%                 pontos(j,:) = [];
%                 i = 1;
%             else
                j = j+1;
                i = 1;    
%             end  
       
        end
    end
    if ~exist('filamentos', 'dir')
        mkdir('filamentos');
    end
    for i = 1:length(pontos(:,1))
        M = cell2mat(pontos(i,:)');
        M = M(:,1:2);
        g = zeros(512,512);
        for j = 1:length(M(:,1))
            g(M(j,1),M(j,2)) = 1;
        end
        g = not(g);
        imwrite(g, ['filamentos/filamento_' char(axis(1)) '=' num2str(axis(2)) '_' num2str(limiar) '_' num2str(i) '.png']);
    end
    ret = pontos;
end

% funcao auxiliar para encontrar o ponto mais proximo
function [index, dist] = ponto_mais_proximo(point, array)
    distances = sqrt(sum(bsxfun(@minus, array, point).^2,2));
    index = find(distances==min(distances));
    index = index(1);
    dist = distances(index);
    dist = dist(1);
end