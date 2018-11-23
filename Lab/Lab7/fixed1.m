clear;
clc;
image1 = imread('fixed1.jpg');
imagebw = rgb2gray(image1);
imagebw = imresize(imagebw, 0.5, 'bilinear'); 
imagebw = imopen(imagebw, strel('disk',2));
edge1 = edge(imagebw,'canny',0.6);
imshow(edge1);

[row, column]=size(edge1);
[parametersx,parametersy]=find(edge1==1);
parameterspace=zeros(row,column);
for ed=1:length(parametersx)
    for x=1:row
        for y=1:column
                if (x-parametersx(ed))^2+(y-parametersy(ed))^2==400
                    parameterspace(x,y)=parameterspace(x,y)+1;
                end
            
        end
    end
end

plotedx=[];
plotedy=[];
for x=1:row
    for y=1:column
        if parameterspace(x,y)>5
            checknear=(plotedx-x).^2+(plotedy-y).^2;
            if find(checknear<10)>0
            else
                plotedx=[plotedx,x];
                plotedy=[plotedy,y];
                hold on
                plot(y,x,'g+');
                drawcircle(y,x,20);
            end
        end
    end
end

hold off