function [newVP1,newVP2,newVP3] = automaticVP(filename,nclusters,refine)
%AUTOMATICVP automatic compute and refine vanishing points
    %   Line segmentation detection
    if refine == 0
        
        if isstring(filename)
            img = imread(['./images/input/',filename,'.jpg']);
        else
            img = filename;
        end
        grayIm = rgb2gray(img);
        [h,w] = size(grayIm);
        diag = sqrt(h^2 + w^2);
        minLen = 0.025*diag;
        line =  APPgetLargeConnectedEdges(grayIm, minLen);

        % cluster line segments
        [c1,c2,c3] = clusterLines(line,nclusters);


        % ransac 
        [newVP1,c1,error1] = ransacVP(c1);
        fprintf('\n VP for cluster 1 %8.4f \n ',newVP1);

        [newVP2,c2,error2] = ransacVP(c2);
        fprintf('\n VP for cluster 2 %8.4f \n ',newVP2);

        [newVP3,c3,error3] = ransacVP(c3);
        fprintf('\n VP for cluster 3 %8.4f \n ',newVP3);
   
   
    
    % If Refinement and show all the plot
    else
        %   Line segmentation detection
        img = imread(['./images/input/',filename,'.jpg']);
        grass_set = {'1_001','1_002','1_003','1_004','1_005','2_002','2_003','3_001','3_002',};
        grass = strcmp(filename,grass_set);
        if any(grass(:) == 1)
            img_no_grass = removeGrass(img);
            grayIm = rgb2gray(img_no_grass);
        else
            grayIm = rgb2gray(img);
        end
        
        if strcmp(filename,'3_001') || strcmp(filename,'3_002')
            grayIm(:,874:end,:) = 0;
        end
        
        if strcmp(filename,'P1020848') 
            grayIm(386:end,:,:) = 0;
        end
        
        if strcmp(filename,'P1030001') 
            grayIm(410:end,:,:) = 0;
        end
        
        [h,w] = size(grayIm);
        diag = sqrt(h^2 + w^2);
        minLen = 0.025*diag;
        
        line =  APPgetLargeConnectedEdges(grayIm, minLen);

        figure;
        title('Original Image');
        imshow(img);
        hold on;
        plot(line(:, [1 2])', line(:, [3 4])','LineWidth',2);
        hold off;

        % cluster line segments
        [c1,c2,c3] = clusterLines(line,nclusters);

        figure;
        title('Cluster Line Segmentation');
        imshow(img);
        hold on;
        plot(c1(:, [1 2])', c1(:, [3 4])','r','LineWidth',2);
        plot(c2(:, [1 2])', c2(:, [3 4])','g','LineWidth',2);
        plot(c3(:, [1 2])', c3(:, [3 4])','b','LineWidth',2);
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-cluster.jpg'));
        % ransac 
        [VP1,c1,error1] = ransacVP(c1);
        fprintf('\n VP for cluster 1 %8.4f \n ',VP1);

        [VP2,c2,error2] = ransacVP(c2);
        fprintf('\n VP for cluster 2 %8.4f \n ',VP2);

        [VP3,c3,error3] = ransacVP(c3);
        fprintf('\n VP for cluster 3 %8.4f \n ',VP3);

        % Visualize the vanishing lines
        figure;
        title('Visualize the vanishing lines');
        range = [-5*size(img,2),5*size(img,2)];
        imshow(img);
        hold on;

        for i = 1: size(c1,1)
           plotLine(c1(i,:),range,'r');
           hold on;
        end


        for i = 1: size(c2,1)
           plotLine(c2(i,:),range,'g');
           hold on;
        end


        for i = 1: size(c3,1)
           plotLine(c3(i,:),range,'b');
           hold on;
        end
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-vanishingLines.jpg'));
        % Visualize the vanishing points
        % VP1
        figure;
        scatter(VP1(1),VP1(2),150,'r.');
        hold on;
        imshow(img);
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-VP1.jpg'));
        % VP2
        figure;
        scatter(VP2(1),VP2(2),150,'r.');
        hold on;
        imshow(img);
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-VP2.jpg'));
        % VP3
        figure;
        scatter(VP3(1),VP3(2),150,'r.');
        hold on;
        imshow(img);
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-VP3.jpg'));
        
        [newVP1,newVP2,newVP3,newc1,newc2,newc3] = refineCluster(c1,c2,c3,VP1,VP2,VP3);

        % Visualize the Refinement
        figure(5);
    %     title('Visualize the Refined Vanishing Points');
        scatter(VP1(1),VP1(2),180,'r.');
        hold on;
        scatter(newVP1(1),newVP1(2),180,'g.');
        hold on;

        scatter(VP2(1),VP2(2),180,'r.');
        hold on;
        scatter(newVP2(1),newVP2(2),180,'g.');
        hold on;

        scatter(VP3(1),VP3(2),180,'r.');
        hold on;
        scatter(newVP3(1),newVP3(2),180,'g.');
        hold on;

        imshow(img);
        hold off;
        saveas(gcf,strcat('./images/result/1/',filename,'-refine.jpg'));
    end

end

