function [labels, colors] =  get_hierarchial_result(input_matrix, n)
    
    tic
    labels = clusterdata(input_matrix,'Linkage','centroid', 'MaxClust', n);
    toc
    colors = zeros(8, 3);

    for i = 1:8
        colors(i,:) = i;
    end

    ratio = 1/8;
    %create some random color generation
    colors = colors * ratio;
end