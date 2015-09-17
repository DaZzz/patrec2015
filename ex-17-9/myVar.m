function result = myVar(A)
    result = [];
    for a = A
        t = 0;
        m = myMean(a);
        for i = 1:length(a)
            t = t + power(a(i) - m, 2);
        end
        result = [result, t/(length(a)-1)];
    end
end