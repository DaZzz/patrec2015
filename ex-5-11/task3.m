clc;
clear all;

load data1.mat;

data = data3;
class = class3;

testclass = knn(data, class, data, 5);
plot_data2(data, class, testclass);