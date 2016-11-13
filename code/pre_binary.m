% Author: X.GAO
function [img_bin] = pre_binary(image)

image = rgb2gray(image);
[~,y] = size(image);
% image = imresize(image,1,'bilinear'); 
th = graythresh(image); 
image = im2bw(image,th);
img_bin = 1-double(image); 

end

