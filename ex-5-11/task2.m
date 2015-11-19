clc;
clear all;

load data1.mat;
load data2.mat;
load data3.mat;

data = data3;
class = class3;

testclass = svm2(data, class, data, 5);
plot_data2(data, class, testclass);