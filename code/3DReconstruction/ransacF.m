function [F,e] = ransacF(H,pts1,pts2,idxOnOtherPlane)
    % input: homograpy for one plane, matched points on img1,
    % .       matched points on img2, indices for another plane.
    % output: fundamental matrix
    
    % input is 2 sets of points of size n by 2,each row is a point
    pts1 = pts1(idxOnOtherPlane,:)';
    pts2 = pts2(idxOnOtherPlane,:)';
    pts1 = [pts1; ones(1,size(pts1,2))];
    pts2 = [pts2; ones(1,size(pts2,2))];
    
     % number of iteration
    itr = 5000;
    
    % threshold
    epsilon = 0.05;
    
    nPts = size(pts1,2);

    maxInliers = 0;
    error = zeros(nPts,1);


    % we use two correspondences to find the epipole on img1
    for i = 1 : itr
        idx = randsample(nPts,2);
        p1 = pts1(:,idx(1));
        p1m = pts2(:,idx(1)); % matched p1 on img2
        p2 = pts1(:,idx(2));
        p2m = pts2(:,idx(2)); % matched p2 on img2
        
        Hp1m = H * p1m;
        Hp1m = Hp1m ./ Hp1m(3);
        
        Hp2m = H * p2m;
        Hp2m = Hp2m ./ Hp2m(3);
        
        l1 = cross(Hp1m,p1); % parallax line1
        l1 = l1 ./ l1(3);
        l2 = cross(Hp2m,p2); % parallax line2
        l2 = l2 ./ l2(3);
        
        % calculate the epipole on img1 as the intersection of lines l1 l2
        e = cross(l1,l2);
        e = e ./ e(3);
        e_matrix= cross(repmat(e,1,3),eye(3,3));
        tmpF = e_matrix * H;
        tmpF = tmpF/tmpF(3,3);

        for j = 1 : nPts
            error(j,1) = abs(pts1(:,j)' * tmpF * pts2(:,j));
        end
        
        inlier_idx = find(error <= epsilon);
        inliers = size(inlier_idx,1);
        
        
        if inliers >= maxInliers
            maxInliers = inliers;
            F = tmpF;
        end
        fprintf('nunber of inliers %d \n',inliers);
        fprintf('nunber of maxInliers %d \n',maxInliers);
    end
    
    
end



