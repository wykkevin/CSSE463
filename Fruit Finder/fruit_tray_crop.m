close all hidden;
clear;
clc;
img=imread('fruit\fruit_tray_crop.tiff');
%imtool(img);
hsv=rgb2hsv(img);
%imtool(hsv);


maskAAA=ones(size(img,1),size(img,2)); %mask for apple
maskBBB=ones(size(img,1),size(img,2)); %mask for banana
maskOOO=ones(size(img,1),size(img,2)); %mask for orange
%find apple
applegreen=find(hsv(:,:,1)<0.3&hsv(:,:,2)>0.8&hsv(:,:,3)<0.3);
maskAAA(applegreen)=0;
applehighl=find(hsv(:,:,1)>0.94&hsv(:,:,2)>0.45&hsv(:,:,3)>0.1&hsv(:,:,3)<0.5);
maskAAA(applehighl)=0;
appledarkgreen=find(hsv(:,:,1)<0.08&hsv(:,:,2)>0.5&hsv(:,:,3)<0.55);
maskAAA(appledarkgreen)=0;
appledg=find(hsv(:,:,1)<0.08&hsv(:,:,2)<0.31&hsv(:,:,3)<0.55);
maskAAA(appledg)=0;
applecolor=find(hsv(:,:,1)>0.9&hsv(:,:,2)>0.3&hsv(:,:,3)<0.55);
maskAAA(applecolor)=0;
discardblack=find(hsv(:,:,1)==0.2&hsv(:,:,2)==0&hsv(:,:,3)==0);
maskAAA(discardblack)=1;
discardgreen=find(hsv(:,:,1)<0.2&hsv(:,:,2)<0.11);
maskAAA(discardgreen)=1;
imtool(maskAAA);
%find banana
xiagao2=find(hsv(:,:,1)>0.15&hsv(:,:,1)<0.2&hsv(:,:,2)>0.79&hsv(:,:,3)<0.55&hsv(:,:,3)>0.4);
maskBBB(xiagao2)=0;
bananablue=find(hsv(:,:,1)>0.11&hsv(:,:,1)<0.21&hsv(:,:,2)>0.6&hsv(:,:,2)<0.95&hsv(:,:,3)>0.6);
maskBBB(bananablue)=0;
imtool(maskBBB);
%find orange
orangebluee=find(hsv(:,:,1)<0.11&hsv(:,:,2)>0.7&hsv(:,:,3)>0.7);
maskOOO(orangebluee)=0;
bananagreen=find(hsv(:,:,1)<0.11&hsv(:,:,2)>0.78&hsv(:,:,3)<0.7&hsv(:,:,3)>0.4);
maskOOO(bananagreen)=0;
orangebb=find(hsv(:,:,1)>0.11&hsv(:,:,1)<0.14&hsv(:,:,2)>0.7&hsv(:,:,2)<0.85&hsv(:,:,3)<0.6&hsv(:,:,3)>0.5);
maskOOO(orangebb)=0;
imtool(maskOOO);

%morphogical operation
%apple
str1=strel('square',9);
str2=strel('square',13);
maskAA=imdilate(maskAAA,str1);
maskA=imerode(maskAA,str2);
%imtool(maskA);
%banana
str3=strel('square',4);
str4=strel('square',11);
maskBB=imdilate(maskBBB,str3);
maskB=imerode(maskBB,str4);
%imtool(maskB);
%orange
str5=strel('square',7);
str6=strel('square',11);
maskOO=imdilate(maskOOO,str5);
maskO=imerode(maskOO,str6);
%imtool(maskO);
%lay mask on orig img to compare
%face=repmat(maskAAA,[1,1,3]).* double(hsv);
%imtool(double(face));


%transpose our mask
%apple
outputA=zeros(size(img,1),size(img,2));
whiteA=find(maskA==1);
blackA=find(maskA==0);
outputA(whiteA)=0;
outputA(blackA)=1;
%imtool(outputA);
%find the number of fruit
tempA=bwconncomp(outputA,8);

