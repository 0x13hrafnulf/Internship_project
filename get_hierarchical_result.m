function labels =  get_hierarchical_result(input_matrix, n)
    
    tic
    labels = clusterdata(input_matrix(:,1:2), 'Linkage', 'centroid', 'MaxClust', n);
    toc

end
