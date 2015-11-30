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

% Methods to assess.
knn1 = @(trainingClasses, trainingData, testingData)...
        knn(trainingClasses, trainingData, testingData, 1);
clRnd  = @(trainingClasses, trainingData, testingData)...
    classifyRandomly(trainingClasses, testingData);

% Method assession.
trainingSizePercentages = 10:10:100;
[meanKnnErrorRates, knnErrorRateStds] = assessMethod(data, dataClasses,...
    knn1, trainingSizePercentages);
[meanRandomErrorRates, randomErrorRateStds] = assessMethod(data,...
    dataClasses, clRnd, trainingSizePercentages);

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