function [w, w0] = svm(traindata, trainclass, C)
%%%
% Simple SVM method for finding boundary
%
%     'traindata' - training data.
%    'trainclass' - classes for train data.
%             'C' - parameter that controls the penalty associated 
%                   with an incorrect classification
%%%
y = ones(size(trainclass, 2), 1);
y(trainclass == 2) = -1;

end