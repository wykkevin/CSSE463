% Function to separate letters after we get a picture of a single word.
function separateletters(foldername,letter_threshold,line,word)
    cd(foldername);
    cd(strcat('line',num2str(line)));
    cd(strcat('word',num2str(word)));
    img = imread(strcat(num2str(word),'.png'));
    if ~exist('letters')
        mkdir('letters');
    end
    cd('letters');
    img = bwareaopen(img, 30);
    [L, Ne] = bwlabel(img);
    [avg_row, avg_col] = find(L~=0);
    avg_x = mean(avg_row);
    all_avg_x = [];
    for i=1:Ne
        [avg_row_temp, avg_col_temp] = find(L==i);
        avg_x_temp = mean(avg_row_temp);
        avg_y_temp = mean(avg_col_temp);
        if abs(avg_x_temp-avg_x) > letter_threshold
            if i==0
                for j = i:Ne
                    L(L==j+1) = j;
                end
                Ne = Ne-1;
            else
                [avg_row_pre, avg_col_pre] = find(L==i-1);
                pre_avg_y = mean(avg_col_pre);
                [avg_row_next, avg_col_next] = find(L==i+1);
                next_avg_y = mean(avg_col_next);
                if avg_y_temp-pre_avg_y > next_avg_y-avg_y_temp
                    for j = i:Ne
                        L(L==j+1) = j;
                    end
                    Ne = Ne-1;
                else
                    for j = i:Ne
                        L(L==j) = j-1;
                    end
                    Ne = Ne-1;
                end
            end
        end
        all_avg_x = [all_avg_x,avg_x_temp];
    end
%% Measure properties of image regions
propied=regionprops(L,'BoundingBox');
hold on
%% Plot Bounding Box
% The plotting looks good when apply on a picture with a single word, but
% when run the whole program, it looks in a mess.
for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

%% Objects extraction
for n=1:Ne
    [r,c] = find(L==n);
    n1=img(min(r):max(r),min(c):max(c));
    [r_black, c_black] = find(n1 == 1);
    pix = length(r_black)+length(c_black);
    n1 = bwareaopen(n1, floor(pix*0.1)); % Threshold for removing noise (some pixels)
    % For some images we may want to do this
    %  n1 = imclose(n1, strel('square', floor(pix*0.002))); 
    [imgBW, isImg] = padding(n1, 227);
    if isImg
        filename = strcat(num2str(n),'.png');
        imwrite(imgBW, filename); 
    end
end
% Delete the intermediate picutes
cd ..
delete *.png
cd ..
delete *.png