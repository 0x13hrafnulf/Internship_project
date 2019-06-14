function labels = get_dbscan_result(input_matrix, eps, n_neigh, data_sz)
    
    tic
    labels = dbscan(input_matrix, eps, n_neigh);
    toc
    function idx = dbscan(input_matrix, epsilon, MinPts)

        cluster_n = 0;
        n = size(input_matrix,1);
        idx = zeros(n,1);
        checked = false(n,1);

        Dist_Tree = ExhaustiveSearcher(input_matrix(:,1:2));%KDTreeSearcher
        neighbours1 = rangesearch(Dist_Tree, input_matrix(:,1:2),epsilon);

        for i=1:n
            if (~checked(i))
                checked(i) = true;
            
                neighbours = RegionQuery(i); %check neighbors
                
                if (numel(neighbours) < MinPts) %check whether number of neighbors fits the specified number of neighbors
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
            
                if (~checked(j))
                    checked(j) = true;
                    neighbours_temp = RegionQuery(j);
                    if (numel(neighbours_temp) >= MinPts)
                        neighbours = [neighbours, neighbours_temp];   %append the new found neighbors
                    end
                end
                if (idx(j) == 0)
                    idx(j) = cluster_n;
                end
            
                k = k + 1;
                if (k > numel(neighbours)) %break if no more neighbors to check
                    break;
                end
            end
        end
        function neighbours = RegionQuery(q) %creates the vector of neighbors inside specified radius based on Distance matrix found by pdist2          
                neighbours = neighbours1{q};
        end
          
    end
end

