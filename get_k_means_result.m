function labels = get_k_means_result(input_matrix, n)
    
    tic
    [labels, centroids] = kmeans(input_matrix, n);
    toc
end