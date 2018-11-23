clear;
clc;
net = resnet50;
train = imageDatastore('Train','IncludeSubfolders',true,'LabelSource','foldernames');
train.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
validate = imageDatastore('Validate','IncludeSubfolders',true,'LabelSource','foldernames');
validate.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
test = imageDatastore('Test','IncludeSubfolders',true,'LabelSource','foldernames');
test.ReadFcn = @(loc)imresize(imread(loc),[224,224]);

lgraph = layerGraph(net);
lgraph = removeLayers(lgraph, {'ClassificationLayer_fc1000','fc1000_softmax','fc1000'});
newLayers = [
    fullyConnectedLayer(100,'Name','fcaaa','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    fullyConnectedLayer(2,'Name','fc','WeightLearnRateFactor',2,'BiasLearnRateFactor', 2)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'avg_pool','fcaaa');

options = trainingOptions('sgdm',...
    'Plots','training-progress',...
    'MiniBatchSize',50,...
    'MaxEpochs',3,...
    'InitialLearnRate',0.01,...
    'VerboseFrequency',1,...
    'ValidationData',validate,...
    'ValidationFrequency',8,...
    'ExecutionEnvironment','cpu');

netTransfer = trainNetwork(train,lgraph,options);
predictedLabels = classify(netTransfer,validate);
accuracy = mean(predictedLabels == validate.Labels)
predictedLabels2 = classify(netTransfer,test);
accuracy2 = mean(predictedLabels2 == test.Labels)