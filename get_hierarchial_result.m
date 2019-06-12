function labels =  get_hierarchial_result(input_matrix, n)
    
    tic
    labels = clusterdata(input_matrix,'Linkage','centroid', 'MaxClust', n);
    toc

end