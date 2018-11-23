% toyProblem.m
% Written by Matthew Boutell, 2006, updated 2017.
% Feel free to distribute at will.
clear;
clc;
close all hidden;

% We fix the seeds so the data sets are reproducible
seedTrain = 137;
seedTest = 138;
% This tougher data set is commented out.
%[xTrain, yTrain] = GenerateGaussianDataSet(seedTrain);
%[xTest, yTest] = GenerateGaussianDataSet(seedTest);

% This one isn't too bad at all
[xTrain, yTrain] = GenerateClusteredDataSet(seedTrain, 'Training set');
[xTest, yTest] = GenerateClusteredDataSet(seedTest, 'Test set');

manytpr = [];
manyfpr = [];

% Add your code here.
% KNOWN ISSUE: the linear decision boundary doesn't work 
% for this data set at all. Don't know why...
for scale=1:0.1:30
    net = fitcsvm(xTrain, yTrain, 'KernelFunction', 'rbf', 'KernelScale', scale, 'BoxConstraint', 100);
   
    [detectedClasses, distances] = predict(net, xTest);
    true_positive = 0;
    false_negative = 0;
    false_positive = 0;
    true_negative = 0;

    for i = 1:length(yTest)
        %fprintf('Point %d, True class: %d, detected class: %d, distance: %0.2f\n', i, yTest(i), detectedClasses(i), distances(i,2))
        if yTest(i)==1
            if detectedClasses(i)==1
                true_positive = true_positive + 1;
            else
                false_negative = false_negative + 1;
            end
        else
            if detectedClasses(i)==1
                false_positive = false_positive + 1;
            else
                true_negative = true_negative + 1;
            end
        end
    end

    tpr = true_positive/(true_positive+false_negative);
    fpr = false_positive/(false_positive+true_negative);
    manytpr = [manytpr; tpr];
    manyfpr = [manyfpr; fpr];
end

plot(manyfpr, manytpr);
axis([0 1 0 1]);
title('ROC Curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');

% Run the print with value 10
net = fitcsvm(xTrain, yTrain, 'KernelFunction', 'rbf', 'KernelScale', 10, 'BoxConstraint', 100);
[detectedClasses, distances] = predict(net, xTest);
for i = 1:length(yTest)
    fprintf('Point %d, True class: %d, detected class: %d, distance: %0.2f\n', i, yTest(i), detectedClasses(i), distances(i,2))

end
% Run this on a trained network to see the resulting boundary 
% (as in the demo)
f1=figure;
plotboundary(net, [0,20], [0,20]);
plotdata(xTrain, yTrain, [0,20], [0,20]);
plotsv(net, xTrain, yTrain);
title('graph of the training data with scale of 10');


function plotdata(X, Y, x1ran, x2ran)
% PLOTDATA - Plot 2D data set
% 

hold on;
ind = find(Y>0);
plot(X(ind,1), X(ind,2), 'ks');
ind = find(Y<0);
plot(X(ind,1), X(ind,2), 'kx');
text(X(:,1)+.2,X(:,2), int2str([1:length(Y)]'));
axis([x1ran x2ran]);
axis xy;
end

function plotsv(net, X, Y)
% PLOTSV - Plot Support Vectors
% 
hold on;
% Plot the support vectors.
posSV = net.SupportVectors(find(net.SupportVectorLabels > 0), :);
plot(posSV(:,1),posSV(:,2), 'rs');
negSV = net.SupportVectors(find(net.SupportVectorLabels < 0), :);
plot(negSV(:,1),negSV(:,2), 'rx');
end

function [x11, x22, x1x2out] = plotboundary(net, x1ran, x2ran)
% PLOTBOUNDARY - Plot SVM decision boundary on range X1RAN and X2RAN
% 

hold on;
nbpoints = 100;
x1 = x1ran(1):(x1ran(2)-x1ran(1))/nbpoints:x1ran(2);
x2 = x2ran(1):(x2ran(2)-x2ran(1))/nbpoints:x2ran(2);
[x11, x22] = meshgrid(x1, x2);
[dummy, x1x2out] = predict(net, [x11(:),x22(:)]);
x1x2out = x1x2out(:,2);
x1x2out = reshape(x1x2out, [length(x1) length(x2)]);
contour(x11, x22, x1x2out, [-0.99 -0.99], 'b-');
contour(x11, x22, x1x2out, [0 0], 'k-');
contour(x11, x22, x1x2out, [0.99 0.99], 'g-');
end