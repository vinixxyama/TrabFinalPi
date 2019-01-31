% Limpa a área
close all
clear all
clc

pkg image load

%tirar fotos do msm angulo
%subtrair a primeira com a proxima jogada
%salvar a primeira jogada em uma variavel
%sempre subtrair a proxima jogada da anterior e manter a primeira jogada para saber uma das extremidades

frame = javaObject("javax.swing.JFrame");
frame.setBounds(0,0,100,100);
frame.setVisible(true);
fc = javaObject ("javax.swing.JFileChooser")
returnVal = fc.showOpenDialog(frame);
file = fc.getSelectedFile();
file.getName()

domino = imread('1.jpg');
domino = im2bw(domino, graythresh(domino));
imshow(domino);
[centers,radii] = imfindcircles(domino,[60 120],'ObjectPolarity','dark','sensitivity',0.85);
h = viscircles(centers, radii);
tam = length(centers);
caption = sprintf('valor = %d', tam-1);
text(50, 0, caption, 'FontSize', 20);

%segchannel segmentaçcao por canal de cor

