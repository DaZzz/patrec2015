% Playground file
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
maxLength   = 0;

% Load data
for i = 1:samplesNumber
    tokens = regexp(files(i).name, 'p(\d+)m(\d+)d(\d+).mat', 'tokens');
    dataClasses(i) = str2double(tokens{1}{2}); 
    moveTrace = load([dataFolder,files(i).name], '-ascii');
    dataStruct{i} = moveTrace;
    maxLength = max(size(moveTrace, 1), maxLength);
end

% Normalize data
timePointDimensions = size(dataStruct{1}, 2);
sampleDimensions = maxLength*timePointDimensions;
data = zeros(sampleDimensions, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    sample = zeros(maxLength, timePointDimensions);
    sample(1:l, :) = dataStruct{i};
    data(:, i) = sample(:);
end

% Experiment on classifying with different subsets.
experimentsNumber = 100;
knnErrorRates = zeros(experimentsNumber, 1);
randomErrorRates = zeros(experimentsNumber, 1);
for i = 1:experimentsNumber
    % Generate training and testing sets.
    randomSampleOrder  = randperm(samplesNumber);
    trainingSamplesIDs = randomSampleOrder(1:end/2);
    testingSamplesIDs  = randomSampleOrder(end/2+1:end);
    trainingData = data(:,trainingSamplesIDs);
    trainingClasses = dataClasses(trainingSamplesIDs);
    testingData = data(:,testingSamplesIDs);
    testingClasses = dataClasses(testingSamplesIDs);
    testingSize = length(testingClasses);

    % Classify with knn.
    knnClasses = knn(trainingClasses, trainingData, testingData, 1);
    randomClasses = classifyRandomly(trainingClasses, testingData);
    knnErrorRates(i) = ...
        length(find(knnClasses ~= testingClasses))/testingSize*100;
    randomErrorRates(i) = ...
        length(find(randomClasses ~= testingClasses))/testingSize*100;
end
disp('Knn mean error rate, %:');
disp(mean(knnErrorRates));
disp('Random mean error rate, %:');
disp(mean(randomErrorRates));
disp('Knn error rate std, %:');
disp(std(knnErrorRates));
disp('Random error rate std, %:');
disp(std(randomErrorRates));

% Timer stop.
toc;