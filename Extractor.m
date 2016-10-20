classdef Extractor

    properties
        region
        n_buckets
        selection
        error
    end
    
    methods
        function o = Extractor(region, n_buckets, selection)
            if(nargin >= 3)
                o.region = region;
                o.n_buckets = n_buckets;
                o.selection = selection;
            end
        end
        
        function score = extract(o, brain)
            scores = o.region.histogram(brain, o.n_buckets);
            score = scores(o.selection);
        end
    end
end