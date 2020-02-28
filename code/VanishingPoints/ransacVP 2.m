function [vanishingPoint,newLineSeg,error] = ransacVP(lineCluster)
    % input: line clusters left, right, vertical
    % output: vanishing points
    
    % number of iteration
    itr = 50000;
    
    % threshold
    epsilon = 0.1;
    
    maxInliers = 0;
    vanishingPoint = zeros(3);
    [row,~] = size(lineCluster);

    
    % calculate lines for each line segematation
    p1 = [lineCluster(:,1),lineCluster(:,3),ones(row,1)];
    p2 = [lineCluster(:,2),lineCluster(:,4),ones(row,1)];
    lines = cross(p1,p2);
    lines = lines ./ lines(:,3);
    
    for j = 1 : itr 
        idx = randsample(row,2);
        l1 = lines(idx(1),:);
        l2 = lines(idx(2),:);
        
        % candidate vanishing point
        vp = cross(l1,l2);
        vp = vp ./ vp(3);
        error = abs(lines * vp');
        segment_idx = find(error <= epsilon);
        inliers = size(segment_idx,1);
        
        if inliers >= maxInliers
            maxInliers = inliers;
            vanishingPoint = vp;
            new_segment_idx = segment_idx;
        end
        fprintf('nunber of inliears %d \n',inliers);
        fprintf('nunber of maxInliers %d \n',maxInliers);
        
 
    end
    newLineSeg =zeros(maxInliers,3);
    for k = 1:maxInliers
        newLineSeg(k,:) = lines(new_segment_idx(k,:),:);
    end
end