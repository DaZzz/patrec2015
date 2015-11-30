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

files       = dir('./jedi_master_train/*.mat');
samplesNumber = length(files);
dataStruct  = cell(samplesNumber, 1);
dataClasses = ones(samplesNumber,1);
maxLength   = 0;

% Load data
for i = 1:samplesNumber
    tokens = regexp(files(i).name, 'p(\d+)m(\d+)d(\d+).mat', 'tokens');
    dataClasses(i) = str2double(tokens{1}{2}); 
    moveTrace = load(files(i).name, '-ascii');
    dataStruct{i} = moveTrace;
    maxLength = max(size(moveTrace, 1), maxLength);
end

% Normalize data
data = zeros(maxLength, 3, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    data(1:l, :, i) = dataStruct{i};
end

% Demo
C = pr_classify(data);

% plot3(data(:,1,1), data(:,2,1), data(:,3,1))




