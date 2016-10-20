function [y, y_pred] = reg_test_validate(target, p, indices, i)
    f = extract_features('train', i, '_reg_test');
    f = [1, f(indices)];
    y_pred = f*p;
    y = target(i);
end