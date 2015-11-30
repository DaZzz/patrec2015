function dataMatrix = extendWithZeros(dataStruct)
%extendWithZeros Extends data samples with zeroes and stores in vectors.
%%%
% Parameters:
%   dataStruct - cells with matrices
%   dataMatrix - sample matrix with column-wise storage
%%%

samplesNumber = length(dataStruct);
maxLength = max(cellfun('size', dataStruct, 1));
timePointDimensions = size(dataStruct{1}, 2);
sampleDimensions = maxLength*timePointDimensions;
dataMatrix = zeros(sampleDimensions, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    sample = zeros(maxLength, timePointDimensions);
    sample(1:l, :) = dataStruct{i};
    dataMatrix(:, i) = sample(:);
end

end

