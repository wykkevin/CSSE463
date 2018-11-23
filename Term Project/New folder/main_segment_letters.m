%% Image segmentation and extraction
% This is the main file that we will execute. The result it will be first 
% divide each line from a paragraph, then divide each word from a line, and
% finally divide each letter from the word. We will use the result as the
% tests in AlexNet and get their outputs.
clc
clear variables
close all
% This is the path where we store the padding and padding image function
addpath('C:\Users\patri\Dropbox\TermProject\Coding');

% Enter the name of the file, the name of the folder that you want to store
% and the number of lines in the given image.
filename = 'test3.jpg';
foldername = 'own';
lines = 7;

% Main process the image to throw out noises.
imagen = imread(filename);

if size(imagen,3)==3 % RGB image
    imagen=rgb2gray(imagen);
end

threshold = graythresh(imagen);
imagen =~imbinarize(imagen,threshold);
imagen = bwareaopen(imagen,30);

[cropx, cropy]=find(imagen~=0);
minx=min(cropx);
miny=min(cropy);
maxx=max(cropx);
maxy=max(cropy);
imagen=imcrop(imagen,[miny minx maxy-miny maxx-minx]);
% We make all the input image to the same size to get the threshold more
% accurately.
[imagen, isImg] = padding_image(imagen, 1000, 700);

black = length(find(imagen==1));
white = length(find(imagen==0));
ratio = black/white;
[row, column] = size(imagen);
resolute = row * column;
btor = black/resolute; 

[zerox, zeroy] = find(imagen~=0);
xmin = min(zerox);
xmax = max(zerox);

% More flexible method, but does not guaranteed to work for all images.
% It have fixed coefficient for the same style of handwritting.
line_threshold = (xmax-xmin)/lines/2.2;
word_threshold = 1.3 * line_threshold;
letter_threshold = word_threshold/4;

% The version of fixed threshold
%line_threshold = 50; 
%word_threshold = 700; 
%letter_threshold = 20; 
Image_segment(filename, foldername, line_threshold, ...
              word_threshold, letter_threshold);