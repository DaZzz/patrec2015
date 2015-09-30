clear

norm1 = @(x) normpdf(x, 3, 1);
norm2 = @(x) normpdf(x, 6, 1);

hold on
fplot(norm1, [-10, 10])
fplot(norm2, [-10, 10])
plot([4.73 4.73], get(gca, 'ylim'))
hold off
