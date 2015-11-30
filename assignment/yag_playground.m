% Playground file
clc;
clearvars;
close all;

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
dataClasses = ones(samplesNumber,1);
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
data = zeros(maxLength, 3, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    data(1:l, :, i) = dataStruct{i};
end

% Plotting original and expanded data.
sampleToPlot = randi(samplesNumber);
subplot(1, 2, 1);
plot3(dataStruct{sampleToPlot}(:,1), dataStruct{sampleToPlot}(:,2),...
    dataStruct{sampleToPlot}(:,3));
subplot(1, 2, 2);
plot3(data(:,1,sampleToPlot), data(:,2,sampleToPlot),...
    data(:,3,sampleToPlot));
fprintf('Label: %d', dataClasses(sampleToPlot));