clc;
clear all;

load('data3.mat');
data = data3;
class = class3;

w = lms(class, data);
