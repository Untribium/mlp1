% main learning function:
% Continuously generates new extractors, runs them on the training data and
% keeps the ones that lead to improved accuracy
% Can be run for an arbitrary duration and stopped at any time, extractors
% are always saved to and loaded from disk (./extractors/suite_name)
function optimize(set_name, suite_name, n_cands, n_final)
    
    padl = floor(log10(n_cands))+1;
    pads = num2str(padl);

    fprintf('%s[init] Initializing data set ''%s''\n', ts(), set_name);
    data = DataSet(set_name);
    
    fprintf('%s[init] Loading suite ''%s''\n', ts(), suite_name);
    suite = load_suite(suite_name);
    
    if(length(suite) > n_final)
        error('''n_final'' is smaller than the number of extractors already in suite ''%s''!', suite_name)
    end
    
    % extract X from stored extractors on current data set, calculate rsq
    fprintf('%s[init] Extracting features from ''%s''\n', ts(), suite_name);
    X = data.extract_features(suite);
    rsq = data.calc_rsq(X);
    
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
            fprintf('%s[cgen] Results of last batch are (%i, %i, %i)\n', ts(), batch_res(1), batch_res(2), batch_res(3));
            fprintf('%s[cgen] Candidates empty, generating new batch\n', ts());
            candidates = Extractor.random_batch(n_cands);
            X_c = data.extract_features(candidates);
            
            batch_res = zeros(3, 1);
        
            fprintf(['%s[loop] Checking candidates: %', pads, 'd of %d, took %d', repmat(' ', 1, padl-1)], ts(), 0, n_cands, 0);
        end
        
        fprintf([repmat('\b', 1, 3*padl+11),'%', pads,'d of %d, took %d', repmat(' ', 1, padl-floor(max(log10(batch_res(3)),0))-1)], n_cands+1-length(candidates),n_cands, batch_res(3));
        pause(0.05); % so we can see the pretty counter...
        
        % suppress warning for really bad extractors
        warning('off', 'stats:regress:RankDefDesignMat');
        
        % calculate individual fit
        rsq_c = data.calc_rsq(X_c(:, 1));
        
        % is it good (enough)?
        if(rsq_c > 0.1)
            
            if(length(suite) < n_final)
                % if set is not full, take candidate
                suite = [suite, candidates(1)];
                X = [X, X_c(:, 1)];
                candidates(1).save(suite_name);
                rsq = data.calc_rsq(X);
                % fprintf('[take] Choosing candidate\n');
                
                batch_res(3) = batch_res(3)+1;
            else
                % else swap chosen extractors with candidate, check rsq
                % fprintf('[comp] Comparing candidate against current suite\n');
                rsqs = zeros(1, n_final);
                for i = 1:n_final
                    C = X;
                    C(:, i) = X_c(:, 1);
                    rsqs(i) = data.calc_rsq(C);
                end

                if(max(rsqs) > rsq)
                    % if better, replace previously chosen extractor
                    % fprintf('[take] Choosing candidate\n');
                    rsq = max(rsqs);
                    [~, ind] = sort(rsqs, 'descend');
                    
                    suite(ind(1)).delete(suite_name);
                    candidates(1).save(suite_name);
                    
                    X(:, ind(1)) = X_c(:, 1);
                    suite(ind(1)) = candidates(1);
                    
                    batch_res(3) = batch_res(3)+1;
                else
                    % else drop the candidate
                    % fprintf('[comp] No improvement\n');
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