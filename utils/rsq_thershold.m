% generate random extractors to get some bounds for the range of rsq
function [error, min_e, min_x, min_rsq] = rsq_thershold()

    count = 1;
    batch = 100;
    brains = 278;
    
    min_e = Extractor.empty();
    min_x = [];
    min_rsq = 2;

    Y = csvread('./data/set_train/targets.csv');

    error = zeros(count*batch, 1);
    error_total = sum((Y - mean(Y)).^2);
    
    for i=1:count
        
        fprintf('set %i: generating extractors\n', i)
        
        e = Extractor.random_batch(batch);
        
        fprintf('set %i: extracting features\n', i)
        
        X = ones(brains, batch+1);
        
        for j=1:brains
            b = load_brain('train', j);
            for k=1:batch
                X(j, k+1) = e(k).extract(b);
            end
        end
        
        for k=1:batch
            fprintf('run %i, ext %i: regressing\n', i, k);
            beta = regress(Y, X(:, [1,k+1]));
            error((i-1)*batch+k) = sum((Y - X(:, [1, k+1])*beta).^2)/error_total;
            
            if error((i-1)*batch+k) < min_rsq
                min_rsq = error((i-1)*batch+k);
                min_e = e(k);
                min_x = X(:, [1, k+1]);
            end
        end
    end
end