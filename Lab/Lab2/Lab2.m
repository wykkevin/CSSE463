img=imread('image\duck.jpg');
imtool(img);
mask=ones(size(img,1),size(img,2));
duckidx=find(img(:,:,1)>120&img(:,:,2)>70&img(:,:,3)<100);
mask(duckidx)=0;
duck=repmat(mask,[1,1,3]).*double(img);
strElt=strel('square',3);
dilateimg=imopen(mask,strElt);
imtool(dilateimg);
temp=size(find(dilateimg==1));

mask2=zeros(size(img,1),size(img,2));
duckidx=find(img(:,:,1)>120&img(:,:,2)>70&img(:,:,3)<100);
mask2(duckidx)=1;

masktemp(:,:,1)=mask2*255;
masktemp(:,:,2)=mask2*255;
masktemp(:,:,3)=mask2*0;


face=masktemp.* double(img*2);
imtool(uint8(face));
