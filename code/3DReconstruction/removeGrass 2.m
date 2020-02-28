function RGBm = removeGrass(image)

% get image dimensions: an RGB image has three planes
% reshaping puts the RGB layers next to each other generating
% a two dimensional grayscale image
[height, width, planes] = size(image);
% rgb = reshape(image, height, width * planes);

r = image(:, :, 1);             % red channel
g = image(:, :, 2);             % green channel
b = image(:, :, 3);             % blue channel

% threshold = 100;                % threshold value


% apply the greenness/blueness calculation
greenness = double(g) - max(double(r), double(b));


mask = greenness < 9;

mask3 = cat(3, mask, mask, mask);
RGBm  = image;
RGBm(~mask3) = 0;

% imshow(RGBm);
end