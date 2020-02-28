function [matchedPoints1,matchedPoints2] = findCorrespondingPoints(img1,img2,filename)

    % Converto grayscale image
    I1 = rgb2gray(img1);
    I2 = rgb2gray(img2);
    
    % Detect and store Harries / SURF keypoints.
%     points1 = detectHarrisFeatures(I1,'FilterSize', 19);
%     points2 = detectHarrisFeatures(I2,'FilterSize', 19);
    
    points1 = detectSURFFeatures(I1,'MetricThreshold',600);
    points2 = detectSURFFeatures(I2,'MetricThreshold',600);
   
    
    % extract features
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    % match the features
    indexPairs = matchFeatures(features1,features2);
    
    % Retrieve the locations of the corresponding points for each image.
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
    
    figure;
    showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    saveas(gcf,strcat('./images/result/2/',filename,'-matching.jpg'));
end