function cores = obtem_cores(ptCloud ,filamento, eixo, val_eixo)
    % colocar eixo no lugar certo
    linha = cell2mat(filamento');
    
    num_pontos = length(linha(:,1));
    val_linha = ones(num_pontos,1)*val_eixo;
    eixos = ['x','y','z'];
    coordenada = find(eixos == eixo);
    if (~any(eixos == eixo))
        error('Coordenada invalida');
    end
    
    if(eixo == 'x') linha = [val_linha linha]; end
    if(eixo == 'y') linha = [linha(:,1) val_linha linha(:,2)]; end
    if(eixo == 'z') linha = [linha val_linha]; end
    
    %descobrir pq nem todos os pontos são encontrados no ismember
    %rodar ismember para cada filamento
    idx = find(ismember(ptCloud.Location, linha, 'rows'));
    cores = ptCloud.Color(idx, :);
    %usar select nos pontos obtidos
    %retornar as cores