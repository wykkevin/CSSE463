% Example of reading all the files in a given folder, e.g., TrainSunset. 
% For the sunset detector, you should keep the images in 4 separate folders: train and test 
% are separate, and the folder names tell you what the labels are (sunset = +1, non = -1) 
subdir = 'TrainSunset';
fileList = dir(subdir);
% files 1 and 2 are . (current dir) and .. (parent dir), respectively, 
% so we start with 3.
for i = 3:size(fileList)
    img = imread([subdir  '/'  fileList(i).name]);
    % TODO: insert code of function call here to operate on image.
    % Hint: debug the loop body on 1-2 images BEFORE looping over lots of them...
end

