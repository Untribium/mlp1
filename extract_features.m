% load a brain and run extractors on it
% input: data set and index of the brain to be processed
% output: 1xn vector containing all the feature scores

function[x] = extract_features(data_set, index, extractor_set)

    % init x
    x = [];

    % load brain
    brain = load_brain(data_set, index);

    % contruct path (might make this flexible, for randomization)
    path = strccat('./extractors/', extractor_set);
    % get list of all .m files in path
    exts = dir(fullfile(path, '*.m'));
    % number of extractors in path
    count = length(exts);

    % iterate over all extractors
    for k = 1:count
        % get filename
        [~, ext, ~] = fileparts(exts(k).name);
        try
            % attempt to run extractor, pass brain data as param
            line = strcat(ext, '(brain)');
            x = [x, eval(line)];
        catch
            % if it fails, print (nondescript) fail message :)
            fprintf('extractor %s failed :(\n', ext);
        end
    end
end