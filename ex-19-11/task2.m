clc;
clear all;

load irisdata.mat;

TOTAL = size(traindata,2); % total size
N = floor(TOTAL/2); % train data size
M = 100; % forest size
forest = cell(M,1); 
for i=1:M
    is = randsample(TOTAL, N);
    t = classregtree(traindata(:,is)', ...
                     trainclass(:,is)', ...
                    'method', 'classification');
    forest{i} = t;
end

results = [];
% Apply function
for i=1:M
    results=[results; str2double(eval(forest{i}, data')')];
end

classes = mode(results);
zipped = cat(2, classes', dataclass');
errors = length(zipped(zipped(:,1) ~= zipped(:,2)));

hold on;
plot(zipped(:,1), '*r');
plot(zipped(:,2), 'ob');
hold off;