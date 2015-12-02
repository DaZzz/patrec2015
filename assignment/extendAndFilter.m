function dataMatrix = extendAndFilter(dataStruct)
%extendAndFilter Extends samples with zeroes, filters, stores in vectors.
%%%
% Parameters:
%   dataStruct - cells with matrices
%   dataMatrix - sample matrix with column-wise storage
%%%

sigma = 15;
samplesNumber = length(dataStruct);
maxLength = 500;
timePointDimensions = size(dataStruct{1}, 2);
sampleDimensions = maxLength*timePointDimensions;
dataMatrix = zeros(sampleDimensions, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    sample = zeros(maxLength, timePointDimensions);
    sample(1:l, :) = dataStruct{i};
    sample(:,1) = imgaussfilt(sample(:,1), sigma);
    sample(:,2) = imgaussfilt(sample(:,2), sigma);
    sample(:,3) = imgaussfilt(sample(:,3), sigma);
    sample = sample(1:maxLength,:);
    dataMatrix(:, i) = sample(:);
end

end

