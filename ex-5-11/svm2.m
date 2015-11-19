function testclass = svm2(traindata, trainclass, testdata, C)
% Nonlinear SVM classification
%
%     'traindata' - training data.
%    'trainclass' - classes for train data.
%      'testdata' - data for testing.
%             'C' - parameter that controls the penalty associated 
%                   with an incorrect classification
EPS = 0.0001;

N = size(trainclass, 2);
y = ones(N, 1); y(trainclass == 2) = -1;
x = traindata;

% Params for quadprog
H = zeros(N);
for i = 1:N
    for j = 1:N
        H(i, j) = y(i) * y(j) * Kern(x(:, i),  x(:, j));
    end
end

f = -1*ones(N, 1);
Aeq = y';
beq = 0;
LB = zeros(N, 1);
UB = C * ones(N, 1);

lambda = quadprog(H, f, [], [], Aeq, beq, LB, UB);

% Get supporting vector from class 1
xk = 0;
for i = 1:N
    if (trainclass(i) == 1 && abs(lambda(i)) > EPS)
        abs(lambda(i))
        xk = x(:, i);
        break;
    end
end


% Get result
M = size(testdata, 2);
testclass = ones(M, 1);
for i = 1:M
    
    S = 1;
    xt = testdata(:, i);
    for k = 1:N
        S = S + (lambda(k) * y(k) * Kern(x(:, k), xt) ...
               - lambda(k) * y(k) * Kern(x(:, k), xk));
    end
    
    if (S > 0)
        testclass(i) = 1;
    else 
        testclass(i) = 2;
    end
end

end
