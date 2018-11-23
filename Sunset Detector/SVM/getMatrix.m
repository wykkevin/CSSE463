function [data, label] = getMatrix(subdir, isSunset)
    fileList = dir(subdir);
    data = [];
    label(1:length(fileList)-2,1) = isSunset;
    for i = 3:size(fileList)
        img = imread([subdir  '/'  fileList(i).name]);
        [row, column, dimension]=size(img);
        % Get LST color space
        r = double(img(:,:,1));
        g = double(img(:,:,2));
        b = double(img(:,:,3));
        l = r+g+b;
        s = r-b;
        t = r-2*g+b;
        unit_row = round(row/7-0.5);
        unit_column = round(column/7-0.5);
        temp_output = [];
        % Get the 294 features for one image
        for n=1:7
            for m=1:7
                start_row = (n-1)*unit_row+1;
                end_row = n*unit_row;
                start_column = (m-1)*unit_column+1;
                end_column = m*unit_column;
                temp_l=l(start_row:end_row, start_column:end_column);
                l_first_moment = mean(mean(temp_l));
                l_second_moment = std(temp_l(:));
                temp_s=s(start_row:end_row, start_column:end_column);
                s_first_moment = mean(mean(temp_s));
                s_second_moment = std(temp_s(:));
                temp_t=t(start_row:end_row, start_column:end_column);
                t_first_moment = mean(mean(temp_t));
                t_second_moment = std(temp_t(:));
                temp_output = [temp_output l_first_moment l_second_moment ...
                s_first_moment s_second_moment t_first_moment t_second_moment];
            end
        end
        % Combine all the data together
        data = [data; temp_output];
    end