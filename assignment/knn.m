function C = knn(trainClasses, trainData, data, k)
%KNN Performs classification using K-nearest neighbors.
%   traindata  - matrix of training samples (vector-wise storage)
%   trainclass - vector of class labels for training samples
%   data       - matrix of testing samples
%   k          - number of neighbors voting
%   C          - vector of resulting class labels for testing samples

% Params.
clnum = max(trainClasses); % Number of classes.

% Distance function.
dstnc = @(x1, x2) norm(x1 - x2);

% Classification.
C = zeros(1, size(data, 2));
for i = 1:size(data, 2)
    % Nearest neighbors.
    nndsts = inf*ones(k, 1); % Distances from neighbours.
    nncls  = zeros(k, 1); % Classes of neighbors.
    % Search for nearest neighbors.
    for j = 1:size(trainData, 2)
        insdst = dstnc(data(:, i), trainData(:, j));
        inscl  = trainClasses(j);
        % Insert neighbor if one of the nearests.
        for n = 1:k
            if (insdst < nndsts(n))
                [insdst, nndsts(n)] = deal(nndsts(n), insdst);
                [inscl, nncls(n)] = deal(nncls(n), inscl);
            end
        end
    end
    % Vote while there would not be unambiguos classification.
    nvoting = k;
    while (true)
        votes = zeros(clnum, 1);
        for n = 1:nvoting;
            votes(nncls(n)) = votes(nncls(n)) + 1;
        end
        maxvote = max(votes);
        maxvotecl = find(votes == maxvote);
        if(length(maxvotecl) > 1)
            nvoting = nvoting - 1;
            continue;
        end
        break;
    end
    % Assinging class label.
    C(i) = maxvotecl;
end

end

