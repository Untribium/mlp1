classdef Generator
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shape
        base
        variance
    end
    
    methods
        function r = isCuboid(dup)
            r = (dup.shape == Shape.cuboid);
        end
    end
    
end

