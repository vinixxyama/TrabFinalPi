% Limpa a área
close all
clear all
clc

pkg image load


%Fun��o respons�vel por marcar os circulos de uma imagem%
function result = num_circ_func (nome_img)
    figure,imshow(nome_img);
    [centers,radii] = imfindcircles(nome_img,[5 30],'ObjectPolarity','dark','sensitivity',0.5,'EdgeThreshold',0.2);
    h = viscircles(centers, radii);
    tam = length(centers);
    result = rows(centers);
    caption = sprintf('valor = %d', rows(centers));
    text(5, 5, caption, 'Color', 'Blue', 'FontSize', 25);
endfunction

%Fun��o respons�vel por encontrar uma peça valida%
function peca = sugestao_peca_func (mesa,mao)
  peca = [-1,-1];
  mesa
  inicio=mesa(1)
  fim=mesa(2)
  encontrou=1;
  
  for i=1: size(mao,2)/2
    if(encontrou==0)%&&(mao(i))(1)==inicio||mao(i*2)==inicio||mao((i*2)-1)==fim||mao(i*2)==fim)
      peca = [mao((i*2)-1),mao(i*2)];
      encontrou=1;
    endif
  endfor
  
endfunction

Escolha = menu("Iniciar a aplicacao?","Sim","Nao");

%Abre o FilePicker - Jogada Inicial%
%helpdlg ("Selecione a imagem com a situacao atual do jogo de domino.","Iniciando Sistema");
%[situacaoatual, caminhodoarquivo, fltidx] = uigetfile ({"*.png;*.jpg;*.jpeg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial")
caminhodoarquivo='./imagens/mesa2.jpeg';
situacaoatual='';
%Abre o FilePicker - M�o do Jogador%
%helpdlg ("Selecione a imagem com a sua mao do jogo de domino.","Selecione a sua mao");
%[maoatual, caminhodoarquivomao, fltidx] = uigetfile ({"*.png;*.jpg;*.jpeg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial")
caminhodoarquivomao='./imagens/mao3.jpeg';
maoatual='';

array_mesa = [];
array_mao = [];
acao = 1;
while(Escolha == 1)
  %Leitura de cenario atual, lendo jogada (acao 1) ou mao (acao 2)%
  
  while (acao == 1 || acao == 2)
    %Abre a imagem selecionada, estado - acao 1 ou mao - acao 2
    if(acao == 1)
      domino = imread([caminhodoarquivo situacaoatual]);
    else
      domino = imread([caminhodoarquivomao maoatual]);
    endif
    %Redimensiona a imagem para facilitar nas manipula��es
    domino = imresize (domino, [306 408]);
    se = strel('square',2);
    domino = imerode(domino,se);
    imshow(domino);
    %Otimiza para segmenta��o
    domino_bw = im2bw(domino, graythresh(domino));
    domino_bw = imfill(domino_bw, 'holes');

    %Mapeia a quantidade de pe�as na jogada
    label = bwlabel(domino_bw);
    qtdobjt = max(max(label));

    %Encontra as coordenadas de todas as pe�as segmentadas, de forma iterativa%
    for j=1:max(max(label))
      [row, col] = find(label==j);
      len=max(row)-min(row)+2;
      breadth=max(col)-min(col)+2;
      target=uint8(zeros([len breadth]));
      sy=min(col)-1;
      sx=min(row)-1;
      
      %Marca a pe�a segmentada, de imagem tratada, na imagem original%
      for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=domino(row(i,1),col(i,1));
      end
      %Exibe o n�mero da pe�a%
      mytitle=strcat('Numero da Peca:', num2str(j));
      figure,imshow(target);title(mytitle);
      
      %Observa a disposi��o da pe�a para corte, horizontal ou vertical%
      peca_circ = im2bw(target, graythresh(domino));
      if (rows(peca_circ) > columns(peca_circ))
        %Corta a pe�a vertical nas duas extremidades poss�veis%
        n=fix(size(peca_circ,1)/2);
        A=peca_circ(1:n,:,:);
        B=peca_circ(n+1:end,:,:);
        
        %Conta os numeros da extremidade e exibe%
        qtd_extr = [num_circ_func(A),num_circ_func(B)];
        if (acao == 1)
          array_mesa = [array_mesa, {qtd_extr}];
        else
          array_mao = [array_mao, {qtd_extr}];
        endif
        
      else
      
        %Corta a peca horizontal nas duas extremidades possiveis%
        A = peca_circ(:, fix(1:end/2), :);
        B = peca_circ(:, fix(end/2+1):end, :);
        %Conta os numeros da extremidade e exibe%
        qtd_extr = [num_circ_func(A), num_circ_func(B)];
        if (acao == 1)
          array_mesa = [array_mesa, {qtd_extr}];
        else
          array_mao = [array_mao, {qtd_extr}];
        endif
        
      endif
      
    endfor
    
    acao++;
  endwhile
  
  %Processa dados
  while(acao == 3)
    %Exibe o n�mero da pe�a%
    peca_suger=sugestao_peca_func(array_mesa,array_mao);
    mytitle=strcat('Sugestao de Peca: [', num2str(peca_suger(1)));
    mytitle=strcat(mytitle, ',');
    mytitle=strcat(mytitle, num2str(peca_suger(2)));
    mytitle=strcat(mytitle, ']');
    msgbox(mytitle,"Sugestao");
    acao++;
  endwhile
  
  Escolha = menu("Continuar para proxima etapa?","Sim","Nao");
endwhile
errordlg("A aplicacao foi abortada pelo usuario","Fim");

close all
