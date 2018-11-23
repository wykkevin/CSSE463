clear;
clc;
net = googlenet;
% Prepare images
train = imageDatastore('Train','IncludeSubfolders',true,'LabelSource','foldernames');
train.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
validate = imageDatastore('Validate','IncludeSubfolders',true,'LabelSource','foldernames');
validate.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
test = imageDatastore('Test','IncludeSubfolders',true,'LabelSource','foldernames');
test.ReadFcn = @(loc)imresize(imread(loc),[224,224]);

% Change layers
lgraph = layerGraph(net);
lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
newLayers = [
    fullyConnectedLayer(100,'Name','fcaaa','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    fullyConnectedLayer(2,'Name','fc','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fcaaa');

options = trainingOptions('sgdm',...
    'Plots','training-progress',...
    'MiniBatchSize',50,...
    'MaxEpochs',3,...
    'InitialLearnRate',0.01,...
    'VerboseFrequency',1,...
    'ValidationData',validate,...
    'ValidationFrequency',8,...
    'ExecutionEnvironment','gpu');

netTransfer = trainNetwork(train,lgraph,options);

tic;
predictedLabels2 = classify(netTransfer,test);
elapsed = toc;
timePerImage = elapsed/1000;

accuracy = mean(predictedLabels2 == test.Labels);
scores = activations(netTransfer,test,'softmax');