% Playground file
clc;
clearvars;
close all;
addpath('');

%%%
% files: pXmYdZ where
%     X - number of person
%     Y - type of move
%     Z - index of demonstration
%%%

files = dir('./jedi_master_train/*.mat');
m = cell(length(files), 1);
for k = 1:length(files)
    m{k} = load(files(k).name, '-ascii');
end

d = m{1};
plot3(d(:,1), d(:,2), d(:,3));




