classdef Region
    
    properties
        
    end
    
    methods(Abstract)
        scores = histogram(o, brain, n_buckets)
    end
    
    methods(Abstract, Static)
        max = max_size()
        rand = random()
    end
end