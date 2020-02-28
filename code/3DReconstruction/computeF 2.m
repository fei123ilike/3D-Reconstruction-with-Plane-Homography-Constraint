function[F,e] = computeF(H,pts1,pts2,idxOnOtherPlane)
    pts1 = pts1(idxOnOtherPlane,:)';
    pts2 = pts2(idxOnOtherPlane,:)';
    pts1 = [pts1; ones(1,size(pts1,2))];
    pts2 = [pts2; ones(1,size(pts2,2))];
    nPts = size(pts1,2);
    
    idx = randsample(nPts,2);
    % plane2 correnspondents points on img1 and img2
    p1 = pts1(:,idx(1));
    p1m = pts2(:,idx(1));
    % plane2 correnspondents points on img1 and img2
    p2 = pts1(:,idx(2));
    p2m = pts2(:,idx(2));
    
    Hp1m = H * p1m;
    Hp1m = Hp1m ./ Hp1m(3);

    Hp2m = H * p2m;
    Hp2m = Hp2m ./ Hp2m(3);

    l1 = cross(Hp1m,p1); 
    l1 = l1 ./ l1(3);
    l2 = cross(Hp2m,p2); 
    l2 = l2 ./ l2(3);

    % calculate the epipole on img1 as the intersection of lines l1 l2
    e = cross(l1,l2);
    e = e ./ e(3);
    e_matrix= cross(repmat(e,1,3),eye(3,3));
    F = e_matrix * H;
    F = F/F(3,3);
end