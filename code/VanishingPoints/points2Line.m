function dist = points2Line(oldCluster,oldLine)
    p1 = [oldCluster(:,1),oldCluster(:,3)];
    p2 = [oldCluster(:,2),oldCluster(:,4)];
    dist = zeros(size(oldLine,1),1);
    for i = 1 : size(oldLine,1)
        temp1 = (oldLine(i,:) * p1')^2 / (oldLine(:,1)^2 + oldLine(:,2)^2);
        temp2 = (oldLine(i,:) * p2')^2 / (oldLine(:,1)^2 + oldLine(:,2)^2);
        dist(i,:) = temp1 + temp2;
    end
    
end