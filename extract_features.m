% load a brain and run all extractors on it

function[x] = extract_features(set, index)

x = [];

brain = load_brain(set, index);

path = './extractors';
exts = dir(fullfile(path, '*.m'));
count = length(exts);

for k = 1:count
    [~, ext, ~] = fileparts(exts(k).name);
    try
        line = strcat(ext, '(brain)');
        x = [x, eval(line)];
    catch
        fprintf('failed: %s\n', ext);
    end
end
        