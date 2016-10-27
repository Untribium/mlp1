% make sure your data is in the ./data folder!!!
% that is, there should be folders set_train and set_test in there
% additionally, place targets.csv in set_train

% load true values
Y = DataSet('train').targets;

% extract and normalize features
X = split_extract('train', 7, 10);
Xt = split_extract('test', 7, 10);

% remove features with no content (aka std = 0)
Xt(:,find(~std(X))) = [];
X(:,find(~std(X))) = [];

% perform lasso with 17-fold cross validation
% since no lambda is given, lasso will try different ones
[B, I] = lasso(X, Y, 'CV', 17);

% or run it without CV, choose i by trial and error (risk of overfitting)
% this is much faster though
% [B, I] = lasso(X, Y);

% index of lambda vector with smallest CV error
% not necessarily optimal, other values might give better scores
i = I.IndexMinMSE;

% or choose the model with lowest complexity that is within 1 SE
% should yield better bias variance tradeoff, ususally worse though
% i = I.Index1SE;

% intercept (aka offset) for lambda(i)
o = I.Intercept(i);

% predict (remember, this is still linear regression)
Ypt = Xt*B(:, i)+o;

% adjust for difference in mean value of test and training set
% Ypt = Ypt-4;

% write csv, path is ./extractors/_lasso/prediction.csv
create_submission(Ypt, '_lasso');

% now upload the file here: https://inclass.kaggle.com/c/mlp1/submissions/attach