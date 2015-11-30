function [] = plotMethodStats(meanErrorRates, errorRateStds,...
    trainingSizePercentages, methodTitle)
%plotMethodStats Plots statistics of method executed different subsets.
%   meanErrorRates - mean error rates for executing the method with
%                    training subsets of different sizes
%   errorRateStds  - standard deviations of error rates of method executed
%                    with training subsets of different sizes
%   trainingSizePercentages - usage percentages of training sets (percent
%                    of the training subset size relative to the full
%                    training set size
%   methodTitle    - title string of the method including an algorithm and
%                    features used

% Error rate boundaries.
upperErrorRateBand = meanErrorRates + 2*errorRateStds;
lowerErrorRateBand = max(meanErrorRates - 2*errorRateStds,...
    zeros(size(meanErrorRates)));

% Ranges.
xmin = min(trainingSizePercentages);
xmax = max(trainingSizePercentages);
ymin = 0;
ymax = 100;

% Plotting.
plot(trainingSizePercentages, meanErrorRates, 'b-',...
    trainingSizePercentages, errorRateStds, 'r:',...
    trainingSizePercentages, upperErrorRateBand, 'g--',...
    trainingSizePercentages, lowerErrorRateBand, 'g--');
axis([xmin xmax ymin ymax]);
title(methodTitle);
legend('Mean error rate','Error rate std','Error rate band',...
    'Location', 'best');
xlabel('Training set size percentage');

end

