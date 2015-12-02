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
    d = load([dataFolder,files(i).name], '-ascii');
    d = d ./ 255 * 2 - 1;
    dataStruct{i} = d;
end

% Extend data with zeros.
dataExt = extendWithZeros(dataStruct);
%dataExt = integrateSamples(dataStruct);
%dataExt = extendAndFilter(dataStruct);

% Extract histograms from data (no filtering).
bins = 16;
%dataHist8I = extract_gradient(dataStruct, bins);
dataHist8I = extract_hist(dataStruct, bins);

% Extract histograms from data (gaussian filtering).
filter = @(I) imgaussfilt(I, 0.5);
%filter = @(I) imgaussfilt(I, 1);
%dataHist8G = extract_gradient(dataStruct, bins, filter);
dataHist8G = extract_hist(dataStruct, bins, filter);

% Methods to assess.
knn1 = @(trainingClasses, trainingData, testingData)...
        knn(trainingClasses, trainingData, testingData, 1);
clRnd  = @(trainingClasses, trainingData, testingData)...
    classifyRandomly(trainingClasses, testingData);

% Method assessing.
trainingSizePercentages = 10:10:100;
[knn1ExtMeanER, knn1ExtStdER] = assessMethod(dataExt, dataClasses,...
    knn1, trainingSizePercentages);
[rndMeanER, rndStdER] = assessMethod(dataExt,...
    dataClasses, clRnd, trainingSizePercentages);
% [knn1HIMeanER, knn1HIStdER] = assessMethod(dataHist8I, dataClasses,...
%     knn1, trainingSizePercentages);
% [knn1HGMeanER, knn1HGStdER] = assessMethod(dataHist8G, dataClasses,...
%     knn1, trainingSizePercentages);

% Plotting.
subplot(1, 2, 1);
% plotMethodStats(knn1ExtMeanER, knn1ExtStdER, trainingSizePercentages,...
%     sprintf('Knn\nExtended and Filtered samples'));
plotMethodStats(knn1ExtMeanER, knn1ExtStdER, trainingSizePercentages,...
    sprintf('Knn\nExtended Raw samples'));
subplot(1, 2, 2);
plotMethodStats(rndMeanER, rndStdER, trainingSizePercentages,...
    'Random labeling');
% subplot(2, 2, 3);
% plotMethodStats(knn1HIMeanER, knn1HIStdER, trainingSizePercentages,...
%     sprintf('Knn1\nHistograms, no filtering'));
% subplot(2, 2, 4);
% plotMethodStats(knn1HGMeanER, knn1HGStdER, trainingSizePercentages,...
%     sprintf('Knn1\nHistograms, gaussian filtering'));

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