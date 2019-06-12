function labels = get_gmm_result(input_matrix, n) 
    
    options = statset('Display','final', 'MaxIter', 200); 
    
    tic
    gm = fitgmdist(input_matrix, n,'Options',options,'CovarianceType','diagonal','SharedCovariance', true);
    labels = cluster(gm,input_matrix);
    toc
    
end