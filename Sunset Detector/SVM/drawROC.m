clear;
clc;
load 'features.mat';
% Prepare all the variables we need
trainX = X(1:1600,:);
trainY = Y(1:1600,:);
TestX = X(2201:3200,:);
TestY = Y(2201:3200,:);
% The Kernel Scale and Box Constriant
sigma = 4.2;
c = 40;
[many_TPR, many_FPR, many_accuracy, distanceToTopLeft]=ROCtf(trainX, trainY, TestX, TestY, sigma, c);
index = find(distanceToTopLeft==min(distanceToTopLeft));
ThresholdWeUse = -1+0.1*(index-1);
TPRWeUse = many_TPR(index);
FPRWeUse = many_FPR(index);
AccweUse = many_accuracy(index);
% Create a new figure. You can also number it: figure(1)
figure;
% Hold on means all subsequent plot data will be overlaid on a single plot
hold on;
% Plots using a blue line (see 'help plot' for shape and color codes 
plot(many_FPR, many_TPR, 'b-', 'LineWidth', 2);
% Overlaid with circles at the data points
plot(many_FPR, many_TPR, 'bo', 'MarkerSize', 6, 'LineWidth', 2);
% Title, labels, range for axes
title('ROC Curve for Testing Set', 'fontSize', 18); % Really. Change this title.
xlabel('False Positive Rate', 'fontWeight', 'bold');
ylabel('True Positive Rate', 'fontWeight', 'bold');
% TPR and FPR range from 0 to 1. You can change these if you want to zoom in on part of the graph.
axis([0 1 0 1]);