function C = classifyRandomly(trainClasses, data)
%classifyRandomly Performs random labeling of data.
%   trainclass - vector of class labels for training samples
%   data       - matrix of testing samples
%   C          - vector of resulting class labels for testing samples

classNumber = max(trainClasses); % Number of classes.
C = randi(classNumber, 1, size(data, 2)); % Random labels.