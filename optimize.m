% main learning function:
% Continuously generates new extractors, runs them on the training data and
% keeps the ones that lead to improved accuracy
% Can be run for an arbitrary duration and stopped at any time, extractors
% are always saved to and loaded from disk (./extractors/suite_name)
function optimize(set_name, suite_name, n_cands, n_final)
    
    fprintf('[init] Initializing data set ''%s''\n', set_name);
    data = DataSet(set_name);
    
    fprintf('[init] Loading suite ''%s''\n', suite_name);
    suite = load_suite(suite_name);
    
    if(length(suite) > n_final)
        error('''n_final'' is smaller than the number of extractors already in suite ''%s''!', suite_name)
    end
    
    % extract X from stored extractors on current data, calculate rsq
    fprintf('[init] Extracting features from ''%s''\n', suite_name);
    X = data.extract_features(suite);
    [~, rsq] = data.regress(X);
    
    fprintf('[init] Setting up candidates array and matrix\n');
    candidates = Extractor.empty(0);
    X_c = [];
    
    batch_res = zeros(3,1);
    
    fprintf('[init] Entering loop\n');
    while(true)
        if(isempty(candidates))
            % if no more candidates in array, generate new batch
            fprintf('[%s] Current rsq is %.3f\n', datestr(now, 'HH:MM:SS'), rsq);
            fprintf('[cand] Candidates empty, generating new batch\n');
            fprintf('[cand] Results of last batch are (%i, %i, %i)\n', batch_res(1), batch_res(2), batch_res(3));
            candidates = Extractor.random_batch(n_cands);
            fprintf('[cand] Extracting features of new candidates\n');
            X_c = data.extract_features(candidates);
            
            batch_res = zeros(3, 1);
        end
        
        % suppress warning for really bad extractors
        warning('off', 'stats:regress:RankDefDesignMat');
        
        % calculate individual fit
        [~, rsq_c] = data.regress(X_c(:, 1));
        
        % is it good (enough)?
        if(rsq_c > 0.2)
            
            if(length(suite) < n_final)
                % if set is not full, take candidate
                suite = [suite, candidates(1)];
                X = [X, X_c(:, 1)];
                candidates(1).save(suite_name);
                [~, rsq] = data.regress(X);
                fprintf('[take] Choosing candidate\n');
                
                batch_res(2) = batch_res(2)+1;
            else
                % else swap chosen extractors with candidate, check rsq
                fprintf('[comp] Comparing candidate against current suite\n');
                rsqs = zeros(1, n_final);
                for i = 1:n_final
                    C = X;
                    C(:, i) = X_c(:, 1);
                    [~, rsqs(i)] = data.regress(C);
                end

                if(max(rsqs) > rsq)
                    % if better, replace previously chosen extractor
                    fprintf('[take] Choosing candidate\n');
                    rsq = max(rsqs);
                    [~, ind] = sort(rsqs, 'descend');
                    
                    suite(ind(1)).delete(suite_name);
                    candidates(1).save(suite_name);
                    
                    X(:, ind(1)) = X_c(:, 1);
                    suite(ind(1)) = candidates(1);
                    
                    batch_res(3) = batch_res(3)+1;
                else
                    % else drop the candidate
                    fprintf('[comp] No improvement\n');
                    batch_res(2) = batch_res(2)+1;
                end
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