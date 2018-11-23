function [many_TPR, many_FPR, many_accuracy, DistanceToTopLeft]=ROCtf(trainX, trainY,TestX,TestY,sigma,c)
    net = fitcsvm(trainX, trainY, 'KernelFunction', 'rbf', 'KernelScale', sigma, 'BoxConstraint', c);
    [detectedClasses, distances] = predict(net, TestX);
    many_TPR=[];
    many_FPR=[];
    many_accuracy=[];
    DistanceToTopLeft=[];
    % Get the score we need to use
    score=distances(:,2);
    % Set min, max, and step for threshold
    for threshold = -1:0.1:1
        true_positive = 0;
        false_negative = 0;
        false_positive = 0;
        true_negative = 0;
        % Loop over to get the number for the four kinds
        for n=1:length(detectedClasses)
            if TestY(n)==1
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
        accuracy = (true_positive+true_negative)/length(TestY);
        distance = sqrt((1-TPR)^2+FPR^2);
        many_TPR = [many_TPR, TPR];
        many_FPR = [many_FPR, FPR];
        many_accuracy = [many_accuracy, accuracy];
        DistanceToTopLeft = [DistanceToTopLeft, distance];
    end