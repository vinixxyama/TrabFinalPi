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
function [mesa, mao, pecas_mesa, pecas_mao, fimdejogo] = sugestao_peca_func(mesa,mao,rodada,pecas_mesa, pecas_mao)
  fimdejogo = 0;
  subplot(2,1,1), imshow(cell2mat(pecas_mesa)), title('MESA');
  
  hold on
  %Desenha linhas no inicio e no fim%
  g_pos=numel(cell2mat(pecas_mesa))/200;
  plot([0,0],[50,150],'Color', 'b', 'LineWidth', 4, 'LineStyle', ':');
  plot([g_pos,g_pos],[50,150],'Color', 'g', 'LineWidth', 4, 'LineStyle', ':');
  
  if(numel(mao)>0)      
    subplot(2,1,2), imshow(cell2mat(pecas_mao)), title('MÃO');
  else
    WIN=imread("./imagens/win.jpeg");
    subplot(2,1,2), imshow(WIN), title('MÃO VAZIA!');
  endif
  
  %Procura pecas para sugerir%
  
  inicio=(mesa{1})(1,1);
  fim=(mesa{numel(mesa)})(1,2);
  encontrou_inicio=0;
  encontrou_fim=0;
  idx_peca_inicio=0;
  idx_peca_fim=0;
  idx_peca=0;
  destino=0;
  
  for i=1: numel(mao)
    if(encontrou_inicio==0&&((mao{i})(1,1)==inicio||(mao{i})(1,2)==inicio))
      idx_peca=idx_peca_inicio=i;
      encontrou_inicio=1;
      destino=1;
    elseif(encontrou_fim==0&&((mao{i})(1,1)==fim||(mao{i})(1,2)==fim))
      idx_peca=idx_peca_fim=i;
      encontrou_fim=1;
      destino=2;
    endif
  endfor
  
  %Desenha retangulos nas opções sugeridas%
  if(encontrou_inicio==1)
    r_width = 98; 
    r_height = 198;
    
    xCenter = 0; 
    for i=1 : idx_peca_inicio-1
      xCenter+=numel(pecas_mao{i})/200;
    endfor
    xCenter+=numel(pecas_mao{idx_peca_inicio})/400;
    
    yCenter = 100; 
    xLeft = xCenter - r_width/2;
    yBottom = yCenter - r_height/2;
    rectangle('Position', [xLeft, yBottom, r_width, r_height], 'EdgeColor', 'b', 'LineWidth', 4);
  endif  
  if(encontrou_fim==1)
    r_width = 98; 
    r_height = 198;
    
    xCenter = 0; 
    for i=1 : idx_peca_fim-1
      xCenter+=numel(pecas_mao{i})/200;
    endfor
    xCenter+=numel(pecas_mao{idx_peca_fim})/400;
    
    yCenter = 100; 
    xLeft = xCenter - r_width/2;
    yBottom = yCenter - r_height/2;
    rectangle('Position', [xLeft, yBottom, r_width, r_height], 'EdgeColor', 'g', 'LineWidth', 4);
  endif
  
  %Escolha uma das opcoes%
  if(encontrou_fim==1&&encontrou_inicio==1&&idx_peca_fim!=idx_peca_inicio)
    txt="Escolha uma das peças sugeridas:\n\n";
    txt=strcat(txt,"Azul: ");
    txt=strcat(txt,mat2str(mao{idx_peca_inicio}));
    txt=strcat(txt,"\tVerde: ");
    txt=strcat(txt,mat2str(mao{idx_peca_fim}));
    op = questdlg(txt,"Escolha","Azul","Verde","Azul");
    if(strcmp(op,"Azul"))
      idx_peca=idx_peca_inicio;
      destino=1;
    else
      idx_peca=idx_peca_fim;
      destino=2;
    endif
  elseif(encontrou_fim==1||encontrou_inicio==1)
    txt="Peca sugerida:\n";
    txt=strcat(txt,mat2str(mao{idx_peca}));
    helpdlg(txt,"Continue");
  endif
  
  hold off
  
  if(idx_peca!=0)
    %Coloca na mesa%
    %Gira a peca se os numeros forem diferentes%
    if(mao{idx_peca}(1,1)!=mao{idx_peca}(1,2))
      pecas_mao{idx_peca}=imrotate(pecas_mao{idx_peca},90);
    endif
    if(destino==1)
      %No inicio%
      %Gira a peca%
      if(mao{idx_peca}(1,2)!=inicio)
        aux=mao{i}(1,1);
        mao{idx_peca}(1,1)=mao{idx_peca}(1,2);
        mao{idx_peca}(1,2)=aux;
        pecas_mao{idx_peca}=imrotate(pecas_mao{idx_peca},180);
      endif
      mesa=[{mao{idx_peca}} mesa];
      pecas_mesa=[{pecas_mao{idx_peca}} pecas_mesa];
      
    elseif(destino==2)
      %No final%
      %Gira a peca%
      if(mao{idx_peca}(1,1)!=fim)
        aux=mao{idx_peca}(1,1);
        mao{idx_peca}(1,1)=mao{idx_peca}(1,2);
        mao{idx_peca}(1,2)=aux;
        pecas_mao{idx_peca}=imrotate(pecas_mao{idx_peca},180);
      endif
      
      
      mesa=[mesa {mao{idx_peca}}];
      pecas_mesa=[pecas_mesa {pecas_mao{idx_peca}}];
    endif
    %Remove a peca da mao%
    mao(idx_peca)=[];
    pecas_mao(idx_peca)=[];
  else
    msg="";
    if(numel(mao)==0)
      msg=strcat(msg,"\nParabéns! Você ganhou!");
    else
      msg=strcat(msg,"Voce ficou sem mais jogadas possíveis!\nNão foi dessa vez...");
    endif
    helpdlg (msg,"Fim do jogo");
    fimdejogo=1;
    close all
  endif
  
