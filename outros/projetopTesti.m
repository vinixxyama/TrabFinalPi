% Limpa a área
close all
clear all
clc

pkg image load

bw = imread ('segunda.jpg');
bw = im2bw(bw, graythresh(bw));
RBin = ~imfill(~bw, "holes");
boundaries = bwboundaries (RBin);
boundaries = cell2mat (boundaries);
imshow (RBin);
hold on
plot (boundaries(:,2), boundaries(:,1), '.g');