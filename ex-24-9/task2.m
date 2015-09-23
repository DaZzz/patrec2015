pdf11 = @(x) normpdf(x, 3, 2);
pdf12 = @(x) normpdf(x, 7, 1);
pdf21 = @(x) normpdf(x, 5, 0.2);
pdf22 = @(x) normpdf(x, 6, 0.2);

% Plot 1
% Expected threshold is 5.35
subplot(2,1,1);
fplot(pdf11, [-5,15]);
hold on;
fplot(pdf12, [-5,15]);
hold off;

% Plot 2
% Expected threshold is 5.5
subplot(2,1,2);
fplot(pdf21, [-5,15]);
hold on;
fplot(pdf22, [0,10]);
hold off;
