function [procImg, isImg] = padding(imgBW, imgSize)
% This function gets a locial image imgBW and applied padding as discussed
% to the top or sides (the letter is then in the center and the size of 
% procImg is sizexsizex3 as defined as input for our AlexNet. n3 is retured 
% as a BW. [procImg, isImg] = padding(imgBW)

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
    if rn1 < cn1 %broad image (has to be finished)
        n1 = imresize(n1, imgSize/cn1); % Broad images - more columns than rows
        [rn1, cn1] = size(n1);
        n2 = zeros(imgSize,cn1);
        delta=floor(imgSize-rn1);
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
        n2 = imresize(n2, [imgSize imgSize]);
        else % padding for thin image
            n1 = imresize(n1, imgSize/rn1);
            [rn1, cn1] = size(n1);
            n2 = zeros(rn1,imgSize);
            % delta = difference on the sides
            delta=floor(imgSize-cn1);
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
        n2 = imresize(n2, [imgSize imgSize]);
    end
    % Save the image with 3D
    procImg(:,:,1) = n2; procImg(:,:,2) = n2; procImg(:,:,3) = n2;
    % Variable to delete empty images
    isImg = 1;
end