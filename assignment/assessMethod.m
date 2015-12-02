function [meanErrorRates, errorRateStds] = assessMethod(data,...
    dataClasses, classify, trainingSizePercentages)
%assessMethod Assesses classifying method by collecting statistics.
%   data        - full data set of labeled samples (or features)
%   dataClasses - class labels of samples given
%   classify    - classification method being assessed
%                      classify(trainingClasses, trainingData, testingData)
%   trainingSizePercentages - usage percentages of training sets (percent
%                    of the training subset size relative to the full
%                    training set size
%   meanErrorRates - mean error rates for executing the method with
%                    training subsets of different sizes
%   errorRateStds  - standard deviations of error rates of method executed
%                    with training subsets of different sizes

% Assessing params.
experimentsNumber = 200;

samplesNumber = length(dataClasses);

% Experiment on classifying with different subsets.
trainingSizes = floor(samplesNumber/2*trainingSizePercentages/100);
trainingSizesNumber = length(trainingSizes);
meanErrorRates = zeros(trainingSizesNumber, 1);
errorRateStds = zeros(trainingSizesNumber, 1);
for i = 1:trainingSizesNumber
    errorRates = zeros(experimentsNumber, 1);
    for j = 1:experimentsNumber
        % Generate training and testing sets.
        randomSampleOrder  = randperm(samplesNumber);
        trainingSamplesIDs = randomSampleOrder(1:trainingSizes(i));
        testingSamplesIDs  = randomSampleOrder(end/2+1:end);
        trainingData = data(:,trainingSamplesIDs);
        trainingClasses = dataClasses(trainingSamplesIDs);
        testingData = data(:,testingSamplesIDs);
        testingClasses = dataClasses(testingSamplesIDs);
        testingSize = length(testingClasses);

        % Classify.
        classes = classify(trainingClasses, trainingData, testingData);
        errorRates(j) = ...
            length(find(classes ~= testingClasses))/testingSize*100;
    end
    meanErrorRates(i) = mean(errorRates);
    errorRateStds(i) = std(errorRates);
end

end

