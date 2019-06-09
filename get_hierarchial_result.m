function [labels, colors] =  get_hierarchial_result(input_matrix, n)
    labels = clusterdata(input_matrix,'Linkage','centroid', 'MaxClust', n)
    colors = zeros(n, 3);

    for i = 1:n
        colors(i,:) = i;
    end

    ratio = 1/n;
    %create some random color generation
    colors = colors * ratio;
end