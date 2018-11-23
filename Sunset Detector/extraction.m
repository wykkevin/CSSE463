clear;
clc;
net = resnet50;
train = imageDatastore('Train','IncludeSubfolders',true,'LabelSource','foldernames');
train.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
validate = imageDatastore('Validate','IncludeSubfolders',true,'LabelSource','foldernames');
validate.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
test = imageDatastore('Test','IncludeSubfolders',true,'LabelSource','foldernames');
test.ReadFcn = @(loc)imresize(imread(loc),[224,224]);

layer = 'fc1000';
trainingFeatures = activations(net,train,layer,'ExecutionEnvironment','cpu');
testFeatures = activations(net,test,layer,'ExecutionEnvironment','cpu');
trainingLabels = train.Labels;
testLabels = test.Labels;

classifier = fitcsvm(trainingFeatures,trainingLabels);
predictedLabels = predict(classifier,testFeatures);
accuracy = mean(predictedLabels == testLabels)