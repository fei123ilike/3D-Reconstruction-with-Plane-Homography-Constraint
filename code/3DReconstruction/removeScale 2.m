function [warp_im1,warp_im2,corresponding_pts]=removeScale(img1,img2,bestH)
   % Adapted from 16720 homework 3

    width = 1400;
    row = size(img2,1);
    col = size(img2,2);
    corner = [1, col, 1, col;
             1,   1, row, row;
             1,   1,  1,  1];
    warp_corner = bestH * corner;
    % get the coordinate of img2 in img1's reference flame
    warp_corner = warp_corner./[warp_corner(3,:);warp_corner(3,:);warp_corner(3,:)];
    warp_corner = ceil(warp_corner);

    maxrow = max(size(img1,1),max(warp_corner(2,:)));
    minrow = min(1,min(warp_corner(2,:)));
    maxcol = max(size(img1,2),max(warp_corner(1,:)));
    mincol = min(1,min(warp_corner(1,:)));
    % get the new corner coordinate
    scale = (maxcol - mincol)/(maxrow - minrow);

    height = width/scale;
    height = round(height);
    % calculate height with input width
    
    out_size = [height,width];

    s = width/(maxcol - mincol);
    % scale between input width and calculate fraction between height and width
    scale_M = [s 0 0;0 s 0;0 0 1];

    trans_M = [1 0 0;0 1 -minrow;0 0 1];
    % translation matrix
    M = scale_M * trans_M;

    warp_im1 = warpH(img1, M, out_size);
    warp_im2 = warpH(img2, M*bestH, out_size);
    
    % calculate the intersection
    warp_im1_gray = rgb2gray(warp_im1);
    warp_im2_gray = rgb2gray(warp_im2);
    warp_im1_gray = im2double(warp_im1_gray);
    warp_im2_gray = im2double(warp_im2_gray);

    warp_im1_gray_black = find(warp_im1_gray == 0);
    warp_im2_gray_black = find(warp_im2_gray == 0);
    warp_im1_gray_white = find(warp_im1_gray >= 0.95);
    warp_im2_gray_white = find(warp_im1_gray >= 0.95);
    white_union = union(warp_im1_gray_white,warp_im2_gray_white);
    black_union = union(warp_im1_gray_black,warp_im2_gray_black);
    white_and_black = union(white_union,black_union);
    
    corresponding_idx = find(warp_im1_gray == warp_im2_gray);
    corresponding_idx = setdiff(corresponding_idx,white_and_black);
 
    x = mod(corresponding_idx,height) ;
    y = round((corresponding_idx - x)/height) ;
    corresponding_pts = [y,x];

    
    
    

end

function warp_im = warpH(im, H, out_size,fill_value)
%function warp_im = warpH(im, H, out_size,fill_value)
    if ~exist('fill_value', 'var') || isempty(fill_value)
        fill_value = 0;
    end

    tform = maketform( 'projective', H'); 
    warp_im = imtransform( im, tform, 'bilinear', 'XData', ...
        [1 out_size(2)], 'YData', [1 out_size(1)], 'Size', out_size(1:2), 'FillValues', fill_value*ones(size(im,3),1));
end