% Extracts features from all brains in the specified data set
% Every brain is split n-1 times in all dimensions, so for n=5 we get 125
% cuboids.
% Extracted values are:
% - histogram (using specified number of bins)
% - mean
% - standard deviation
% - HOG (gradients stuff, 2D over a single slice, pretty bad...)
% All values are then normalized to mean=0 and std=1
function X = split_extract(set_name, n, n_bins)

    n_scores = n_bins;
    % add space for mean and std
    n_scores = n_scores+2;

    % load specified set
    data = DataSet(set_name);
    
    % split brain into cubes evenly, n splits per dimension
    cubes = Cuboid.max_instance().split(n);
    
    % init feature matrix
    X = zeros(data.count, n^3*n_scores);
    
    % iterate over all brains
    for i=1:data.count
        % load brain i
        b = data.load(i);
        
        % extract all features
        for j=1:n^3
            hi = cubes(j).histogram(b, n_bins);
            me = cubes(j).mean(b);
            sd = cubes(j).std(b);
            
            X(i, (j-1)*n_scores+1:j*n_scores) = [hi, me, sd];
        end
    end
    
    % normalize feature values by mean and std
    %{
    for i=1:(n^3*n_scores)
        X(:,i) = X(:,i)-mean(X(:,i));
        if(std(X(:,i) > 0))
            X(:,i) = X(:,i)./std(X(:,i));
        end
    end
    %}
    
    % normalize feature values to [0,1]
    for i=1:(n^3*n_scores)
        v_min = min(X(:,i));
        
        X(:,i) = X(:,i)-v_min;
        v_max = max(X(:,i));
        
        if(v_max ~= 0)
            X(:,i) = X(:,i)/v_max;
        end
        
    end
    
end