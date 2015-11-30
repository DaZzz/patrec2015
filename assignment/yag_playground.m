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

% Load data
for i = 1:samplesNumber
    tokens = regexp(files(i).name, 'p(\d+)m(\d+)d(\d+).mat', 'tokens');
    dataClasses(i) = str2double(tokens{1}{2}); 
    dataStruct{i} = load([dataFolder,files(i).name], '-ascii');
end

% Extend data with zeros.
data = extendWithZeros(dataStruct);

% Experiment on classifying with different subsets.
experimentsNumber = 10;
k = 1;
trainingSizePercentages = 10:10:100;
trainingSizes = floor(samplesNumber/2*trainingSizePercentages/100);
trainingSizesNumber = length(trainingSizes);
meanKnnErrorRates = zeros(trainingSizesNumber, 1);
meanRandomErrorRates = zeros(trainingSizesNumber, 1);
knnErrorRateStds = zeros(trainingSizesNumber, 1);
randomErrorRateStds = zeros(trainingSizesNumber, 1);
for i = 1:trainingSizesNumber
    knnErrorRates = zeros(experimentsNumber, 1);
    randomErrorRates = zeros(experimentsNumber, 1);
    for j = 1:experimentsNumber
        % Generate training and testing sets.
        randomSampleOrder  = randperm(samplesNumber);
        trainingSamplesIDs = randomSampleOrder(1:trainingSizes(i));
        testingSamplesIDs  = randomSampleOrder(end/2+1:end);
        trainingData = data(:,trainingSamplesIDs);
        trainingClasses = dataClasses(trainingSamplesIDs);
        testingData = data(:,testingSamplesIDs);
        testingClasses = dataClasses(testingSamplesIDs);
        testingSize = length(testingClasses);

        % Classify with knn.
        knnClasses = knn(trainingClasses, trainingData, testingData, k);
        randomClasses = classifyRandomly(trainingClasses, testingData);
        knnErrorRates(j) = ...
            length(find(knnClasses ~= testingClasses))/testingSize*100;
        randomErrorRates(j) = ...
            length(find(randomClasses ~= testingClasses))/testingSize*100;
    end
    meanKnnErrorRates(i) = mean(knnErrorRates);
    meanRandomErrorRates(i) = mean(randomErrorRates);
    knnErrorRateStds(i) = std(knnErrorRates);
    randomErrorRateStds(i) = std(randomErrorRates);
end

% Plotting.
subplot(1, 2, 1);
plotMethodStats(meanKnnErrorRates, knnErrorRateStds,...
    trainingSizePercentages, 'Knn');

subplot(1, 2, 2);
plotMethodStats(meanRandomErrorRates, randomErrorRateStds,...
    trainingSizePercentages, 'Random');

% Example
bins = 8;
filter = @(I) imgaussfilt(I, 0.5);
%filter = @(I) I;
g = extract_gradient(dataStruct, bins, filter);

% % Plots for each class
% classNumber = max(dataClasses);
% samplesPerClass = 10;
% subplotCounter = 1;
% maxHistVal = max(g(:));
% for i=1:classNumber
%     classSamples = find(dataClasses == i);
%     indices = classSamples(randperm(length(classSamples),samplesPerClass));
%     for j = 1:samplesPerClass
%         h = reshape(g(:,indices(j)), bins, bins);
%         subplot(classNumber,samplesPerClass,subplotCounter);
%         imshow(imresize(h, 20, 'nearest'), [0 maxHistVal]);
%         subplotCounter = subplotCounter + 1;
%     end
% end

% Timer stop.
toc;