filt = ones(3,3)/9;
image1=imread('a.jpg');
grayImg=rgb2gray(image1);
smoothImg = filter2(filt, grayImg);
