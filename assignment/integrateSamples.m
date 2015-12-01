function dataMatrix = integrateSamples(dataStruct)
%integrateNormalized Integrates samples
%%%
% Parameters:
%   dataStruct - cells with matrices
%   dataMatrix - sample matrix with column-wise storage
%%%

samplesNumber = length(dataStruct);
maxLength = max(cellfun('size', dataStruct, 1));
timePointDimensions = size(dataStruct{1}, 2);
sampleDimensions = (maxLength+1)*timePointDimensions;
dataMatrix = zeros(sampleDimensions, samplesNumber);
for i = 1:samplesNumber
    l = size(dataStruct{i}, 1);
    sample = zeros(maxLength, timePointDimensions);
    sample(1:l, :) = dataStruct{i};
    integr = zeros(size(sample, 1) + 1, size(sample, 2));
    for j = 1:size(sample, 1)
        integr(j+1,:) = integr(j,:) + sample(j,:);
    end
    dataMatrix(:, i) = integr(:);
end

end

