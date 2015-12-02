% Test script for pr_classify.

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

% Generate training and testing sets.
%rng(1);
sampleOrder  = randperm(samplesNumber);
%testingSamplesIDs  = sampleOrder(end/2+1:end);
testingSamplesIDs  = sampleOrder;
testingClasses = dataClasses(testingSamplesIDs);
testingSize = length(testingClasses);

% Classify.
resultClasses = ones(1, testingSize);
for i = 1:testingSize
    resultClasses(i) = pr_classify(dataStruct{testingSamplesIDs(i)});
end

% Error rate.
errorRate = length(find(resultClasses ~= testingClasses))/testingSize*100;
disp('Error rate:');
disp(errorRate);

% Timer stop.
toc;