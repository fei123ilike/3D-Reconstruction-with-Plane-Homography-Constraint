function [H,bestInlierIdx,debug_info] = ransacH(pts1,pts2,debug)

    % input is 2 sets of points of size n by 2,each row is a point
    pts1 = pts1';
    pts2 = pts2';
    
    % number of iteration
    itr = 50000;
    
     % each col is a point
    [~,col] = size(pts1);
    
    % threshold
    epsilon = 2;
    
    % counter and list for max inliers
    maxNumInliers = 0;
    numInliersList = zeros(itr,1);
    inliersIdxList = zeros(itr,col);
    
   
%     [pts1,T1]= normalizePoints(pts1);
%     [pts2,T2] = normalizePoints(pts2);

    for i = 1 : itr
        idx = randsample(col,4);
        tempH = computeH(pts1(:,idx),pts2(:,idx));
        error = calcDist(tempH,pts1,pts2);
        inliers_idx = find(error <= epsilon);
        numinliers = size(inliers_idx,2);
        numInliersList(i,1) = numinliers;
        inliersIdxList(i,1:numinliers) = inliers_idx;
        
        if numinliers >= maxNumInliers
            maxNumInliers = numinliers;
        end
        
        fprintf('nunber of inliers %d \n',numinliers);
        fprintf('nunber of maxInliers %d \n',maxNumInliers);
        
    end
    
    [num,position] = max(numInliersList);
    bestInlierIdx = inliersIdxList(position,1:num);
    H = computeH(pts1(:,bestInlierIdx),pts2(:,bestInlierIdx));
%     H = inv(T1) * H * T2;
    H = H/H(3,3);
    
    if debug == 1
        debug_info = calcDist(H,pts1,pts2);
        disp(debug_info);
    end
    

end

function d = calcDist(H,pts1,pts2)
%	Project PTS2 to PTS3 using H, then calcultate the distances between
%	PTS1 and PTS3
    n = size(pts1,2);
    pts3 = H * [pts2;ones(1,n)];
    pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
    d = sqrt(sum((pts1-pts3).^2,1));
end

function H = computeH(pts1,pts2)

    % compose system of eqautions 
    
    n = size(pts1,2);
    
    % separate four columns of coordinate of pts1 and pts2
    A = zeros(2*n,9);

    for i = 1:n
        
        xp = pts1(1,i);
        yp = pts1(2,i);
        x = pts2(1,i);
        y  = pts2(2,i);
        
        A(2*i-1, :)= [-x,-y,-1, 0, 0, 0,x*xp,y*xp,xp];   %odd rows
        A(2 * i, :) = [0, 0, 0,-x,-y,-1,x*yp,y*yp,yp];   %even rows
    end
    
   % solve euqation 
    [~,~,V] = svd(A);
    H = reshape(V(:,end),[3,3])';
    H = H/H(3,3); 
end

function [newX,T]= normalizePoints(x)

  % Transform taking x's centroid to the origin
  x = [x; ones(1,size(x,2))];
  
  Ttrans = [ 1 0 -mean(x(1,:)) ; 0 1 -mean(x(2,:)) ; 0 0 1 ];

  % Calculate appropriate scaling factor

  x = Ttrans * x;
  lengths = sqrt( sum( x(1:2,:).^2 ));
  s = 1 / mean(lengths);

  % Transform scaling x to an average length of sqrt(2)

  Tscale = [ s 0 0 ; 0 s 0 ; 0 0 1 ];

  % Compose the transforms

  T = Tscale * Ttrans;
  
  newX = T * x;
  newX = newX(1:2,:);
end