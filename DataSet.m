classdef DataSet

    properties
        name
        count
        targets
        sumsq
        path
        training
    end
    
    methods
        % Constructor
        function o = DataSet(set_name)
            
            % set name and path
            o.name = set_name;
            o.path = strcat('./data/set_', o.name, '/');
            
            % make sure data folder exists
            if(exist(o.path, 'dir') ~= 7)
                error('There is no data set named %s!', o.name)
            end
            
            % count the number of .nii files
            files = dir(fullfile(o.path, '*.nii'));
            o.count = length(files);
            
            % read target values if it's a training set
            t_path = strcat(o.path, 'targets.csv');
            if(exist(t_path, 'file'))
                o.targets = csvread(t_path);
                o.sumsq = var(o.targets)*o.count-1;
            end
        end
        
        % extract the feature value matrix using extractors from the given 
        % suite on all brains in the current set
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
        
        % get path to the .nii file of the brain at given index
        function path = path_to_file(o, index)
            
            if(index > o.count)
                error('''index'' exceeds number of brains in set ''%s''!', o.name);
            end
            
            path = strcat(o.name, '_', num2str(index), '.nii');
        end
            
        % load the data matrix of the brain at given index
        function b = load(o, index)
            s = load_nii(o.path_to_file(index));
            b = s.img;
        end
        
        % open the viewer for the brain at given index
        function view(o, index)
            b = load_nii(o.path_to_file(index));
            view_nii(b)
        end
        
        % perform linear regression on feature values X and calculate rsq
        function [p, rsq] = regress(o, X)
            p = regress(o.targets, [ones(o.count, 1), X]);
            rsq = 1 - sum((o.targets - [ones(o.count, 1), X]*p).^2)/o.sumsq;
        end
    end
end
