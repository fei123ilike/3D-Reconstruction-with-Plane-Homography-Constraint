function [M2,P1,P2,err1,err2] = findM2(p1,p2,p3,p4,K1,K2,E)

    % M1 = [I,0]
    M1 = [1,0,0,0;
          0,1,0,0;
          0,0,1,0];
    
    C1 = K1 * M1;
    
    M2s = cameraM2(E);
    
    nM2 = size(M2s,3);
    Pcell1 = cell(nM2,1);
    Pcell2 = cell(nM2,1);
    err1 = zeros(nM2,1);
    err2 = zeros(nM2,1);
    posZ1 = zeros(nM2,1);
    posZ2 = zeros(nM2,1);
    % loop thru four M2, store the error and points in space
    for i = 1 : nM2
        C2 = K2 * M2s(:,:,i);
        [P1,error1] = triangulate(p1,p3,C1,C2);
        [P2,error2] = triangulate(p2,p4,C1,C2);
   
        Pcell1{i} = P1;
        err1(i,:) = error1;
%         idx1 = find(P1(:,3) > 0 );
%         posZ1(i,:) = length(idx1);
        posZ1(i,:) = sum(P1(:,3));
        
        Pcell2{i} = P2;
        err2(i,:) = error2;
%         idx2 = find(P2(:,3) > 0 );
%         posZ2(i,:) = length(idx2);
        posZ2(i,:) = sum(P2(:,3));
    end
    
%     finding the correct M2 and corresponding P
%     accurate = find(posZ1 == size(P1,1));
    [~,accurate] = max(posZ1);
    M2 = M2s(:,:,accurate);
    P1 = Pcell1{accurate};
    P2 = Pcell2{accurate};

end