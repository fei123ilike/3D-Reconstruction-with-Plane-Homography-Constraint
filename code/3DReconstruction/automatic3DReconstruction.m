function automatic3DReconstruction(filename1,filename2)
%AUTOMATIC3DRECONSTRUCTION Given 2 images, automiatic generate 3D
%reconstruction
%% find corresponding points
% img1 = imread('./images/input/1_002.jpg');
% img2 = imread('./images/input/1_003.jpg');

img1 = imread(['./images/input/',filename1,'.jpg']);
img2 = imread(['./images/input/',filename2,'.jpg']);

[matchedPoints1,matchedPoints2] = findCorrespondingPoints(img1,img2,filename1);
%% calculate the Homography from img2 to img1 (plane 1)

all_pts1 = matchedPoints1.Location;
all_pts2 = matchedPoints2.Location;

n = size(all_pts1,1);
debug = 1;
[H2to1,idxPlane1,~] = ransacH(all_pts1,all_pts2,debug);

%% calculate the Homography from img2 to img1 (plane 2)
res_idx = setdiff((1:n),idxPlane1);
res_pts3 = all_pts1(res_idx,:);
res_pts4 = all_pts2(res_idx,:);

[H2to1P,idxPlane2,~] = ransacH(res_pts3,res_pts4,debug);
%% Visualize 2 planes
p1 = double(all_pts1(idxPlane1,:));
[k1,~] = convhull(p1);

p2 = double(res_pts3(idxPlane2,:));
[k2,~] = convhull(p2);


figure;
imshow(img1);
hold on;

scatter(p1(:,1),p1(:,2),100,'g.');
scatter(p2(:,1),p2(:,2),100,'b.');

plot(p1(k1,1),p1(k1,2),'g');
plot(p2(k2,1),p2(k2,2),'b');

f1 = fill(p1(k1,1),p1(k1,2),'g');
set(f1,'facealpha',0.3);

f2 = fill(p2(k2,1),p2(k2,2),'b');
set(f2,'facealpha',0.3);

saveas(gcf,strcat('./images/result/2/',filename1,'-2Planes.jpg'));
hold off;


%% visualize the transformed img2  and remove scale

H2to1 = double(H2to1);
H2to1P = double(H2to1P);

% plane 1
[warp_im1,warp_im2,~]=removeScale(img1,img2,H2to1);
figure;
imshow(warp_im1);
alpha(0.8);
hold on;

imshow(warp_im2);
alpha(0.6);
hold on;

hold off;
saveas(gcf,strcat('./images/result/2/',filename1,'-Homography1.jpg'));
% plane 2
[warp_im3,warp_im4,~]=removeScale(img1,img2,H2to1P);
figure;
imshow(warp_im3);
alpha(0.8);
hold on;

imshow(warp_im4);
alpha(0.6);
hold on;

hold off;
saveas(gcf,strcat('./images/result/2/',filename1,'-Homography2.jpg'));
%% calculate F

% [F,e] = computeF(inv(H2to1),all_pts1,all_pts2,idxPlane2);
[F,e] = ransacF(inv(H2to1),all_pts1,all_pts2,idxPlane2);
%% calculate K1,K2
debug = 0;
if strcmp(filename1,'3_001')
    img1 = removeGrass(img1);
    img2 = removeGrass(img2);
    img1(:,874:end,:) = 0;
    img2(:,874:end,:) = 0;

end
[K1,~] = computeK(img1,debug);
[K2,~] = computeK(img2,debug);
%% Essetial Matrix
E = K2' * F * K1;
% E = K1' * F1 * K2;
E = E ./ E(3,3);
%% Find the 3D points for 2 planes, triangulate

p1 = all_pts1(idxPlane1,:);
p2 = res_pts3(idxPlane2,:);
p3 = all_pts2(idxPlane1,:);
p4 = res_pts4(idxPlane2,:);
[M2,P1,P2,err1,err2] = findM2(p1,p2,p3,p4,K1,K2,E);
%% Visualize 3D points for 2 planes

% figure;
im1 = double(img1)/255;
im2 = double(img2)/255;
npt1 = size(p1,1);
p1 = round(p1);
color1 = zeros(npt1,3);
for i = 1 : npt1
    R1 = im1(p1(i,2),p1(i,1),1);
    G1 = im1(p1(i,2),p1(i,1),2); 
    B1 = im1(p1(i,2),p1(i,1),3);
    color1(i,:) = [R1,G1,B1];
end

PX1 = P1(:,1);
PY1 = P1(:,2);
PZ1 = P1(:,3);

scatter3(PX1(:),PY1(:),PZ1(:),80,color1,'filled');
hold on;

PX2 = P2(:,1);
PY2 = P2(:,2);
PZ2 = P2(:,3);

npt2 = size(p2,1);
p2 = round(p2);
color2 = zeros(npt2,3);
for i = 1 : npt2
    R2 = im2(p2(i,2),p2(i,1),1);
    G2 = im2(p2(i,2),p2(i,1),2); 
    B2 = im2(p2(i,2),p2(i,1),3);
    color2(i,:) = [R2,G2,B2];
end

scatter3(PX2(:),PY2(:),PZ2(:),80,color2,'filled');
hold off;


end

