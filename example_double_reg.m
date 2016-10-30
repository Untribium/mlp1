% again, data must be in data folder!
train = DataSet('train');
test = DataSet('test');

Y = train.targets;

% normalize data
% ONLY DO THIS ONCE! Normalized data is stored on disk!
%train.normalize_set();
%test.normalize_set();

% generate the cuboids
cubes = generate_cubes(17);

% extract features
X = extract_features('train', cubes, 8, false);
Xt = extract_features('test', cubes, 8, false);

% extract features from normalized data
%X = extract_features('train', cubes, 8, true);
%Xt = extract_features('test', cubes, 8, true);

% normalize features (optional, better don't)
%[X, Xt, ~] = normalize_features(X, Xt, 2);

% regression for all values
[B, I] = lasso(X, Y, 'Alpha', 0.375);

% store beta vector (first seems best, overfit?...)
b_all = B(:, 1);
o_all = I.Intercept(1);

% calculate prediction for test set
Y_pred = Xt*b_all+o_all;

% calculate beta vectors for all age clusters
bs = zeros(size(X,2),44);
os = zeros(1,44);

% min age is 18, max age is 96, go up higher just in case pred is high
for a=1:44
    % get feature values of all samples in age class, t is the cluster age
    i_a = Y>((5+a)*2)-16 & Y<((5+a)*2)+16;
    X_a = X(i_a, :);
    Y_a = Y(i_a);
    % then regress
    [B, I] = lasso(X_a, Y_a, 'Alpha', 0.375);
    bs(:, a) = B(:, 1);
    os(a) = I.Intercept(1);
end

% iterate over test data, calculate new predictions
for i=1:test.count
    a = max(floor(Y_pred/2-5), 1);
    Y_pred2 = Xt(i, :)*bs(:, a)+os(a);
end

% write prediction to folder
create_submission(Y_pred2);