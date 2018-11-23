clear;
clc;
image1 = imread('c1.tiff');
image1 = imresize(image1, 0.5, 'bilinear'); 
edge1 = edge(image1,'canny',0.42);
imshow(edge1);

[row, column]=size(edge1);
[parametersx,parametersy]=find(edge1==1);
parameterspace=zeros(row,column,round(min(row,column)/2));
for x=1:row
    for y=1:column
        for radius=1:row/4
            tempx=parametersx-x;
            tempy=parametersy-y;
            tempspace=tempx.^2+tempy.^2;
            plusone=find(tempspace==radius^2);
            for one=1:length(plusone)
                parameterspace(x,y,radius)=parameterspace(x,y,radius)+1;
            end
        end
    end
end

plotedx=[];
plotedy=[];
for x=1:row
    for y=1:column
        for r=1:row/4
%            tempr=r-2;
%            tempS=zeros(240,320);
 %           while tempr<1
%                tempr=tempr+1;
 %           end
 %           while tempr<r+2
%                tempS=tempS+parameterspace(x,y,tempr);
%                tempr=tempr+1;
%            end
%            if tempS(x,y)>14
            if parameterspace(x,y,r)>7
                checknear=(plotedx-x).^2+(plotedy-y).^2;
                if find(checknear<10)>0
                else
                    plotedx=[plotedx,x];
                    plotedy=[plotedy,y];
                    hold on
                    plot(y,x,'g+');
                    drawcircle(y,x,r);
                end
            end
        end
    end
end

hold off