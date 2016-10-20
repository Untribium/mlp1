% load a brain and run extractors on it
% input: data set and index of the brain to be processed
% output: 1xn vector containing all the feature scores

function x = extract_features(data_set, index, extractor_set)

    % contruct path
    path = strcat('./extractors/', extractor_set, '/');
    
    if(exist(path, 'dir') ~= 7)
        error('This extractor_set does not exist!')
    end
    
    % get list of all .mat files in path
    exts = dir(fullfile(path, '*.mat'));
    % number of extractors in path
    count = length(exts);
    
    % init x
    x = zeros(1, count);
    
    % load brain
    data = load_brain(data_set, index);

    % iterate over all extractors
    for k = 1:count
        load(strcat(path, exts(k).name));
        x(k) = e.extract(data);
        clear e
    end
end