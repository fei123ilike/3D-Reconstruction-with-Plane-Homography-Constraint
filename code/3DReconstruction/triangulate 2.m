function [P,error] = triangulate(p1,p2,C1,C2)
%TRIANGULATE compute 3D location
%   Input: p1 points in img1, n x 2
%          p2 points in img2, n x 2
%          C1 camera matrix 1 3 x 4
%          C2 camera matrix 2 3 x 4
%  Output: P points in space n x 3

    [n,~] = size(p1);
    P = zeros(n,3);
    A = zeros(4,4);
    
    % Generate AP = 0
    for i = 1 : n
        A(1,:) = p1(i,1) .* C1(3,:) - C1(1,:);
        A(2,:) = p1(i,2) .* C1(3,:) - C1(2,:);
        A(3,:) = p2(i,1) .* C2(3,:) - C2(1,:);
        A(4,:) = p2(i,2) .* C2(3,:) - C2(2,:);
        % Use SVD to compute P
        [~,~,V] = svd(A);
        h = V(:,end)';
        h = h ./ h(4);
        P(i,:) = [h(1),h(2),h(3)];
    end
  
    % compute reprojection error
    P_homo = [P';ones(1,n)];
    p1_hat = C1 * P_homo;
    p1_hat = p1_hat ./ p1_hat(3,:);
    p2_hat = C2 * P_homo;
    p2_hat = p2_hat ./ p2_hat(3,:);
    
    error = sum(sum((p1' - p1_hat(1:2,:)).^2 + (p2' - p2_hat(1:2,:)).^2));
    
    
    
    
end

