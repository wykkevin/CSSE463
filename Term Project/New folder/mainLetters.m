% Extract features from given handwritten Data and train Network to recognize English letters
% Rippl, Patrick
% Rudolph, Brandon
% Wang, Kevin
% Yin, Chelsey

%% Feature Extraction Using AlexNet
% Location of images used for training the net
images = imageDatastore('TrainImages',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
% Resize images for AlexNet 
inputSize = [227, 227]; % AlexNet
images.ReadFcn = @(loc)imresize(imread(loc),inputSize);

[trainingImages,testImages] = splitEachLabel(images,0.7,'randomized');
% There are now 3400 training and test images
numTrainImages = numel(trainingImages.Labels);

% idx = randperm(numTrainImages,16);
% figure
% for i = 1:16
%     subplot(4,4,i)
%     I = readimage(trainingImages,idx(i));
%     imshow(I)
% end
%% Preprocess our Training Images (Augmentation)
%
augmenter = imageDataAugmenter( ...
    'RandXShear', [-15 -10], ...
    'RandXShear', [-9 -4], ...
    'RandXShear', [-3 3], ...
    'RandXShear', [4 9], ...
    'RandXShear', [10 15], ...
    'RandYShear', [-15 -10], ...
    'RandYShear', [-9 -4], ...
    'RandYShear', [-3 3], ...
    'RandYShear', [4 9], ...
    'RandYShear', [10 15], ...
    'RandYTranslation',[-5 -0], ...
    'RandYTranslation',[0 5], ...
    'RandXTranslation',[-10 -8], ...
    'RandXTranslation',[-7 -4], ... 
    'RandXTranslation',[-3 0], ... 
    'RandXTranslation',[0 3], ...
    'RandXTranslation',[4 7], ...
    'RandXTranslation',[8 10], ...
    'RandRotation',[-10 -7], ...
    'RandRotation',[-6 -3], ...
    'RandRotation',[-2 0], ...
    'RandRotation',[0 2], ...
    'RandRotation',[3 6], ...
    'RandRotation',[7 10]);

trainingImages2 = augmentedImageSource(inputSize,trainingImages,...
    'DataAugmentation',augmenter);

%% Load Pretrained Network
net = alexnet;
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(trainingImages.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

% Varying hyperparameters (last: 15, 128) - 95.31%
display('AlexNet is trained for letters.');
opts = trainingOptions('sgdm','InitialLearnRate', 0.001, ...
                       'MaxEpochs', 10, 'MiniBatchSize', 2*128, ...
                       'Plots','training-progress');
prompt = 'Train AlexNet new? Y/N [N]: ';
str = input(prompt,'s');
if isempty(str)
    str = 'N';
end
if str == 'Y' || ~exist('AlexNet_10Batches.mat','file')
    disp('Net is trained and optimized. This may take a while.');
    net = trainNetwork(trainingImages, layers, opts);
    save('AlexNet_10Batches', 'net');
else
    load('AlexNet_PreProc_15Batches.mat'); % Best net (newer data)
%     load('AlexNet_10Batches.mat'); % Old data
end

% Classification
% predictedLabels = classify(net, testImages);
% DetAlexNet = predictedLabels;
% % Plot rates
% AccAlexNet1 = mean(predictedLabels == testImages.Labels);
% display(AccAlexNet1);

%%
% Display four sample test images with their predicted labels.
% idx = [180 235 520 880 707 712 730 735];
% figure
% for i = 1:numel(idx)
%     subplot(2,4,i)
%     I = readimage(testImages,idx(i));
%     label = predictedLabels(idx(i));
%     imshow(I)
%     title(char(label))
% end

%% Prediction of letters from segmentation
% Segmented characters will be inserted here and predicted
testFolder = 'own';
SegImages = imageDatastore(testFolder, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% SegImages = imageDatastore(cd);
% Resize images for AlexNet
SegImages.ReadFcn = @(loc)imresize(imread(loc),inputSize);
[predictedWordSegment, predErr] = classify(net, SegImages);

%% Extract given data as txt file
txtName = strcat(testFolder, '.txt');
RecogProb = round(max(predErr,[],2)*100); %in per cent
RecogResult = char(predictedWordSegment(:,1));
Recog = strcat(num2str(RecogProb),'%__', RecogResult);
dlmwrite(txtName, Recog, 'delimiter', '');
edit own.txt

%% Show in the presentation
idx = 1:length(SegImages.Files);
figure
for i = 1:numel(idx)
%     subplot(3,1,i)
    I = readimage(SegImages,idx(i));
    label = predictedWordSegment(idx(i));
    label2 = max(predErr(i,:))*100;
    imshow(I)
    title([char(label), num2str(label2)])
    pause(2); % Just for presentation
end

