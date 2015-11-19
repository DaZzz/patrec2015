clc;
clear all;

load irisdata.mat;
t = classregtree(traindata', trainclass', 'splitcriterion', 'gdi');
view(t);
classes = eval(t, data')';
zipped = cat(2, classes', dataclass');
errors = length(zipped(zipped(:,1) ~= zipped(:,2)));

hold on;
plot(zipped(:,1), '*r');
plot(zipped(:,2), 'ob');
hold off;