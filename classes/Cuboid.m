classdef Cuboid < Region
    
    properties
        x
        y
        z
    end
    
    methods
        function o = Cuboid(x, y, z)
            o.x = x;
            o.y = y;
            o.z = z;
        end
        
        function hgram = histogram(o, data, n_buckets)
            hgram = histcounts(o.submatrix(data), n_buckets);
        end
        
        function mean = mean(o, data)
            mean = mean2(o.submatrix(data));
        end
        
        function std = std(o, data)
            std = std2(o.submatrix(data));
        end
        
        function sub = submatrix(o, data)
            sub = data(o.x(1):o.x(2), o.y(1):o.y(2), o.z(1):o.z(2));
        end
    end
    
    methods(Static)
        function max = max_size()
            max = [176,208,176];
        end
        
        function o = random_instance()
            % create random cuboid
            size = Cuboid.max_size();
            
            %   randomly choose indices for x dim
            x = randi([1, size(1)], 1, 2);
            x = sort(x);

            %   randomly choose indices for y dim
            y = randi([1, size(2)], 1, 2);
            y = sort(y);

            %   randomly choose indices for z dim
            z = randi([1, size(3)], 1, 2);
            z = sort(z);
            
            o = Cuboid(x, y, z);
        end
    end
end