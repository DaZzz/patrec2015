% Class visualizations.

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

%data = extendWithZeros(dataStruct);
data = extendAndFilter(dataStruct);

% Plotting original and expanded data.
classNumber = max(dataClasses);
for cl = 1:classNumber
    class1Indices = find(dataClasses == cl);
    subplot(2, ceil(classNumber/2), cl);
    hold on
    for i = 1:length(class1Indices)
        idx = class1Indices(i);
        sample = reshape(data(:,idx), size(data, 1)/3, 3);
        plot3(sample(:,1), sample(:,2), sample(:,3), 'k:');
        %plot(sample(:,1),'k:');
    end
    az = 45;
    el = 45;
    view(az, el);
    axis([-1 1 -1 1 -1 1]);
    %axis([1 500 -1 1]);
    title(sprintf('Class %d', cl));
    hold off
end
% subplot(2, ceil(classNumber/2), classNumber + 1);
% plot(sample(:,1));
% axis([1 500 -1 1]);

% Timer stop.
toc;