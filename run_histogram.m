% creates histogram of the passed data and returns feature scores
% input: data (matrix), number of buckets
% output: score per bucket, mean and standard deviation
function[scores] = run_histogram(data, n_buckets)
    
    higram = histcounts(data, n_buckets);
    mean = mean2(nonzeros(data));
    std = std2(nonzeros(data));
    scores = [higram, mean, std];
    
end