function [labels, colors] = get_gmm_result(input_matrix, n) 
    options = statset('Display','final'); 
    gm = fitgmdist(input_matrix, n,'Options',options);
    labels = cluster(gm,input_matrix);
    
     colors = zeros(8, 3);

    for i = 1:8
        colors(i,:) = i;
    end

    ratio = 1/8;
    %create some random color generation
    colors = colors * ratio;
end