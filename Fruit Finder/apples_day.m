clear;
clc;
img=imread('fruit\apples_day.tiff');
hsv=rgb2hsv(img);
imtool(hsv);
imwrite(hsv,'apple_hsv.png');
maskA=ones(size(img,1),size(img,2));
%find apple
yellow=find(hsv(:,:,1)>0.95&hsv(:,:,2)>0.5&hsv(:,:,3)>0.3);
maskA(yellow)=0;
megenta=find(hsv(:,:,1)>0.6&hsv(:,:,2)>0.1&hsv(:,:,3)>0.4);
maskA(megenta)=0;
light_yellow=find(hsv(:,:,1)>0.9&hsv(:,:,2)>0.2&hsv(:,:,3)>0.5);
maskA(light_yellow)=0;
green=find(hsv(:,:,1)<0.03&hsv(:,:,3)>0.1&hsv(:,:,2)>0.97&hsv(:,:,3)<0.35);
maskA(green)=0;
green_blue=find(hsv(:,:,1)<0.05&hsv(:,:,2)>0.6&hsv(:,:,3)>0.3);
maskA(green_blue)=0;
green=find(hsv(:,:,2)>0.7&hsv(:,:,3)>0.04);
maskA(green)=0;
blue=find(hsv(:,:,1)<0.3&hsv(:,:,2)<0.3&hsv(:,:,3)>0.7);
maskA(blue)=0;
imtool(maskA);
%morphological operation
face=repmat(maskA,[1,1,3]).* double(hsv);
imtool(double(face));
strElt=strel('square',7);
streltt=strel('square',13);
maskA1=imdilate(maskA,strElt);
maskA2=imerode(maskA1,streltt);
imtool(maskA1);
imtool(maskA2);
new=zeros(size(img,1),size(img,2));
white=find(maskA2==0);
%black=find(maskA2==1);
new(white)=1;
%new(black)=0;
[aaaa,num]=bwlabel(new);
imtool(new);
for i=1:3
    for j=1:size(img,2)
        for k=1:size(img,1)
            
        end
    end
end
%a=a*10;
imtool(a);