clear;
clc;
% 1~800 is train sunset
[matrixTrainIs, labelTrainIs] = getMatrix('TrainSunset', 1);
% 801~1600 is train nonsunset
[matrixTrainNot, labelTrainNot] = getMatrix('TrainNonsunset', -1);
% 1601~1900 is validate sunset
[matrixValidateIs, labelValidateIs] = getMatrix('ValidateSunset', 1);
% 1901~2200 is validate nonsunset
[matrixValidateNot, labelValidateNot] = getMatrix('ValidateNonsunset', -1);
% 2201~2700 is test sunset
[matrixTestIs, labelTestIs] = getMatrix('TestSunset', 1);
% 2701~3200 is test nonsunset
[matrixTestNot, labelTestNot] = getMatrix('TestNonSunset', -1);

matrix = [matrixTrainIs; matrixTrainNot; matrixValidateIs; matrixValidateNot; ...
    matrixTestIs; matrixTestNot];
label = [labelTrainIs; labelTrainNot; labelValidateIs; labelValidateNot; ...
    labelTestIs; labelTestNot];

X = normalizeFeatures01(matrix);
Y = label;
save('features.mat','X','Y');