function [p, indices] = reg_test(n_features, n_choice)
    
    n_features = n_features+1;
    n_brains = 278;
    
    X = [];
    
    for k = 1:n_brains
        X = [X; 1, extract_features('train', k, '_reg_test')];
    end
    
    Y = csvread('./targets.csv');
    Y = Y(1:n_brains);
    
    % beta = regress(target(1:278/2), scores);
    
    betas = [];
    rsqs = [];
    
    for k = 2:n_features
        betas = [betas; regress(Y, X(:, [1, k]))];
        y_pred = X(:, k)*betas(k-1, :);
        rsq = 1 - sum((Y - y_pred).^2)/sum((Y - mean(Y)).^2);
        rsqs = [rsqs, rsq];
    end
    
    [~, indices] = sort(rsqs, 'descend');
    indices = indices(1:n_choice);
    
    p = regress(Y, X(:, [1, indices+1]));
end