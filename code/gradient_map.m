function [img_gra,img_gra_map] = gradient_map(img_patchs)

    sobel_x = [-1 0 1;-2 0 2;-1 0 1];
    sobel_y = [-1 -2 -1;0 0 0;1 2 1];
    
    img_gradient = [];
    img_gra_map = cell(0);
    for i=1:length(img_patchs)
        img = double(img_patchs{i});
        Gx = conv2(img,sobel_x,'same');
        Gy = conv2(img,sobel_y,'same');
        
        [Gmag,Gdir] = imgradient(Gx,Gy);  
        
        % gradient vector map - visualization
%         if i==5
%         figure;
%         for o=1:size(Gmag,1)
%             for p=1:size(Gmag,2)
%                 mag = Gmag(o,p);
%                 dir = Gdir(o,p);
%                 a = o;
%                 b = p;
%                 c = mag * cos(dir);
%                 d = mag * sin(dir);
%                 if mag~=0
%                 quiver(a,b,c,d,'color',[0 0 0]);
%                 hold on;
%                 end
%             end
%         end
%         end
%         camroll(-90);
        
        % range: 0-2pi
        temp = Gdir<0;
        Gdir(temp==1) = Gdir(temp==1) + 360;
        
        %img gradient map
        img_gra_map{i} = Gdir;  
        
        % histogram
        Gdir = Gdir(find(Gdir~=0)); 
        nbins = 12;
        binEdges = linspace(0,360,nbins+1);
        figure(1);
        h = histogram(Gdir,binEdges);      
        img_gradient = [img_gradient;h.Values]; 
    end
      
    % percentage    
    for j=1:length(img_patchs)
        row_sum = sum(img_gradient(j,:));
        for z=1:nbins
            if row_sum==0
                img_gra(j,z)=0;
            else
                img_gra(j,z)=img_gradient(j,z)/row_sum;
            end
        end     
    end
    
    % threshold - binary 
    gra_th = 1/nbins;
    img_gra(img_gra >= gra_th) = 1;
    img_gra(img_gra < gra_th) = 0;
end

