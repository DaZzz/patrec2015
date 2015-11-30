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


is = [1, 2, 3, 4, 5, 6, 9, 10, 11, 13, 14, 15];
for i=1:12
    d = dataStruct{is(i)};
    d = d ./ 255 * 2 - 1;
    subplot(4,3,i);
    plot(d(:,1), d(:,2));
end

% % Normalize data
% data = zeros(maxLength, 3, samplesNumber);
% for i = 1:samplesNumber
%     l = size(dataStruct{i}, 1);
%     data(1:l, :, i) = dataStruct{i};
% end
% 
% 
% % Example
% bins = 10;
% filter = @(I) imgaussfilt(I);
% g = extract_gradient(dataStruct, bins, filter);
% 
% % Plots for each class
% % for i=1:7
% %     is = find(dataClasses == i);
% %     index = is(1);
% %     h = reshape(g(:,index), bins, bins);
% %     subplot(3,3,i);
% %     imshow(imresize(h, 20, 'nearest'));
% % end
% % 





