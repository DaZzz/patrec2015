% Method execution test.

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
data = extendWithZeros(dataStruct);
%data = integrateSamples(dataStruct);

% Extract histograms from data (no filtering).
bins = 8;
%data = extract_gradient(dataStruct, bins);
%data = extract_hist(dataStruct, bins);

% Extract histograms from data (gaussian filtering).
filter = @(I) imgaussfilt(I, 0.5);
%filter = @(I) imgaussfilt(I, 1);
%data = extract_gradient(dataStruct, bins, filter);
%data = extract_hist(dataStruct, bins, filter);

% Methods to assess.
knn1 = @(trainingClasses, trainingData, testingData)...
        knn(trainingClasses, trainingData, testingData, 1);
clRnd  = @(trainingClasses, trainingData, testingData)...
    classifyRandomly(trainingClasses, testingData);

% Method selection.
classify = knn1;

% Generate training and testing sets.
randomSampleOrder  = randperm(samplesNumber);
trainingSamplesIDs = randomSampleOrder(1:end/2);
testingSamplesIDs  = randomSampleOrder(end/2+1:end);
trainingData = data(:,trainingSamplesIDs);
trainingClasses = dataClasses(trainingSamplesIDs);
testingData = data(:,testingSamplesIDs);
testingClasses = dataClasses(testingSamplesIDs);
testingSize = length(testingClasses);

% Classify.
classes = classify(trainingClasses, trainingData, testingData);
errorRate = ...
    length(find(classes ~= testingClasses))/testingSize*100;

disp('Error rate:');
disp(errorRate);

% Timer stop.
toc;