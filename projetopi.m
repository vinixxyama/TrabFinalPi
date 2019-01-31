% Limpa a área
close all
clear all
clc

pkg image load

%tirar fotos do msm angulo
%subtrair a primeira com a proxima jogada
%salvar a primeira jogada em uma variavel
%sempre subtrair a proxima jogada da anterior e manter a primeira jogada para saber uma das extremidades

helpdlg ("Selecione a imagem com a peca inicial do jogo de domino.","Iniciando Sistema");
[jogadainicial, caminhodoarquivo, fltidx] = uigetfile ({"*.png;*.jpg", "Tipos de Imagens Suportadas"},"Selecione o arquivo inicial")

domino = imread([caminhodoarquivo jogadainicial]);
domino = im2bw(domino, graythresh(domino));
imshow(domino);
[centers,radii] = imfindcircles(domino,[60 120],'ObjectPolarity','dark','sensitivity',0.85);
h = viscircles(centers, radii);
tam = length(centers);
caption = sprintf('valor = %d', tam-1);
text(80, 90, caption, 'Color', 'red', 'FontSize', 20);
cc = bwconncomp(domino);
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
figure;
imshow(RGB_label,'InitialMagnification','fit');

%<<<<<<< HEAD
%=======
%>>>>>>> 12c2e84ee446acefbcfe9baf3e5452242babeb08
%segchannel segmentaçcao por canal de cor

