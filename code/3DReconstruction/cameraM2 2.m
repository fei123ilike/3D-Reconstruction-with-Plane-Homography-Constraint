function [M2s] = cameraM2(E)
% Adapted from 16720 homework 4
%CAMERAMATRIX2 From Essetial matrix retrive possible camera2 matrices
% assuming M1 = [I 0], M2 = [R t];
[U,S,V] = svd(E);
m = (S(1,1)+S(2,2))/2;
E = U*[m,0,0;0,m,0;0,0,0]*V';
[U,S,V] = svd(E);
W = [0,-1,0;1,0,0;0,0,1];

%R otation matrices with det(R) == 1
if (det(U*W*V')<0)
    W = -W;
end

M2s = zeros(3,4,4);
M2s(:,:,1) = [U*W*V',U(:,3)./max(abs(U(:,3)))];
M2s(:,:,2) = [U*W*V',-U(:,3)./max(abs(U(:,3)))];
M2s(:,:,3) = [U*W'*V',U(:,3)./max(abs(U(:,3)))];
M2s(:,:,4) = [U*W'*V',-U(:,3)./max(abs(U(:,3)))];
end

