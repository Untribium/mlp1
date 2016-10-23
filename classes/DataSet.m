classdef DataSet

    properties
        name
        count
        targets
        sumsq
        path
    end
    
    methods
        function o = DataSet(set_name)
            
            o.name = set_name;
            o.path = strcat('./data/set_', o.name, '/');
            
            if(exist(o.path, 'dir') ~= 7)
                error('There is no data set named %s!', o.name)
            end
            
            files = dir(fullfile(o.path, '*.nii'));
            o.count = length(files);
            
            t_path = strcat(o.path, 'targets.csv');
            if(exist(t_path, 'file'))
                o.targets = csvread(t_path);
                o.sumsq = var(o.targets)*o.count-1;
            end
        end
        
        function X = extract_features(o, suite)
            n_ext = length(suite);
            epadl = floor(log10(n_ext))+1;
            epads = num2str(epadl);
            dpadl = floor(log10(o.count))+1;
            dpads = num2str(dpadl);
            
            X = zeros(o.count, n_ext);
            
            if(isempty(suite))
                fprintf('%s[data] Empty suite\n', ts());
            else
                fprintf(['%s[data] Extracting sample %', dpads, 'd of %d, feature %', epads, 'd of %d'], ts(), 0, o.count, 0, n_ext);

                for i = 1:o.count
                    % load braaaain
                    b = o.load(i);

                    fprintf([repmat('\b', 1, 2*(dpadl+epadl)+18), '%', dpads, 'd of %d, feature %', epads, 'd of %d'], i, o.count, 0, n_ext);

                    % run all extractors on b
                    for j = 1:n_ext
                        X(i, j) = suite(j).extract(b);
                        fprintf([repmat('\b', 1, 2*epadl+4), '%', epads, 'd of %d'], j, n_ext);
                    end
                end

                fprintf('\n');
            end
        end
        
        function Yp = predict(o, suite, train_data)
            Xt = train_data.extract_features(suite);
            p = train_data.regress(Xt);
            if(isequal(o, train_data))
                X = Xt;
            else
                X = o.extract_features(suite);
            end
            X_ = [ones(o.count, 1), X];
            Yp = X_*p;
        end
        
        function p = regress(o, X)
            p = regress(o.targets, [ones(o.count, 1), X]);
        end
        
        function rsq = calc_rsq(o, X)
            p = o.regress(X);
            rsq = 1 - sum((o.targets - [ones(o.count, 1), X]*p).^2)/o.sumsq;
        end
        
        function path = path_to_file(o, index)
            if(index > o.count)
                error('''index'' exceeds number of brains in set ''%s''!', o.name);
            end
            
            % construct file name
            path = strcat(o.name, '_', num2str(index), '.nii');
        end
        
        function b = load(o, index)

            % load brain struct using nifty libs
            s = load_nii(o.path_to_file(index));
            
            % extract matrix from brain struct
            b = s.img;
        end
        
        function view(o, index)
            b = load_nii(o.path_to_file(index));
            view_nii(b)
        end
    end
end
