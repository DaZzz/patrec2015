function result = myMean(A)
    result = [];
    for a = A
        result = [result, sum(a)/length(a)];
    end
end
        