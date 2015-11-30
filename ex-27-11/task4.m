clc;
clear all;

load irisdata;

N = 3;
M = max(dataclass);
[centers, U] = fcm(data', N);

[coeff,score,latent] = pca(data);

clusters = {};
classes = {};
maxU = max(U);
for i=1:max(N, M)
    clusters{i} = coeff(find(U(i,:) == maxU), :);
    classes{i} = coeff(dataclass == i, :);
end

color = 'rbgyk';
hold on;
for i=1:max(N, M)
    if (i <= N)
        cl = clusters{i};
        scatter3(cl(:, 1), cl(:, 2), cl(:, 3), strcat('o', color(i)));
    end
    
    if (i <= M)
        org = classes{i};
        scatter3(org(:, 1), org(:, 2), org(:, 3), strcat('.', color(i)));
    end
end
hold off;