%color mask
colorAidx=find(maskA==0);
colormaskA=ones(size(img,1),size(img,2),size(img,3));
colormaskA(colorAidx)=1;
gA=colormaskA(:,:,2);
gA(colorAidx)=0;
colormaskA(:,:,2)=gA;
bA=colormaskA(:,:,3);
bA(colorAidx)=0;
colormaskA(:,:,3)=bA;
%imtool(colormaskA);

%banana
%transpose our mask
outputB=zeros(size(img,1),size(img,2));
whiteB=find(maskB==1);
blackB=find(maskB==0);
outputB(whiteB)=0;
outputB(blackB)=1;
%imtool(outputB);
%find the number of fruit
tempB=bwconncomp(outputB,8);
%color mask

colorBidx=find(maskB==0);
colormaskB=ones(size(img,1),size(img,2),size(img,3));
colormaskB(colorBidx)=0.7;
gB=colormaskB(:,:,2);
gB(colorBidx)=0.7;
colormaskB(:,:,2)=gB;
bB=colormaskB(:,:,3);
bB(colorBidx)=0;
colormaskB(:,:,3)=bB;
%imtool(colormaskB);

%orange
%transpose our mask
outputO=zeros(size(img,1),size(img,2));
whiteO=find(maskO==1);
blackO=find(maskO==0);
outputO(whiteO)=0;
outputO(blackO)=1;
%imtool(outputO);
%find the number of fruit
tempO=bwconncomp(outputO,8);
%color mask

colorOidx=find(maskO==0);
colormaskO=ones(size(img,1),size(img,2),size(img,3));
colormaskO(colorOidx)=0.98;
gO=colormaskO(:,:,2);
gO(colorOidx)=0.5;
colormaskO(:,:,2)=gO;
bO=colormaskO(:,:,3);
bO(colorOidx)=0;
colormaskO(:,:,3)=bO;
%imtool(colormaskO);

color=colormaskA .* double(colormaskB);
colorr=color .* double(colormaskO);

blackidx=find(colorr==1);
colorr(blackidx==0);
imtool(colorr);

final=colorr .* double(img);
imtool(uint8(final));

apple_bwlabel_mask=zeros(size(img,1),size(img,2));
apple_white=find(maskA==0);
apple_bwlabel_mask(apple_white)=1;
apple_bwlabel=bwlabel(apple_bwlabel_mask);
sum_apple=0;
for i=1:15
    apple_size=sum(sum(apple_bwlabel==i));
    sum_apple=sum_apple+apple_size;
    [apple_row,apple_coloum]=find(apple_bwlabel==i);
    a_row=mean(apple_row);
    a_coloum=mean(apple_coloum);
end
avg_apple_size=sum_apple/15;

orange_bwlabel_mask=zeros(size(img,1),size(img,2));
orange_white=find(maskO==0);
orange_bwlabel_mask(orange_white)=1;
orange_bwlabel=bwlabel(orange_bwlabel_mask);
sum_orange=0;
for i=1:3
    orange_size=sum(sum(orange_bwlabel==i))
    sum_orange=sum_orange+orange_size;
    [orange_row,orange_coloum]=find(orange_bwlabel==i);
    o_row=mean(orange_row)
    o_coloum=mean(orange_coloum)
end
avg_orange_size=sum_orange/3

banana_bwlabel_mask=zeros(size(img,1),size(img,2));
banana_white=find(maskB==0);
banana_bwlabel_mask(banana_white)=1;
banana_bwlabel=bwlabel(banana_bwlabel_mask);
sum_banana=0;
for i=1:7
    banana_size=sum(sum(banana_bwlabel==i));
    sum_banana=sum_banana+banana_size;
    [banana_row,banana_coloum]=find(banana_bwlabel==i);
    b_row=mean(banana_row);
    b_coloum=mean(banana_coloum);
end
avg_banana_size=sum_banana/7;