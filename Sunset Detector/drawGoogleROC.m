clear;
clc;
% Load the result we get from transfer learning
load('useGoogle.mat');
testLabel = [-ones(500,1);ones(500,1)];
% Get score we use
score = reshape(scores,2,1000)';
score = score(:,2);
many_TPR=[];
many_FPR=[];
many_accuracy=[];
DistanceToTopLeft=[];
% Set min, max, and step for threshold
    for threshold = 0.1:0.01:0.9
        true_positive = 0;
        false_negative = 0;
        false_positive = 0;
        true_negative = 0;
        % Loop over to get the number for the four kinds
        for n=1:length(testLabel)
            if testLabel(n)==1
                if score(n)>threshold
                    true_positive = true_positive + 1;
                else
                    false_negative = false_negative + 1;
                end
            else
                if score(n)>threshold
                    false_positive = false_positive + 1;
                else
                    true_negative = true_negative + 1;
                end
            end
        end
        % Calculations
        TPR = true_positive/(true_positive+false_negative);
        FPR = false_positive/(false_positive+true_negative);
        accuracy = (true_positive+true_negative)/length(predictedLabels2);
        distance = sqrt((1-TPR)^2+FPR^2);
        many_TPR = [many_TPR, TPR];
        many_FPR = [many_FPR, FPR];
        many_accuracy = [many_accuracy, accuracy];
        DistanceToTopLeft = [DistanceToTopLeft, distance];
    end
    
index = find(DistanceToTopLeft==min(DistanceToTopLeft));
ThresholdWeUse = 0.4+0.01*(index-1);
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