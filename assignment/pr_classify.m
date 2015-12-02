function dataclass = pr_classify(data)

persistent trainingClasses;
persistent trainingData;

% Get training classes and data if haven't acquired them yet. Requires
% loading from files.
if (isempty(trainingClasses))
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
    trainingClasses = ones(1, samplesNumber);

    % Load data
    for i = 1:samplesNumber
        tokens = regexp(files(i).name, 'p(\d+)m(\d+)d(\d+).mat', 'tokens');
        trainingClasses(i) = str2double(tokens{1}{2});
        d = load([dataFolder,files(i).name], '-ascii');
        d = d ./ 255 * 2 - 1;
        dataStruct{i} = d;
    end

    % Feature extraction.
    trainingData = extendAndFilter(dataStruct);

%     % Generate training and testing sets.
%     rng(1);
%     sampleOrder  = randperm(samplesNumber);
%     trainingSamplesIDs = sampleOrder(1:end/2);
%     trainingData = trainingData(:,trainingSamplesIDs);
%     trainingClasses = trainingClasses(trainingSamplesIDs);
end

% Testing features extraction.
testingData = extendAndFilter({data});

% Classification.
dataclass = knn(trainingClasses, trainingData, testingData, 1);

end
