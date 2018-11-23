clear;
close all hidden;
load 'features.mat';
% Throw out difficult cases
validateX = X(1601:2200,:);
validateY = Y(1601:2200,:);
% Only train cases
trainX = X(1:1600,:);
trainY = Y(1:1600,:);
% Only test cases
testX=X(2201:3200,:);
testY=Y(2201:3200,:);

% Build variables which will use later
manytpr = [];
manyfpr = [];
manysigma = [];
manyc = [];
manyaccuracy = [];
%manyresult=[];
manynumsv=[];
%final value of sigma and c
sigma=4.2;
c=40;

%for sigma=1:5:50
%for sigma=3:0.1:5
    tempA=[]; 
    tempN=[];
    %for c=40:0.2:45
        net = fitcsvm(trainX, trainY, 'KernelFunction', 'rbf', 'KernelScale', sigma, 'BoxConstraint', c);
        [detectedClasses, distances] = predict(net, validateX);
        %plotboundary(net, [0 2], [0 2]);
        %plotdata(trainX, trainY, [0 2], [0 2]);
        %plotsv(net, trainX, trainY);

        true_positive = 0;
        false_negative = 0;
        false_positive = 0;
        true_negative = 0;

        for n=1:length(detectedClasses)%go through every image in the trainset
            if validateY(n)==1
                if detectedClasses(n)==1
                    true_positive = true_positive + 1;
                else
                    false_negative = false_negative + 1;
                end
            else
                if detectedClasses(n)==1
                    false_positive = false_positive + 1;
                else
                    true_negative = true_negative + 1;
                end
            end
        end
        %Calculation
        tpr = true_positive/(true_positive+false_negative);
        fpr = false_positive/(false_positive+true_negative);
        accuracy = (true_positive+true_negative)/(true_positive+true_negative+false_positive+false_negative);
    
        %Build matrix which store datas
        manytpr = [manytpr; tpr];
        manyfpr = [manyfpr; fpr];
        manysigma = [manysigma; sigma];
        manyc = [manyc; c];
        tempA=[tempA,accuracy];
        tempN=[tempN,length(net.SupportVectorLabels)];
        %manyresult=[manysigma,manyc,manyaccuracy;sigma,c,accuracy];
        %manynumsv=[manynumsv;length(net.SupportVectorLabels)];
        
     %end
     manyaccuracy = [manyaccuracy; tempA];
     manynumsv=[manynumsv;tempN];
%end

%plot

%figure;
%imcontour([40 45],[3 5],manyaccuracy,'ShowText','on');
%title('Many Accuracy Contour Plot', 'fontSize', 18)
%xlabel('C', 'fontWeight', 'bold');
%ylabel('Sigma', 'fontWeight', 'bold');


%figure;
%imcontour([40 45],[3 5],manynumsv,'ShowText','on');
%title('Many Number of Support Vectors Plot', 'fontSize', 18)
%xlabel('C', 'fontWeight', 'bold');
%ylabel('Sigma', 'fontWeight', 'bold');


%figure;
%mesh(manynumsv);
%title('Many Number of Support Vectors Plot', 'fontSize', 18)
%xlabel('C', 'fontWeight', 'bold');
%ylabel('Sigma', 'fontWeight', 'bold');
%zlabel('Number of Support Vectors','fontWeight', 'bold');
