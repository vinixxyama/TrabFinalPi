% Limpa a Ã¡rea
close all
clear all
clc

pkg image load

array_cenario = [-1, -1];
array_mao = [-1, -1];
%Função responsável por marcar os circulos de uma imagem%
function result = num_circ_func (nome_img)
    figure,imshow(nome_img);
    [centers,radii] = imfindcircles(nome_img,[5 25],'ObjectPolarity','dark','sensitivity',0.5,'EdgeThreshold',0.3);
    h = viscircles(centers, radii);
    tam = length(centers);
    result = rows(centers);
    caption = sprintf('valor = %d', rows(centers));
    text(5, 5, caption, 'Color', 'Blue', 'FontSize', 25);
endfunction

Escolha = menu("Iniciar a aplicacao?","Sim","Nao");

while(Escolha == 1)
  %Abre o FilePicker - Jogada Inicial%
  helpdlg ("Selecione a imagem com a situacao atual do jogo de domino.","Iniciando Sistema");
  [situacaoatual, caminhodoarquivo, fltidx] = uigetfile ({"*.png;*.jpg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial")

  %Abre o FilePicker - Mão do Jogador%
  helpdlg ("Selecione a imagem com a sua mao do jogo de domino.","Selecione a sua mao");
  [maoatual, caminhodoarquivomao, fltidx] = uigetfile ({"*.png;*.jpg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial")

  %Leitura de cenario atual%
  acao = 1;
  while (acao == 1 || acao == 2)
    %Abre a imagem selecionada, estado - acao 1 ou mao - acao 2
    if(acao == 1)
      domino = imread([caminhodoarquivo situacaoatual]);
    else
      domino = imread([caminhodoarquivomao maoatual]);
    endif
    %Redimensiona a imagem para facilitar nas manipulações
    domino = imresize (domino, [306 408]);
    imshow(domino);
    %Otimiza para segmentação
    domino_bw = im2bw(domino, graythresh(domino));
    domino_bw = imfill(domino_bw, 'holes');

    %Mapeia a quantidade de peças na jogada
    label = bwlabel(domino_bw);
    qtdobjt = max(max(label));

    %Encontra as coordenadas de todas as peças segmentadas, de forma iterativa%
    for j=1:max(max(label))
      [row, col] = find(label==j);
      len=max(row)-min(row)+2;
      breadth=max(col)-min(col)+2;
      target=uint8(zeros([len breadth]));
      sy=min(col)-1;
      sx=min(row)-1;
      
      %Marca a peça segmentada, de imagem tratada, na imagem original%
      for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=domino(row(i,1),col(i,1));
      end
      %Exibe o número da peça%
      mytitle=strcat('Numero da Peça:', num2str(j));
      figure,imshow(target);title(mytitle);
      
      %Observa a disposição da peça para corte, horizontal ou vertical%
      peca_circ = im2bw(target, graythresh(domino));
      if (rows(peca_circ) > columns(peca_circ))
        %Corta a peça vertical nas duas extremidades possíveis%
        n=fix(size(peca_circ,1)/2);
        A=peca_circ(1:n,:,:);
        xyz = num_circ_func(A);
        if (acao == 1)
          array_cenario = [array_cenario, xyz];
        else
          array_mao = [array_mao, xyz];
        endif
        B=peca_circ(n+1:end,:,:);
        xyz = num_circ_func(B);
        if (acao == 1)
          array_cenario = [array_cenario, xyz];
        else
          array_mao = [array_mao, xyz];
        endif
      else
        %Corta a peça horizontal nas duas extremidades possiveis%
        A = peca_circ(:, 1:end/2, :);
        xyz = num_circ_func(A);
        if (acao == 1)
          array_cenario = [array_cenario, xyz];
        else
          array_mao = [array_mao, xyz];
        endif
        B = peca_circ(:, end/2+1:end, :);
        xyz = num_circ_func(B);
        if (acao == 1)
          array_cenario = [array_cenario, xyz];
        else
          array_mao = [array_mao, xyz];
        endif
      endif
      
    endfor
    acao = acao + 1;
  endwhile
  Escolha = menu("Continuar para proxima etapa?","Sim","Nao");
endwhile
errordlg("A aplicacao foi abortada pelo usuario","Fim");