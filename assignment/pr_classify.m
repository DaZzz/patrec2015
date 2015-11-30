function dataclass = pr_classify(data)
    features = extract_features(data);
    dataclass = knn(features);
end
