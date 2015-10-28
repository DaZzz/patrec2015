clc;
clear all;

load('data1.mat');
data = data1;
class = class1;

w = percep(class, data);
