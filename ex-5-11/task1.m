clc;
clear all;

load data1.mat;
load data2.mat;
load data3.mat;
data = data2;
class = class2;

[w, w0] = svm(data, class, 5);
plot_data(data, class, w, w0);