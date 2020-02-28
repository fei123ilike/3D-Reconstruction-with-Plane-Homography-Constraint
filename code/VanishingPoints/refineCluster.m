function [newVP1,newVP2,newVP3,newc1,newc2,newc3] = refineCluster(c1,c2,c3,VP1,VP2,VP3)

    disp('Start Refinement');
    newc1 = fminsearch (@distCost, c1, ...
                   optimset ('MaxFunEvals', 5, ...
                             'MaxIter', 100000, ....
                             'Algorithm', 'levenberg-marquardt'), ...
                   VP1);
               
    disp('Finished 1st VP Refinement');
    
    newc2 = fminsearch (@distCost, c2, ...
                   optimset ('MaxFunEvals', 5, ...
                             'MaxIter', 100000, ....
                             'Algorithm', 'levenberg-marquardt'), ...
                   VP2);
    disp('Finished 2nd VP Refinement');
    
    newc3 = fminsearch (@distCost, c3, ...
                   optimset ('MaxFunEvals', 5, ...
                             'MaxIter', 100000, ....
                             'Algorithm', 'levenberg-marquardt'), ...
                   VP3);
               
    disp('Finished 3rd VP Refinement');

    
    newVP1 = computeVP(newc1);
    newVP1 = newVP1 / newVP1(3);
    newVP2 = computeVP(newc2);
    newVP2 = newVP2 / newVP2(3);
    newVP3 = computeVP(newc3);
    newVP3 = newVP3 / newVP3(3);
    

end


function cost = distCost(c,VP)
    [row,~] = size(c); 

     VP_matrix = VP .* ones(row,1);

     lines = c;
     dist = sum(lines .* VP_matrix, 2);
     cost = sum(dist(:));

end

function VP = computeVP(line_cluster)
    [row,~] = size(line_cluster);
    idx = randsample(row,2);
    l1 = line_cluster(idx(1),:);
    l2 = line_cluster(idx(2),:);
    VP = cross(l1,l2);
end