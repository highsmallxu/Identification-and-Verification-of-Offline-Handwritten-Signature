function [img_con] = concavity_map(img_patchs,img_gra_map)

% coarse pixel density feature
pixels_den = [];
den_th = 0;
for i=1:length(img_patchs)
    img_patch = img_patchs{i};
    pixels = sum(sum(img_patch));
    
    if pixels > den_th
        pixel_den = 1;
    else
        pixel_den = 0;
    end
    
    pixels_den = [pixels_den pixel_den];
end
pixels_den = pixels_den';

% large stroke feature
range = linspace(0,360,13);
strokes_fea = [];
for j=1:length(img_gra_map)
    
    img_patch = img_gra_map{j};
    temp = zeros(size(img_patch,1),size(img_patch,2));
    hor_no = 0;
    ver_no = 0;
    for m=2:size(img_patch,1)-1
        for n=2:size(img_patch,2)-1
            
            % Neighbours
            N0 = img_patch(m,n+1);
            N1 = img_patch(m-1,n+1);
            N2 = img_patch(m-1,n);
            N3 = img_patch(m-1,n-1);
            N4 = img_patch(m,n-1);
            N5 = img_patch(m+1,n-1);
            N6 = img_patch(m-1,n);
            N7 = img_patch(m+1,n+1);
            
            % rule 1
            if (range(3)<=N0 && N0<=range(6))...
                    && (range(1,3)<= N4 && N4<=range(1,6))
                temp(m,n) = 1;
                hor_no = hor_no + 1;
            end
            
             % rule 2
            if (range(9)<=N0 && N0<=range(11))...
                        && (range(9)<= N4 && N4<=range(11))
                temp(m,n) = 1;
                hor_no = hor_no + 1;
            end
 
             % rule 3
            if (range(6)<=N2 && N2<=range(8))...
                    && (range(6)<= N6 && N6<=range(8))
                temp(m,n) = 1;
                ver_no = ver_no + 1;
            end
             
             % rule 4
            if ((range(1)<N2 && N2<=range(2)) || (range(12)<=N2 && N2<=range(13)))...
                    && ((range(1)<N6 && N6<=range(2)) || (range(12)<=N6 && N6<=range(13)))
               temp(m,n) = 1;
               ver_no = ver_no + 1;
            end            
            
        end
    end

    dim = size(img_patch,1) * size(img_patch,2);
    hor_no = hor_no/dim;
    ver_no = ver_no/dim;
    hor_th = 0.01;
    ver_th = 0.01;
    if hor_no > hor_th
        hor = 1;
    else
        hor = 0;
    end
    
    if ver_no > ver_th
        ver = 1;
    else
        ver = 0;
    end
    stroke = [hor ver];
    strokes_fea = [strokes_fea;stroke];
end

% concavity feature
directions = linspace(0,360,9);
con_feas = [];
for z=1:length(img_patchs)
    img_patch = img_patchs{z};
    left = size(img_patch,1) * size(img_patch,2);
    right = left;
    up = left;
    down = left;
    hole = 0;
    for p=1:size(img_patch,1)
        for q=1:size(img_patch,2)
            
            % Left
            if sum(img_patch(p,1:q-1))==0
                left = left-1;
            end
            % Right
            if sum(img_patch(p,q+1:end))==0
                right = right-1;
            end
            % Up
            if sum(img_patch(1:p-1,q))==0
                up = up-1;
            end
            % Down
            if sum(img_patch(p+1:end,q))==0
                down = down-1;
            end
            % Hole
            if sum(img_patch(p,1:q-1))~=0 ...
                    && sum(img_patch(p,q+1:end))~=0 ...
                    && sum(img_patch(1:p-1,q))~=0 ...
                    && sum(img_patch(p+1:end,q))~=0
               hole = hole+1; 
            end
        end
    end
    con_fea = [left right up down hole];
    con_fea = con_fea/(size(img_patch,1)*size(img_patch,2));
    con_feas = [con_feas;con_fea]; 
end

udlr = con_feas(:,1:4);
hole = con_feas(:,5);
udlr_th = 0.4;
hole_th = 0;

udlr(udlr>=udlr_th) = 1;
udlr(udlr<udlr_th) = 0;
hole(hole>hole_th) = 1;
hole(hole<=hole_th) = 0;
con_feas = [udlr hole];

img_con = [pixels_den strokes_fea con_feas];
end

