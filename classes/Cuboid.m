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
        
        function hog = hog(o, data)
            M = o.submatrix(data);
            M = M(:, floor((o.y(2)-o.y(1))/2), :);
            I = mat2gray(squeeze(M));
            
            bs = [2,2];
            cs = floor([o.x(2)-o.x(1), o.z(2)-o.z(1)]./bs);
            
            hog = extractHOGFeatures(I, 'CellSize', cs, 'BlockSize', bs, 'NumBins', 3, 'BlockOverlap', [0,0]);
        end
        
        function sub = submatrix(o, data)
            sub = data(o.x(1):o.x(2), o.y(1):o.y(2), o.z(1):o.z(2));
        end
        
        function cubes = split(o, n)
            % why is this so slow?...
            
            cubes = Cuboid.empty(0);
            
            s = o.max_size()./n;
            
            z_ = [1,s(1)];
            for i=1:n
                y_ = [1,s(2)];
                for j=1:n
                    x_ = [1,s(3)];
                    for k=1:n
                        
                        cubes = [cubes, Cuboid(floor(x_), floor(y_), floor(z_))];
                        
                        x_ = x_ + s(3);
                    end
                    y_ = y_ + s(2);
                end
                z_ = z_ + s(3);
            end
        end
    end
    
    methods(Static)
        function max = max_size()
            max = [176,208,176];
        end
        
        function o = max_instance()
            s = Cuboid.max_size()';
            s = [ones(3,1), s];
            o = Cuboid(s(1,:), s(2,:), s(3,:));
        end
        
        function o = random_instance()
            % create random cuboid
            size = Cuboid.max_size();
            voxels = 1;
            
            % make sure region isn't tiny
            while(voxels < 500)
                voxels = 1;
                
                %   randomly choose indices for x dim
                x = randi([1, size(1)], 1, 2);
                x = sort(x);
                voxels = voxels*(x(2)-x(1));

                %   randomly choose indices for y dim
                y = randi([1, size(2)], 1, 2);
                y = sort(y);
                voxels = voxels*(y(2)-y(1));
                
                %   randomly choose indices for z dim
                z = randi([1, size(3)], 1, 2);
                z = sort(z);
                voxels = voxels*(z(2)-z(1));
            
                o = Cuboid(x, y, z);
            end
        end
    end
end