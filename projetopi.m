% Limpa a área
close all
clear all
clc

pkg image load

domino=imread('45.jpg');
bdomino = im2bw(domino);
dominogray = rgb2gray(domino);
%[rows, columns, numberOfColorChannels] = size(dominogray);
%topHalf = imcrop(dominogray, [1, 1, columns, floor(rows/2)]);
%bottomHalf = imcrop(dominogray, [1, ceil(rows/2), columns, floor(rows/2)]);
%imshow(topHalf);
%imshow(bottomHalf);
n=fix(size(domino,1)/2);
A=domino(1:n,:,:);
B=domino(n+1:end,:,:);
imshow(A);
[centers,radii] = imfindcircles(A,[4 8],'ObjectPolarity','dark','sensitivity',0.9);
h = viscircles(centers, radii);
tam = length(centers);
caption = sprintf('valor = %d', tam);
text(50, 10, caption, 'FontSize', 20);
figure;
imshow(B);
[centers,radii] = imfindcircles(B,[4 8],'ObjectPolarity','dark','sensitivity',0.9);
h = viscircles(centers, radii);
tam = length(centers);
caption = sprintf('valor = %d', tam);
text(50, 0, caption, 'FontSize', 20);
fullImage = cat(2,B,A);
figure;
imshow(fullImage);
