% Author: X.GAO
function [img_rot] = pre_rotate(image)

    % rotation invariant 
    pixel_sum = sum(sum(image~=0));
    C = zeros(2,pixel_sum);
    count = 1;
    for j=1:size(image,1)
        for z=1:size(image,2)
            if(image(j,z)~=0)
               C(1,count) = z;
               C(2,count) = j;
               count = count+1;
            end
        end
    end
    
    % find the center of mass of the signature
    u = (1/pixel_sum)*sum(C(1,:));
    v = (1/pixel_sum)*sum(C(2,:));
    
    % the second order moments 
    u2 = (1/pixel_sum)*sum((C(1,:)-u).^2);
    v2 = (1/pixel_sum)*sum((C(2,:)-v).^2);
    
    I = [u2 u*v;u*v v2];
    
    % eigenvector - rotation angle 
    t = trace(I);
    d = det(I);
    eig1 = t*0.5 + sqrt(t*t*0.25 - d);
    angle = atan2(I(2,1), eig1 - I(2,2)) * 180 / pi;
    
    % rotation normalization
    image = imrotate(image, angle, 'bilinear');  
    [~,y] = size(image);
%     image = imresize(image,450/y);
    img_rot = image>0 == 1;


end

