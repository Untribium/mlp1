function shrink_suite(source_name, target_name, n)
    source = load_suite(source_name);
    target = load_suite(target_name); % assumed empty, this creates it
    
    data = DataSet('train');
    
    X = data.extract_features(source);
    Xt = [];
    
    rsq = 0;
    
    for i = 1:length(source)
        if(length(target) < n)
            target = [target, source(i)];
            source(i).save(target_name);
            Xt = [Xt, X(:, i)];
            rsq = data.calc_rsq(Xt);
        else
            rsqs = zeros(1, n);
            for j = 1:n
                C = Xt;
                C(:, j) = X(:, i);
                rsqs(j) = data.calc_rsq(C);
            end
            
            if(max(rsqs > rsq))
                [~, ind] = sort(rsqs, 'descend');
                Xt(:, ind(1)) = X(:, i);
                
                target(ind(1)).delete(target_name);
                target(ind(1)) = source(i);
                target(ind(1)).save(target_name);
                
                rsq = max(rsqs);
            end
        end
    end