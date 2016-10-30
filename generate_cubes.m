function cubes = generate_cubes(n)
    
    cubes = Cuboid.max_instance().split(n);
    
    set(1) = DataSet('train');
    set(2) = DataSet('test');
    for i=1:2
        for j=1:set(i).count
            b = set(i).load(j);

            for k=1:n^3
                cubes(k).extreme_values(b);
            end
        end
    end
    
    for i=n^3:-1:1
        if(cubes(i).v_max == 0)
            cubes(i) = [];
        end
    end
    
end