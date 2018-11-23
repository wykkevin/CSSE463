close all hidden;
clear;
clc;
%read the image, we only need to change the name to read different pictures
img=imread('fruit\fruit_tray_crop.tiff');
imgc=imread('fruit\fruit_tray_crop.tiff');

%delete black region in RGB
delete=find(img(:,:,1)<2&img(:,:,2)<2&img(:,:,3)<2);
img(delete)=255;
bananagreen=img(:,:,2);
bananagreen(delete)=255;
img(:,:,2)=bananagreen;
bananablue=img(:,:,3);
bananablue(delete)=255;
img(:,:,3)=bananablue;
hsv=rgb2hsv(img);
hsvc=rgb2hsv(imgc);
%imtool(hsv);

%construct mask for A B O
raw_apple_mask=ones(size(img,1),size(img,2)); %mask for apple
raw_banana_mask=ones(size(img,1),size(img,2)); %mask for banana
raw_orange_mask=ones(size(img,1),size(img,2)); %mask for orange

%find apple
applegreen=find(hsv(:,:,1)<0.3&hsv(:,:,2)>0.8&hsv(:,:,3)<0.3);
raw_apple_mask(applegreen)=0;
applehighl=find(hsv(:,:,1)>0.94&hsv(:,:,2)>0.45&hsv(:,:,3)>0.1&hsv(:,:,3)<0.5);
raw_apple_mask(applehighl)=0;
appledarkgreen=find(hsv(:,:,1)<0.08&hsv(:,:,2)>0.5&hsv(:,:,3)<0.55);
raw_apple_mask(appledarkgreen)=0;
appledg=find(hsv(:,:,1)<0.08&hsv(:,:,2)<0.31&hsv(:,:,3)<0.55);
raw_apple_mask(appledg)=0;
applecolor=find(hsv(:,:,1)>0.9&hsv(:,:,2)>0.3&hsv(:,:,3)<0.55);
raw_apple_mask(applecolor)=0;
discardblack=find(hsv(:,:,1)==0.2&hsv(:,:,2)==0&hsv(:,:,3)==0);
raw_apple_mask(discardblack)=1;
discardgreen=find(hsv(:,:,1)<0.2&hsv(:,:,2)<0.11);
raw_apple_mask(discardgreen)=1;
%imtool(raw_apple_mask);

%find banana
bananabluegreen=find(hsv(:,:,1)>0.15&hsv(:,:,1)<0.2&hsv(:,:,2)>0.79&hsv(:,:,3)<0.55&hsv(:,:,3)>0.4);
raw_banana_mask(bananabluegreen)=0;
bananablue=find(hsv(:,:,1)>0.11&hsv(:,:,1)<0.21&hsv(:,:,2)>0.6&hsv(:,:,2)<0.95&hsv(:,:,3)>0.6);
raw_banana_mask(bananablue)=0;
%imtool(raw_banana_mask);

%find orange
orangebluee=find(hsv(:,:,1)<0.11&hsv(:,:,2)>0.7&hsv(:,:,3)>0.7);
raw_orange_mask(orangebluee)=0;
bananagreen=find(hsv(:,:,1)<0.11&hsv(:,:,2)>0.78&hsv(:,:,3)<0.7&hsv(:,:,3)>0.4);
raw_orange_mask(bananagreen)=0;
orangebb=find(hsv(:,:,1)>0.11&hsv(:,:,1)<0.14&hsv(:,:,2)>0.7&hsv(:,:,2)<0.85&hsv(:,:,3)<0.6&hsv(:,:,3)>0.5);
raw_orange_mask(orangebb)=0;
%imtool(raw_orange_mask);

%morphogical operation
%apple
apple_dilate_str=strel('square',9);
apple_erode_str=strel('square',13);
dilate_apple_mask=imdilate(raw_apple_mask,apple_dilate_str);
erode_apple_mask=imerode(dilate_apple_mask,apple_erode_str);
%imtool(dilate_apple_mask);
%imtool(erode_apple_mask);

%banana
banana_dilate_str=strel('square',4);
banana_erode_str=strel('square',11);
dilate_banana_mask=imdilate(raw_banana_mask,banana_dilate_str);
erode_banan_mask=imerode(dilate_banana_mask,banana_erode_str);
%imtool(dilate_banana_mask);
%imtool(erode_banan_mask);

%orange
orange_dilate_str=strel('square',7);
orange_erode_str=strel('square',11);
dilate_orange_mask=imdilate(raw_orange_mask,orange_dilate_str);
erode_orange_mask=imerode(dilate_orange_mask,orange_erode_str);
%imtool(dilate_orange_mask);
%imtool(erode_orange_mask);

%lay mask on orig img to compare
face=repmat(raw_banana_mask,[1,1,3]).* double(hsv);
%imtool(double(face));

