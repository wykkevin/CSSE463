function [procImg, isImg] = padding_image(imgBW, length, width)
% This function change size for the input image to determine its threshold.
% It allow to pad into different length and width.

    [r,c] = find(imgBW == 1);
    % Just in case: Delte empty images (with no characters in it)
    if(isempty(r) || isempty(c)) 
        isImg = 0;
        procImg = 0;
        return;
    end
    
    % Dimensions of the image
    n1 = imgBW(min(r):max(r),min(c):max(c));
    [rn1, cn1] = size(n1);
    if rn1/length < cn1/width %broad image (has to be finished)
        n1 = imresize(n1, width/cn1); % Broad images - more columns than rows
        [rn1, cn1] = size(n1);
        n2 = zeros(length,cn1);
        delta=floor(length-rn1);
        if mod(delta,2) == 1    %if delta is odd, increase by 1 to divide easily
            delta = delta+1;
        end
        delta_h = delta/2;
        if delta == 0
            n2 = n1;
            n2 = double(~n2);
        else
            n2(delta_h : delta_h+rn1-1,:) = n1;
            n2 = double(~n2);
        end
        % n2(delta_h:delta_h+rn1-1,:) = n1;
        % n2 = double(~n2);
        % imshow(n2); %for debugging
        n2 = imresize(n2, [length width]);
        else % padding for thin image
            n1 = imresize(n1, length/rn1);
            [rn1, cn1] = size(n1);
            n2 = zeros(rn1,width);
            % delta = difference on the sides
            delta=floor(width-cn1);
            % if delta is odd, increase by 1 to divide easily
            if mod(delta,2) == 1    
                delta = delta+1;
            end
            delta_h = delta/2;
            if delta == 0
                n2 = n1;
                n2 = double(~n2);
            else
                n2(:, delta_h : delta_h+cn1-1) = n1;
                n2 = double(~n2);
            end
        % n2(:, delta_h : delta_h+cn1-1) = n1;
%         n2 = double(~n2);
        % imshow(n2); %for debugging
        n2 = imresize(n2, [length width]);
    end
    procImg = n2;
    % Variable to delete empty images
    isImg = 1;
end