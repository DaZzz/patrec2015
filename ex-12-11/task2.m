clc;
clear all;

% Load data
load data1.mat;
load data2.mat;
load data3.mat;
load data4.mat;

% Set parameters
class = class2;
data = data2;

% Use function
[testclass,t,whidden,woutput]=mlp(data,class,data);


plotmlp(0:0.1:5,0:0.1:5,whidden,woutput);
%%%
% Results
%%%

% For data1 exits with epoch max value
% For data2 wrong classes exits with max epoch value
% For data3 exits with epoch max value
% For data4 exits with epoch max value

