function [labels, colors] = get_k_means_result(input_matrix, n)
    [labels, centroids] = kmeans(input_matrix, n);
    colors = zeros(8, 3);

    for i = 1:8
        colors(i,:) = i;
    end

    ratio = 1/8;
    %create some random color generation
    colors = colors * ratio;
end