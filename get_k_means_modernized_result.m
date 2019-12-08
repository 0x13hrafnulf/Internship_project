function labels = get_k_means_modernized_result(input_matrix, n)
    
    tic
    labels = kmeans_m(input_matrix(:,1:2), n);
    toc
    
    function idx = kmeans_m(input_matrix, k)
     
     
     M = size(input_matrix,1);
     centroids = ones(k, 2);
     idx = zeros(M, 1);
     %Step1: calculate center mass for x and y
     
     
     c_x = sum(input_matrix(:,1))/M;
     c_y = sum(input_matrix(:,2))/M;
     
     %Step2: 
     %randomly choose K-1 centroids
     randIdx = randperm(M,k-1);
     t_rand = transpose(randIdx);
     centroids = input_matrix(t_rand,:);

     %calculate last centroid xk = k*c_x - sum(centroids(:,1))
     %calculate last centroid yk = k*c_y - sum(centroids(:,2))
     centroids(k,1) = k*c_x - sum(centroids(:,1));%xk
     centroids(k,2) = k*c_y - sum(centroids(:,2));%yk
     
     %Step3: 
     %assign each point to specific cluster based on distance

     for i = 1:M
         dist = zeros(k,1);
         for j = 1:k
            dist(j,1) = norm(input_matrix(i,:)-centroids(j,:));
         end   
         [~, cluster] = min(dist);
         idx(i) = cluster;
     end
     
     %Step4: 
     %calculate center mass for K-1 centroids
     %calculate last centroid xk = k*c_x - sum(centroids(:,1))
     %calculate last centroid yk = k*c_y - sum(centroids(:,2))
     
     for i = 1:k-1
        centroids(i,1)= mean(input_matrix(idx == i,1));
        centroids(i,2)= mean(input_matrix(idx == i,1));
     end
     
     centroids(k,1) = k*c_x - sum(centroids(:,1));%xk
     centroids(k,2) = k*c_y - sum(centroids(:,2));%yk
     
     %Step5:
     %repeat Steps 3 & 4 until sum((distance(point(i),m(i))^2)) is
     %minimized
     norm_val = 99999999999999999;
     t_norm_val = 0;
     while true
         
        for i = 1:M
             dist = zeros(k,1);
             for j = 1:k
                dist(j,1) = norm(input_matrix(i,:)-centroids(j,:));
             end   
             [~, cluster] = min(dist);
             idx(i) = cluster;
        end
         
        for i = 1:k-1
            centroids(i,1)= mean(input_matrix(idx == i,1));
            centroids(i,2)= mean(input_matrix(idx == i,1));
        end
     
        centroids(k,1) = k*c_x - sum(centroids(:,1));%xk
        centroids(k,2) = k*c_y - sum(centroids(:,2));%yk
        
        %calculate norm val
        for i = 1:M
            t_norm_val = t_norm_val + norm(input_matrix(i) - centroids(idx(i))).^2;
        end
        if(t_norm_val < norm_val) 
            norm_val = t_norm_val;
        else 
            break;
        end
     end
    end     
end