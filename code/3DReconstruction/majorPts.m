function [major_label] = majorPts(allPts)
%MAJORPTS Find the major ponits in a plane
%   Input:
%         unfiltered pionts n x 2 
%         indices of unfiltered points
%   Output:
% .        major ponits in a plane
    n = 2;
    pts = allPts;
    [label,~] = kmeans(pts,n);
    label_hist = zeros(2,1);
    for i = 1 :n
        label_hist(i,:) = length(pts(label == i));
    end
    [~,major_label] = max(label_hist);
%     majorPts = pts(major_label,:);
end

