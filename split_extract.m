function X = split_extract(set_name, n, n_buc)

    % add mean and std
    n_buc = n_buc+2;

    % load specified set
    data = DataSet(set_name);
    
    % split brain into cubes evenly, n splits per dimension
    cubes = Cuboid.max_instance().split(n);
    
    % init feature matrix
    X = zeros(data.count, n^3*n_buc);
    
    % iterate over all brains
    for i=1:data.count
        % load brain i
        b = data.load(i);
        
        % extract all features
        for j=1:n^3
            scores = [cubes(j).histogram(b, n_buc-2), cubes(j).mean(b), cubes(j).std(b)];
            X(i, (j-1)*n_buc+1:j*n_buc) = scores;
        end
    end
    
    % normalize feature values (by mean and std, no [0,1]!)
    for i=1:(n^3*n_buc)
        X(:, i) = X(:, i)-mean(X(:, i));
        if(std(X(:, i) > 0))
            X(:, i) = X(:, i)./std(X(:, i));
        end
    end
end