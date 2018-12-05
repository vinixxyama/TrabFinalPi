domino=imread('domino.jpeg');
gray = rgb2gray(domino);
centers = imfindcircles(domino,[6 10],'ObjectPolarity','dark','sensitivity',0.9)
imshow(domino)
h = viscircles(centers,radii);
length(centers)