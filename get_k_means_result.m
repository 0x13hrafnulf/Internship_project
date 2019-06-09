function [labels, colors] = get_k_means_result(input_matrix, n)
    [labels, centroids] = kmeans(input_matrix, n)
    colors = zeros(n, 3);

    for i = 1:n
        colors(i,:) = i;
    end

    ratio = 1/n;
    %create some random color generation
    colors = colors * ratio;
end