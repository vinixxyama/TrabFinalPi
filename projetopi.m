% Limpa a área
close all
clear all
clc

pkg image load

%tirar fotos do msm angulo
%subtrair a primeira com a proxima jogada
%salvar a primeira jogada em uma variavel
%sempre subtrair a proxima jogada da anterior e manter a primeira jogada para saber uma das extremidades
domino=imread('2.jpg');
domino2=imread('3.jpg');
domino2=rgb2gray(domino2);
domino=rgb2gray(domino);
domino3 = domino2-domino;
imshow(domino3);
figure;
[centers,radii] = imfindcircles(domino3,[30 50],'ObjectPolarity','dark','sensitivity',0.9);
imshow(domino3);
h = viscircles(centers, radii);
tam = length(centers);
caption = sprintf('valor = %d', tam);
text(0, 10, caption, 'FontSize', 20);
%n=fix(size(domino,1)/2);
%A=domino(1:n,:,:);
%B=domino(n+1:end,:,:);
%imshow(A);
%[centers,radii] = imfindcircles(A,[5 10],'ObjectPolarity','dark','sensitivity',0.9);
%h = viscircles(centers, radii);
%tam = length(centers);
%caption = sprintf('valor = %d', tam);
%text(50, 10, caption, 'FontSize', 20);
%figure;
%imshow(B);
%[centers,radii] = imfindcircles(B,[20 50],'ObjectPolarity','dark','sensitivity',0.5);
%h = viscircles(centers, radii);
%tam = length(centers);
%caption = sprintf('valor = %d', tam);
%text(50, 0, caption, 'FontSize', 20);
%fullImage = cat(2,B,A);
%figure;
%imshow(fullImage);

%segchannel segmentaçcao por canal de cor

