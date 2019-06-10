function [labels, colors] = get_dbscan_result(input_matrix, eps,  n_neigh)
    
    labels = dbscan(input_matrix, eps, n_neigh);
    colors = zeros(8, 3);

    for i = 1:8
        colors(i,:) = i;
    end

    ratio = 1/8;
    %create some random color generation
    colors = colors * ratio;

    function idx = dbscan(input_matrix, epsilon, MinPts)

        cluster_n = 0;
        n = size(input_matrix,1);
        idx = zeros(n,1);
        checked = false(n,1);
    
        dist = pdist2(input_matrix, input_matrix, 'euclidean'); 
    %calculate distances between each points D(i,j) => observation i in X and observation j in Y.
    %     0      1   2 3 ...   n
    %0 d(0,0) d(0,1)  ...    d(0,n)
    %1 ...
    %2 ...
    %3 ...
    % ...
    %n d(n,0)     ...     d(n,n)
    
    
        for i=1:n
            if ~checked(i)
                checked(i) = true;
            
                neighbours = RegionQuery(i); %check neighbors
                if numel(neighbours) < MinPts %check whether number of neighbors fits the specified number of neighbors
                    idx(i) = 0;%means that matrix[i] is noise
                else
                    cluster_n = cluster_n + 1; %new label
                    ExpandCluster(i, neighbours, cluster_n);
                end          
            end  
        end
    
        function ExpandCluster(i, neighbours, cluster_n)%expanding the neighborhood
            idx(i) = cluster_n;
        
            k = 1;
            while true
                j = neighbours(k);
            
                if ~checked(j)
                    checked(j) = true;
                    neighbours_temp = RegionQuery(j);
                    if numel(neighbours_temp) >= MinPts
                        neighbours = [neighbours, neighbours_temp];   %append the new found neighbors
                    end
                end
                if idx(j) == 0
                    idx(j) = cluster_n;
                end
            
                k = k + 1;
                if k > numel(neighbours) %break if no more neighbors to check
                    break;
                end
            end
        end
        function neighbours = RegionQuery(i) %creates the vector of neighbors inside specified radius based on Distance matrix found by pdist2
            neighbours = find(dist(i, :) <= epsilon);%if inside the radius
        end
    end  
end

