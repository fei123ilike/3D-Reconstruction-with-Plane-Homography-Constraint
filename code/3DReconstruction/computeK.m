function [K,debug_info] = computeK(img,debug_mode)
%COMPUTK input an image, output a camera intrinsic matrix K
    %Get 3 vanishing Points
    refine = 0;
    [VP1,VP2,VP3] = automaticVP(img,4,refine);
    % Based the Mahattan assumption, vanishing ponits are orthogonal
    % W = [w1,0,w2;0,w1,w3;w2,w3,w4];
    % since VP(i)*W*VP(j) = 0, construct a system of equations
    % solve AW = 0;
    x1 = VP1(1); y1 = VP1(2);
    x2 = VP2(1); y2 = VP2(2);
    x3 = VP3(1); y3 = VP3(2);
    A = zeros(3,4);
    A(1,:) = [x1*x2 + y1*y2, x2 + x1, y2 + y1, 1];
    A(2,:) = [x3*x2 + y3*y2, x2 + x3, y2 + y3, 1];
    A(3,:) = [x3*x1 + y3*y1, x1 + x3, y1 + y3, 1];
    
    
%     X = null(A);
%     W = [X(1),0,X(2);0,X(1),X(3);X(2),X(3),X(4)];
    
    % LDL Factorization
    
%     [L, ~] = ldl(inv(W));
%     K = L';
%     K = K ./ K(3,3);
    
    % Cholesky Factorization
    [~,~,V] = svd(A);
    X = V(:,end);
    W = [X(1),0,X(2);0,X(1),X(3);X(2),X(3),X(4)];
    K = inv(chol(W));
    K = K ./ K(3,3);
 
    if debug_mode == 1
        debug_info = K;
    end
    debug_info = 0;
end

