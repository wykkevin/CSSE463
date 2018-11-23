function Image_segment(filename,foldername,line_threshold,word_threshold,letter_threshold)
%% Read Image
imagen = imread(filename);
%% Show image
figure(1)
imshow(imagen);
title('INPUT IMAGE WITH NOISE')
%% Specify Save Path
if ~exist(foldername)
    mkdir(foldername);
end
%% Convert to gray scale
if size(imagen,3)==3 % RGB image
    imagen=rgb2gray(imagen);
end
%% Convert to binary image
threshold = graythresh(imagen);
imagen =~imbinarize(imagen,threshold);
%% Remove all object containing fewer than 30 pixels
imagen = bwareaopen(imagen,30);
%% 
[cropx, cropy]=find(imagen~=0);
minx=min(cropx);
miny=min(cropy);
maxx=max(cropx);
maxy=max(cropy);
imagen=imcrop(imagen,[miny minx maxy-miny maxx-minx]);
%% Show image binary image
figure(2)
imshow(~imagen);
title('INPUT IMAGE WITHOUT NOISE')
%% Label connected components
[transL, Ne]=bwlabel(transpose(imagen));
%% Call the function that separates the lines
separatelines(transL, Ne, foldername, line_threshold, word_threshold, letter_threshold);
