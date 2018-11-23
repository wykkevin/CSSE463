clear;
clc;
image1 = imread('c2.tiff');
image1 = imresize(image1, 0.5, 'bilinear'); 
edge1 = edge(image1,'canny',0.6);
imshow(edge1);

[row, column]=size(edge1);
[parametersx,parametersy]=find(edge1==1);
parameterspace=zeros(row,column,round(min(row,column)/2));
for x=1:row
    for y=1:column
        for radius=1:100
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

newpspace=zeros(x,y,radius);
for rad=1:100
    tempr=rad-1;
    while tempr<1
        tempr=tempr+1;
    end
    while tempr<rad+1 && tempr<=100
        newpspace(:,:,rad)=newpspace(:,:,rad)+parameterspace(:,:,tempr);
        tempr=tempr+1;
    end
end

plotedx=[];
plotedy=[];
for x=1:row
    for y=1:column
        for r=1:100
            if newpspace(x,y,r)>8
                checknear=(plotedx-x).^2+(plotedy-y).^2;
                if find(checknear<40)>0
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