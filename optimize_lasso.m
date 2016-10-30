% main learning function:
% Continuously generates new extractors, runs them on the training data and
% keeps the ones that lead to improved accuracy
% Can be run for an arbitrary duration and stopped at any time, extractors
% are always saved to and loaded from disk (./extractors/suite_name)
function optimize_lasso(set_name, suite_name, n_cands, threshold)
    
    padl = floor(log10(n_cands))+1;
    pads = num2str(padl);

    fprintf('%s[init] Initializing data set ''%s''\n', ts(), set_name);
    data = DataSet(set_name);
    
    test = DataSet('test');
    
    fprintf('%s[init] Loading suite ''%s''\n', ts(), suite_name);
    suite = load_suite(suite_name);
    
    % extract X from stored extractors on current data set, calculate rsq
    fprintf('%s[init] Extracting features from ''%s''\n', ts(), suite_name);
    X = data.extract_features(suite);
    X = regularize_features(X);
    rsq = data.calc_rsq(X);
    
    Xtest = test.extract_features(suite);
    Xtest = regularize_features(Xtest);
    Xtest = [ones(test.count, 1), Xtest];
    
    fprintf('(%i by %i), (%i by %i)\n', size(X, 1), size(X, 2), size(Xtest, 1), size(Xtest, 2));
    
    fprintf('%s[init] Setting up candidates array and matrix\n', ts());
    candidates = Extractor.empty(0);
    X_c = [];
    
    batch_res = zeros(3,1);
    
    fprintf('%s[init] Entering loop', ts());
    while(true)
        if(isempty(candidates))
            fprintf('\n');
            % if no more candidates in array, generate new batch
            fprintf('%s[stat] Current rsq is %.3f\n', ts(), rsq);
            fprintf('%s[stat] Results of last batch are (%i, %i, %i)\n', ts(), batch_res(1), batch_res(2), batch_res(3));
            fprintf('%s[cgen] Candidates empty, generating new batch\n', ts());
            candidates = Extractor.random_batch(n_cands);
            X_c = data.extract_features(candidates);
            X_c = regularize_features(X_c);
            
            batch_res = zeros(3, 1);
        
            fprintf(['%s[loop] Checking candidates: %', pads, 'd of %d, took %d', repmat(' ', 1, padl-1)], ts(), 0, n_cands, 0);
        end
        
        fprintf([repmat('\b', 1, 3*padl+11),'%', pads,'d of %d, took %d', repmat(' ', 1, padl-floor(max(log10(batch_res(3)),0))-1)], n_cands+1-length(candidates),n_cands, batch_res(3));
        % pause(0.05); % so we can see the pretty counter...
        
        % suppress warning for really bad extractors
        warning('off', 'stats:regress:RankDefDesignMat');
        
        % calculate individual fit
        rsq_c = data.calc_rsq(X_c(:, 1));
        
        % is it good (enough)?
        if(rsq_c > threshold)
            
            C = [ones(data.count, 1), X, X_c(:, 1)];
            
            B = lasso(C, data.targets, 'CV', sqrt(data.count));
            
            b = B(:, 50);
            
            Yp = C*b;

            rsq_lasso = 1 - sum((data.targets - Yp).^2)/data.sumsq;
            
            if(rsq < rsq_lasso)
                batch_res(3) = batch_res(3)+1;
                candidates(1).save(suite_name);
                suite = [suite, candidates(1)];
                X = C;
                
                rsq = rsq_lasso;
                
                x = test.extract_features(candidates(1));
                x = regularize_features(x);
                Xtest = [Xtest, x];
                Yp_test = Xtest*b;
                
                save('yp.mat', 'Yp_test');
            else
                batch_res(2) = batch_res(2)+1;
            end
        else
            batch_res(1) = batch_res(1)+1;
        end
        
        % scrap candidate
        candidates(1) = [];
        X_c(:, 1) = [];
        
        % turn warnings back on (because why not...)
        warning('on', 'stats:regress:RankDefDesignMat');
    end
end