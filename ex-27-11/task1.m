clc;
clear all;

syms x y;

subplot(1,3,1); 
ezplot(abs(x) + abs(y) == 1);

subplot(1,3,2); 
ezplot(sqrt(x^2 + y^2) == 1);

subplot(1,3,3); 
ezplot(feval(symengine,'max',abs(x), abs(y)) == 1);
