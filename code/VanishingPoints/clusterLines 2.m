function [cluster1,cluster2,cluster3] = clusterLines(lines,nclusters)

%  Cluster line segments based on close orientation
    theta = lines(:,5);
%     location = [(lines(:,1) + lines(:,2))/2,(lines(:,3) + lines(:,4))/2];

%   Using kmeans to find the dominant Groups
    n = nclusters;
    
%     opts = statset('Display','final');
%     [candicate_clusters1,~] = kmeans(location,n,'Distance','cityblock',...
%     'Replicates',5,'Options',opts);

     candicate_clusters = kmeans(theta,n);
     
    clusters_size = zeros(n,1);
%     clusters_size1 = zeros(n,1);
    for i = 1:n
        clusters_size(i,:) = size(find(candicate_clusters == i),1);
%         clusters_size1(i,:) = size(find(candicate_clusters1 == i),1);
    end
    
    [~,cluster_idx] = sort(clusters_size,'descend');
%     [~,cluster_idx1] = sort(clusters_size1,'descend');
    
    cluster1 = lines((candicate_clusters == cluster_idx(1)),:);
    cluster2 = lines((candicate_clusters == cluster_idx(2)),:);
    cluster3 = lines((candicate_clusters == cluster_idx(3)),:);
    
    

end
