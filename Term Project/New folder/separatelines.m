% Separate multi lines. Save each line to the current folder with name
% 'separationLine.png'
function separatelines(L,Ne,foldername,line_threshold,word_threshold,letter_threshold)
    cd(foldername)
    [row, column] = size(L);
    all_y_avg = [];
    line = 1;
    for i = 1:Ne
        [avg_row, avg_col] = find(L==i);
        avg_y = mean(avg_col);
        all_y_avg = [all_y_avg,avg_y];
    end
    original_r = 0;
    starting_index = 1;
    if ~exist(strcat('line',num2str(line)))
        mkdir(strcat('line',num2str(line)));
    end
    cd(strcat('line',num2str(line)));
    
    % Check the difference is large enough for us to determine them to be 
    % different lines.
    for j=2:length(all_y_avg)
        if all_y_avg(j)-all_y_avg(j-1) > line_threshold
            t_col = [];
            for k = starting_index:j-1
                [temp_row,temp_col] = find(L==k);
                t_col = [t_col; temp_col];
            end
            r = max(t_col);
            newL = imcrop(L,[original_r 0 r-original_r row]);
            temp = find(newL==0);
            newL(newL~=0) = 0;
            newL(temp) = 1;
            filename = strcat(num2str(line),'.png');
            imwrite(transpose(newL), filename);
            cd ..\..
            
            % separatewords
            separatewords(foldername,word_threshold,letter_threshold,line);
            
            line=line+1;
            mkdir(strcat('line',num2str(line)));
            cd(strcat('line',num2str(line)));
            original_r=r;
        end
    end
    % deal with the last line
    newL=imcrop(L,[original_r 0 column-original_r row]);
    temp=find(newL==0);
    newL(newL~=0)=0;
    newL(temp)=1;
    filename = strcat(num2str(line),'.png');
    imwrite(transpose(newL), filename);
    cd ..\..
    
    % separatewords
    separatewords(foldername,word_threshold,letter_threshold,line)
    
    cd ..