% assuming data is in ./data folder
train = DataSet('train');
test = DataSet('test');

Y = train.targets;

% normalize data
% ONLY DO THIS ONCE! Normalized data is stored to disk!
train.normalize_set();
test.normalize_set();

% generate the cuboids
cubes = generate_cubes(17);

% extract features
X = extract_features('train', cubes, 8, true);
Xt = extract_features('test', cubes, 8, true);

% normalize features (optional)
%[X, Xt, ~] = normalize_features(X, Xt, 1.25);

% regression for all values
[B, I] = lasso(X, Y, 'Alpha', 0.36, 'CV', 17);

% get beta hat
i = I.IndexMinMSE;
b = B(:, i);
o = I.intercept(i);

% calculate prediction for test set
Y_pred = Xt*b_all+o_all;

% write prediction to .csv
create_submission(Y_pred);

% upload at https://inclass.kaggle.com/c/mlp1/submissions/attach
