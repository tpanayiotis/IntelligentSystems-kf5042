clear ; close all; clc
load('emailspamtrain.mat');
fprintf('\nTraining Linear SVM (Spam Classification)\n')
fprintf('(this may take 1 to 2 minutes) ...\n')
N = 0.1;
model = svmTrain(X, y, N, @linearKernel);
l = svmPredict(model, X);
fprintf('Training Accuracy: %f\n', mean(double(l == y)) * 100);
load('emailspamtest.mat');
fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')
l = svmPredict(model, Xtest);
fprintf('Test Accuracy: %f\n', mean(double(l == ytest)) * 100);
FileName = 'emaildatasets.txt';
file_data = readFile(FileName);
WordIndices  = processEmail(file_data);
j             = emailFeatures(WordIndices);
l = svmPredict(model, j);
fprintf('\nProcessed %s\n\nSpam Classification: %d\n', FileName, l);
fprintf('(1 equals spam, 0 equals not spam)\n\n');

