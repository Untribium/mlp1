% loads extractors from extractor suite suite_name
% if suite doesn't exist, it will be created
function suite = load_suite(suite_name)

    suite = Extractor.empty(0);

    path = strcat('./extractors/', suite_name, '/');
    
    if(exist(path, 'dir') ~= 7)
        mkdir(path);
    else
        % get list of all .mat files in path
        exts = dir(fullfile(path, '*.mat'));
        % number of extractors in path
        count = length(exts);

        for k = 1:count
            %load extractor
            load(strcat(path, exts(k).name));
            suite(k) = o;
        end
    end
end