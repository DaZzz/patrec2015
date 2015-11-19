clc;
clear all;

load irisdata.mat;

n = 100;
tds = size(traindata,2);
ds = size(data,2);

sizes = [15,30,45,60,75];
for s=sizes
    errors = [];
    for i=1:n
        tis = randsample(tds, s);
        errors = [errors, get_error(traindata, trainclass, tis, data, dataclass, 1:ds)];
    end
    fprintf('N = %d; Mean: %d; STD: %d\n', s, mean(errors), std(errors));
end