% creates a new set of random extractors and stores them in
% ./extractors/[set_name]/ext[index].m
% input:
%    name of the set (not tracked by git if prefixed by '_')
%    number of extractors
%    specifiers (for generator)
% output:
%    nothing (files in new folder)
function[] = generate_random_set(set_name, n, specifiers)

    path = strcat('./extractors/', set_name, '/');
    
    if(exist(path, 'dir'))
        error('A set with this set_name already exists! Please choose a unique name.')
    end

    % create new folder
    mkdir(path);
    
    for k=1:n
        
        % init random cuboid
        c = Cuboid.random();
        
        % randomly choose number of buckets
        n_buckets = randi([1, 25]);
        
        % randomly choose index for score to be used (+2 or mean and std)
        selection = randi([1,n_buckets+2]);
        
        % init extractor
        e = Extractor(c, n_buckets, selection);
        
        % generate filename
        padl = num2str(floor(log10(n))+1);
        index = sprintf(strcat('%0', padl, 'd'), k);
        file = strcat(set_name, '_', index, '.mat');
        
        save(strcat(path, file), 'e');
        
    end
    
end