endfunction

Escolha = questdlg("Iniciar a aplicacao?","Iniciar","Sim","Nao","Sim");

if(strcmp(Escolha,"Sim"))
  %Abre o FilePicker - Jogada Inicial%
  helpdlg ("Selecione a imagem com a situacao atual do jogo de domino.","Iniciando Sistema");
  [situacaoatual, caminhodoarquivo, fltidx] = uigetfile ({"*.png;*.jpg;*.jpeg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial");
  %caminhodoarquivo='./imagens/mesa1.jpeg';
  %situacaoatual='';
  %Abre o FilePicker - M�o do Jogador%
  helpdlg ("Selecione a imagem com a sua mao do jogo de domino.","Selecione a sua mao");
  [maoatual, caminhodoarquivomao, fltidx] = uigetfile ({"*.png;*.jpg;*.jpeg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial");
  %caminhodoarquivomao='./imagens/mao1.jpeg';
  %maoatual='';
endif

array_mesa = [];
array_mao = [];
pecas_mesa = [];
pecas_mao = [];
fundo=ones(50,200).*255;
acao = 1;
fimdejogo=0;

while(strcmp(Escolha,"Sim") && fimdejogo == 0)
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
    
    imshow(domino);
    %Otimiza para segmenta��o
    domino_bw = im2bw(domino, graythresh(domino));
    domino_bw = imerode(domino_bw,se);
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
      %Exibe o n�mero da peça%
      mytitle=strcat('Numero da Peça:', num2str(j));
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
          if(qtd_extr(1,1)!=qtd_extr(1,2))
            pecas_mesa = [pecas_mesa, { [ fundo; imrotate(imresize(target,[200 100]),90,"nearest");fundo ] }];
          else
            pecas_mesa = [pecas_mesa, { imresize(target,[200 100])}];
          endif
        else
          array_mao = [array_mao, {qtd_extr}];
          if(qtd_extr(1,1)!=qtd_extr(1,2))
            pecas_mao = [pecas_mao, { [ fundo' imresize(target,[200 100]) fundo' ] } ];
          else
            pecas_mao = [pecas_mao, { imresize(target,[200 100])} ];
          endif
        endif
      else
        %Corta a peca horizontal nas duas extremidades possiveis%
        A = peca_circ(:, fix(1:end/2), :);
        B = peca_circ(:, fix(end/2+1):end, :);
        %Conta os numeros da extremidade e exibe%
        qtd_extr = [num_circ_func(A), num_circ_func(B)];
        if (acao == 1)
          array_mesa = [array_mesa, {qtd_extr}];
          if(qtd_extr(1,1)!=qtd_extr(1,2))
            pecas_mesa = [pecas_mesa, { [ fundo;imresize(target,[100 200]);fundo] } ];
          else
            pecas_mesa = [pecas_mesa, { imrotate(imresize(target,[100 200]),90,"nearest") } ];
          endif
        else
          array_mao = [array_mao, {qtd_extr}];
          if(qtd_extr(1,1)!=qtd_extr(1,2))
            pecas_mao = [pecas_mao, { [ fundo' imrotate(imresize(target,[100 200]) ,270,"nearest") fundo']}];
          else
            pecas_mao = [pecas_mao, { imrotate(imresize(target,[100 200]) ,270,"nearest") }];
          endif
        endif
      endif
    endfor
    acao++;
    
  endwhile
  Escolha = questdlg("Continuar para proxima etapa?","Continuar","Sim","Nao","Sim");
  
  figure,
  %Processa dados
  while(strcmp(Escolha,"Sim")&&fimdejogo==0)
    [array_mesa,array_mao,pecas_mesa,pecas_mao,fimdejogo]=sugestao_peca_func(array_mesa,array_mao, acao-2,pecas_mesa, pecas_mao);
  endwhile
  acao++;
endwhile

if(fimdejogo==0)
  errordlg("A aplicacao foi abortada pelo usuario","Fim");
endif

close all
