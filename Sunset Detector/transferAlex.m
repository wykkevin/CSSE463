clear;
clc;
net = alexnet;
% Prepare images
train = imageDatastore('Train','IncludeSubfolders',true,'LabelSource','foldernames');
train.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
validate = imageDatastore('Validate','IncludeSubfolders',true,'LabelSource','foldernames');
validate.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
test = imageDatastore('Test','IncludeSubfolders',true,'LabelSource','foldernames');
test.ReadFcn = @(loc)imresize(imread(loc),[227,227]);

% Change layers
layersTransfer = net.Layers(1:end-3);
layers = [
    layersTransfer
    fullyConnectedLayer(100,'Name','fc100','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    fullyConnectedLayer(2,'Name','fc','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];

options = trainingOptions('sgdm',...
    'Plots','training-progress',...
    'MiniBatchSize',100,...
    'MaxEpochs',5, ...
    'InitialLearnRate',0.01,...
    'VerboseFrequency',1,...
    'ValidationData',validate,...
    'ValidationFrequency',8,...
    'ExecutionEnvironment','gpu');

netTransfer = trainNetwork(train,layers,options);

% Time it
tic;
predictedLabels2 = classify(netTransfer,test);
elapsed = toc;
timePerImage = elapsed/1000;

accuracy = mean(predictedLabels2 == test.Labels);
scores = activations(netTransfer,test,'softmax');