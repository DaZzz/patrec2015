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

% Extend data with zeros.
data = extendWithZeros(dataStruct);

% % Experiment on classifying with different subsets.
% experimentsNumber = 100;
% k = 1;
% trainingSizePercentages = 10:10:100;
% trainingSizes = floor(samplesNumber/2*trainingSizePercentages/100);
% trainingSizesNumber = length(trainingSizes);
% meanKnnErrorRates = zeros(trainingSizesNumber, 1);
% meanRandomErrorRates = zeros(trainingSizesNumber, 1);
% knnErrorRateStds = zeros(trainingSizesNumber, 1);
% randomErrorRateStds = zeros(trainingSizesNumber, 1);
% for i = 1:trainingSizesNumber
%     knnErrorRates = zeros(experimentsNumber, 1);
%     randomErrorRates = zeros(experimentsNumber, 1);
%     for j = 1:experimentsNumber
%         % Generate training and testing sets.
%         randomSampleOrder  = randperm(samplesNumber);
%         trainingSamplesIDs = randomSampleOrder(1:trainingSizes(i));
%         testingSamplesIDs  = randomSampleOrder(end/2+1:end);
%         trainingData = data(:,trainingSamplesIDs);
%         trainingClasses = dataClasses(trainingSamplesIDs);
%         testingData = data(:,testingSamplesIDs);
%         testingClasses = dataClasses(testingSamplesIDs);
%         testingSize = length(testingClasses);
% 
%         % Classify with knn.
%         knnClasses = knn(trainingClasses, trainingData, testingData, k);
%         randomClasses = classifyRandomly(trainingClasses, testingData);
%         knnErrorRates(j) = ...
%             length(find(knnClasses ~= testingClasses))/testingSize*100;
%         randomErrorRates(j) = ...
%             length(find(randomClasses ~= testingClasses))/testingSize*100;
%     end
%     meanKnnErrorRates(i) = mean(knnErrorRates);
%     meanRandomErrorRates(i) = mean(randomErrorRates);
%     knnErrorRateStds(i) = std(knnErrorRates);
%     randomErrorRateStds(i) = std(randomErrorRates);
% end
% 
% % Error rate boundaries.
% upperKnnErrorRateBand = meanKnnErrorRates + 2*knnErrorRateStds;
% lowerKnnErrorRateBand = max(meanKnnErrorRates - 2*knnErrorRateStds, ...
%     zeros(size(meanKnnErrorRates)));
% upperRandomErrorRateBand = meanRandomErrorRates + 2*randomErrorRateStds;
% lowerRandomErrorRateBand = max(meanRandomErrorRates - ...
%     2*randomErrorRateStds, zeros(size(meanRandomErrorRates)));
% 
% % Ranges.
% xmin = min(trainingSizePercentages);
% xmax = max(trainingSizePercentages);
% ymin = 0;
% ymax = ceil(max(max(upperRandomErrorRateBand),...
%     max(upperKnnErrorRateBand))) + 1;
% 
% % Plotting.
% subplot(1, 2, 1);
% plot(trainingSizePercentages, meanKnnErrorRates, 'b-',...
%     trainingSizePercentages, knnErrorRateStds, 'r:',...
%     trainingSizePercentages, upperKnnErrorRateBand, 'g--',...
%     trainingSizePercentages, lowerKnnErrorRateBand, 'g--');
% axis([xmin xmax ymin ymax]);
% title('Knn');
% legend('Mean error rate','Error rate std','Error rate band',...
%     'Location', 'best');
% xlabel('Training set size percentage');
% subplot(1, 2, 2);
% plot(trainingSizePercentages, meanRandomErrorRates, 'b-',...
%     trainingSizePercentages, randomErrorRateStds, 'r:',...
%     trainingSizePercentages, upperRandomErrorRateBand, 'g--',...
%     trainingSizePercentages, lowerRandomErrorRateBand, 'g--');
% axis([xmin xmax ymin ymax]);
% title('Random');
% legend('Mean error rate','Error rate std','Error rate band',...
%     'Location', 'best');
% xlabel('Training set size percentage');

% Example
bins = 10;
%filter = @(I) imgaussfilt(I);
filter = @(I) I;
g = extract_gradient(dataStruct, bins, filter);

% Plots for each class
classNumber = max(dataClasses);
samplesPerClass = 7;
subplotCounter = 1;
for i=1:classNumber
    classSamples = find(dataClasses == i);
    indices = classSamples(randperm(length(classSamples),samplesPerClass));
    for j = 1:samplesPerClass
        h = reshape(g(:,indices(j)), bins, bins);
        subplot(classNumber,samplesPerClass,subplotCounter);
        imshow(imresize(h, 20, 'nearest'));
        subplotCounter = subplotCounter + 1;
    end
end

% Timer stop.
toc;