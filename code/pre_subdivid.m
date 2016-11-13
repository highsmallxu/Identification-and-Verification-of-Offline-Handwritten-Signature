% Author: X.GAO
function [img_patchs] = pre_subdivid(image)

[x,y] = size(image);
img_patchs = cell(0);

xx = round(x/4);
yy = round(y/4);

patch_idx = 1;
for i=1:4
    for j=1:4
        if i==4
            patch = image((i-1)*xx+1:x,(j-1)*yy+1:j*yy);
        else
            patch = image((i-1)*xx+1:i*xx,(j-1)*yy+1:j*yy);

        end
        img_patchs{patch_idx} = patch;
        patch_idx = patch_idx + 1;
    end
end

end

