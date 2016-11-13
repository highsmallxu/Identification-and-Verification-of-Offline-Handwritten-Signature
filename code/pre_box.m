% Author: X.GAO
function [img_crop] = pre_box(image)

[row,col] = size(image);
for i=1:row
    if sum(image(i,:))~=0
        crop_up = i;
        break
    end
end

for ii=row:-1:1
    if sum(image(ii,:))~=0
        crop_down = ii;
        break
    end
end

for j=1:col
    if sum(image(:,j))~=0
        crop_left = j;
        break
    end
end

for jj=col:-1:1
    if sum(image(:,jj))~=0
        crop_right = jj;
        break
    end
end

img_crop = image(crop_up:crop_down,crop_left:crop_right);
[~,y] = size(img_crop);
img_crop = imresize(img_crop,448/y,'bilinear');
end

