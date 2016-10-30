% rough layout

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
o_all = I.intercept(1);

% calculate prediction for test set
Y_pred = Xt*b_all+o_all;


% calculate beta vectors for all age clusters
%bs = zeros(something);
%os = zeros(something);

% min age is 18, max age is 96, go up higher just in case pred is high
for a=9:2:50
    % get feature values of all samples in age class, t is the cluster age
    X_a = X(Y>(a*2)-7 & Y<(a*2)+7, :);
    % then regress
    %[B, I] = lasso(...);
    %bs(a) = B(:, something);
    %os(a) = I.intercept(something);
end

% iterate over test data, calculate new predictions
for i=1:test.count
    %Y_pred = Xt(i, :)*bs(floor(Y_pred/2))+os(a);
end

% write prediction to folder
create_submission(Y_pred);