% Leave-one-out script.

clc;
clearvars;
close all;

% Timer start.
tic;

%%%
% files: pXmYdZ where
%     X - number of person
%     Y - type of move
%     Z - index of demonstration
%%%

dataFolder  = './jedi_master_train/';
files       = dir([dataFolder,'*.mat']);
samplesNumber = length(files);
dataStruct  = cell(samplesNumber, 1);
dataClasses = ones(1, samplesNumber);

% Load data
for i = 1:samplesNumber
    tokens = regexp(files(i).name, 'p(\d+)m(\d+)d(\d+).mat', 'tokens');
    dataClasses(i) = str2double(tokens{1}{2});
    d = load([dataFolder,files(i).name], '-ascii');
    d = d ./ 255 * 2 - 1;
    dataStruct{i} = d;
end

% Data.
%data = extendWithZeros(dataStruct);
data = extendAndFilter(dataStruct);

% Methods to assess.
knn1 = @(trainingClasses, trainingData, testingData)...
        knn(trainingClasses, trainingData, testingData, 1);

% Method selection.
classify = knn1;

% Leave-one-out cross-validation.
errorCounter = 0;
for i = 1:samplesNumber
    % Perform classification of ith sample using others.
    trainingSamplesIDs = [1:i-1, i+1:samplesNumber];
    testingSampleIDs  = i;
    trainingData = data(:,trainingSamplesIDs);
    trainingClasses = dataClasses(trainingSamplesIDs);
    testingData = data(:,testingSampleIDs);
    testingClass = dataClasses(testingSampleIDs);
    resultClass = classify(trainingClasses, trainingData, testingData);
    errorCounter = errorCounter + (resultClass ~= testingClass);
end

% Error rate calculation.
errorRate = errorCounter/samplesNumber*100;
disp('Error rate, %:');
disp(errorRate);

% Timer stop.
toc;