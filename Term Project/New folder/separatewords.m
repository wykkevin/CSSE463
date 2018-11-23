% Function to separate word after we separate the lines.
function separatewords(foldername,word_threshold,letter_threshold,line)
    cd(foldername);
    cd(strcat('line',num2str(line)));
    img = imread(strcat(num2str(line),'.png'));
    [row, column] = size(img);
    temp = img==0;
    img = uint8(zeros(row,column));
    img(temp) = 255;
    img = bwareaopen(img, 30);
    [L, Ne] = bwlabel(img);
    
    all_y_avg = [];
    for i = 1:Ne
        [avg_row, avg_col] = find(L==i);
        avg_y = mean(avg_col);
        all_y_avg = [all_y_avg, avg_y]  ;
    end
    word = 1;
    if ~exist(strcat('word',num2str(word)))
        mkdir(strcat('word',num2str(word)));
    end
    cd(strcat('word',num2str(word)));
    original_r = 0;
    
    for j = 2:Ne
        if all_y_avg(j)-all_y_avg(j-1) > word_threshold
           [current_row, current_col] = find(L==j-1);
           r = max(current_col);
           newL = imcrop(L,[original_r 0 r-original_r row]);
           filename = strcat(num2str(word),'.png');
           imwrite(newL, filename);
           cd ..\..\..
           
           % Separate letters
           separateletters(foldername,letter_threshold,line,word)
           
           word = word+1;
           mkdir(strcat('word',num2str(word)));
           cd(strcat('word',num2str(word)));
           original_r = r;
        end
    end
    % Deal with the last word.
    newL = imcrop(L,[original_r 0 column-original_r row]);
    filename = strcat(num2str(word),'.png');
    imwrite(newL, filename);
    cd ..\..\..
    
    % Separate letters
    separateletters(foldername,letter_threshold,line,word);
    
    cd ..