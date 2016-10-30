function X = regularize_features(X)
    for i=1:size(X,2)
        x_min = min(X(:, i));
        X(:, i) = X(:, i)-x_min;
        x_max = max(X(:, i));
        X(:, i) = X(:, i)/x_max;
    end
end