clear

% Draw classes
sigma = cat(3, [2 0; 0 2], [2 0; 0 2], [2 0; 0 2]);
mu = [3 6; 3 -2; 11 -2];
plotclass(mu', sigma)

% Find points
x12 = 1/2 * (mu(1,:) + mu(2,:));
x13 = 1/2 * (mu(1,:) + mu(3,:));
x23 = 1/2 * (mu(2,:) + mu(3,:));
coordinates = [x12; x13; x23]';

hold on
for xy = coordinates
    plot(xy(1), xy(2), '-o');
end
hold off


% Find normal vectors
n1 = mu(1,:) - mu(2,:)
n2 = mu(1,:) - mu(3,:)
n3 = mu(2,:) - mu(3,:)

k1 = -n1(1)/n1(2);
k2 = -n2(1)/n2(2);
k3 = -n3(1)/n3(2);

% Plot boundaries
b1 = x12(2) - k1*x12(1)
b2 = x13(2) - k2*x13(1)
b3 = x23(1)


p1 = @(x) k1 * x + b1
p2 = @(x) k2 * x + b2
p3 = @(x) k3 * x + b3


hold on
fplot(p1, [0,20])
fplot(p2, [0,20])
plot([b3 b3], get(gca, 'ylim'))
hold off



