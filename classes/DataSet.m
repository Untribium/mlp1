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
            
            o.targets = csvread(strcat(o.path, 'targets.csv'));
            o.sumsq = var(o.targets)*o.count-1;
        end
        
        function X = extract_features(o, suite)
            
            X = zeros(o.count, length(suite));
            
            for i = 1:o.count
                % load braaaain
                b = o.load(i);
                
                % run all extractors on b
                for j = 1:length(suite)
                    X(i, j) = suite(j).extract(b);
                end
            end
        end
        
        function Yp = predict(o, suite)
            X = o.extract_features(suite);
            p = o.regress(X);
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