%apple
%transpose our mask
outputA=zeros(size(img,1),size(img,2));
whiteA=find(erode_apple_mask==1);
blackA=find(erode_apple_mask==0);
outputA(whiteA)=0;
outputA(blackA)=1;
%imtool(outputA);
%find the number of fruit
tempA=bwconncomp(outputA,8);

%apple color mask
colorAidx=find(erode_apple_mask==0);
colorerode_apple_mask=ones(size(img,1),size(img,2),size(img,3));
colorerode_apple_mask(colorAidx)=1;
gA=colorerode_apple_mask(:,:,1);
gA(colorAidx)=0;
colorerode_apple_mask(:,:,1)=gA;
bA=colorerode_apple_mask(:,:,2);
bA(colorAidx)=0;
colorerode_apple_mask(:,:,2)=bA;
%imtool(colorerode_apple_mask);

%banana
%transpose our mask
outputB=zeros(size(img,1),size(img,2));
whiteB=find(erode_banan_mask==1);
blackB=find(erode_banan_mask==0);
outputB(whiteB)=0;
outputB(blackB)=1;
%imtool(outputA);
%find the number of fruit
tempB=bwconncomp(outputB,8);

%banana color mask
colorBidx=find(erode_banan_mask==0);
colorerode_banan_mask=ones(size(img,1),size(img,2),size(img,3));
colorerode_banan_mask(colorBidx)=0.4;
gB=colorerode_banan_mask(:,:,2);
gB(colorBidx)=0.2;
colorerode_banan_mask(:,:,2)=gB;
bB=colorerode_banan_mask(:,:,3);
bB(colorBidx)=0;
colorerode_banan_mask(:,:,3)=bB;
%imtool(colorerode_banan_mask);

%orange
%transpose our mask
outputO=zeros(size(img,1),size(img,2));
whiteO=find(erode_orange_mask==1);
blackO=find(erode_orange_mask==0);
outputO(whiteO)=0;
outputO(blackO)=1;
%imtool(outputO);
%find the number of fruit
tempO=bwconncomp(outputO,8);

%orange color mask
colorOidx=find(erode_orange_mask==0);
colorerode_orange_mask=ones(size(img,1),size(img,2),size(img,3));
colorerode_orange_mask(colorOidx)=0;
gO=colorerode_orange_mask(:,:,2);
gO(colorOidx)=1;
colorerode_orange_mask(:,:,2)=gO;
bO=colorerode_orange_mask(:,:,3);
bO(colorOidx)=0;
colorerode_orange_mask(:,:,3)=bO;
%imtool(colorerode_orange_mask);

color=colorerode_apple_mask .* double(colorerode_banan_mask);
colorr=color .* double(colorerode_orange_mask);
%imtool(uint8(colorr));

blackidx=find(colorr==1);
colorr(blackidx==0);
imtool(colorr);
%imwrite(colorr,'pic4_final_mask.png');

final=colorr .* double(imgc);
%imtool(uint8(final));
%imwrite(uint8(final),'pic4_final_mask_background.png');

%Get the size and centroid information
%Will change the number maunally when we need to use it
apple_bwlabel_mask=zeros(size(img,1),size(img,2));
apple_white=find(erode_apple_mask==0);
apple_bwlabel_mask(apple_white)=1;
apple_bwlabel=bwlabel(apple_bwlabel_mask);
sum_apple=0;
for i=1:6
    apple_size=sum(sum(apple_bwlabel==i));
    sum_apple=sum_apple+apple_size;
    [apple_row,apple_coloum]=find(apple_bwlabel==i);
    a_row=mean(apple_row);
    a_coloum=mean(apple_coloum);
end
avg_apple_size=sum_apple/7;

orange_bwlabel_mask=zeros(size(img,1),size(img,2));
orange_white=find(erode_orange_mask==0);
orange_bwlabel_mask(orange_white)=1;
orange_bwlabel=bwlabel(orange_bwlabel_mask);
sum_orange=0;
for i=1:7
    orange_size=sum(sum(orange_bwlabel==i));
    sum_orange=sum_orange+orange_size;
    [orange_row,orange_coloum]=find(orange_bwlabel==i);
    o_row=mean(orange_row);
    o_coloum=mean(orange_coloum);
end
avg_orange_size=sum_orange/7;

banana_bwlabel_mask=zeros(size(img,1),size(img,2));
banana_white=find(erode_banan_mask==0);
banana_bwlabel_mask(banana_white)=1;
banana_bwlabel=bwlabel(banana_bwlabel_mask);
sum_banana=0;
for i=1:6
    banana_size=sum(sum(banana_bwlabel==i));
    sum_banana=sum_banana+banana_size;
    [banana_row,banana_coloum]=find(banana_bwlabel==i);
    b_row=mean(banana_row);
    b_coloum=mean(banana_coloum);
end
avg_banana_size=sum_banana/6;