% Author: X.GAO
function [img_stru] = structural_map(img_gra_map)

range = linspace(0,360,13);
img_stru = [];

for i=1:length(img_gra_map)
    img_patch = img_gra_map{i};
    img_stru_i = zeros(1,12);
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
                img_stru_i(1)=1;
            end
            
            % rule 2
            if (range(9)<=N0 && N0<=range(11))...
                        && (range(9)<= N4 && N4<=range(11))
                    img_stru_i(2)=1;
            end
            
            % rule 3
            if (range(6)<=N2 && N2<=range(8))...
                    && (range(6)<= N6 && N6<=range(8))
                img_stru_i(3)=1;
            end
            
            % rule 4
            if ((range(1)< N2 && N2<=range(2)) || (range(12)<=N2 && N2<=range(13)))...
                    && ((range(1)< N6 && N6<=range(2)) || (range(12)<=N6 && N6<=range(13)))
               img_stru_i(4)=1;
            end
            
            % rule 5
            if (range(5)<= N5 && N5<=range(7))... 
                    && (range(5)<= N1 && N1<=range(7))
                img_stru_i(5)=1;
            end
            
            % rule 6
            if (range(11)<= N5 && N5<=range(13))...
                    && (range(11)<= N1 && N1<=range(13)) 
                img_stru_i(6)=1;
            end
            
            % rule 7
            if (range(2)<= N3 && N3<=range(4))...
                    && (range(2) <= N7 && N7<=range(4))
                img_stru_i(7)=1;
            end
            
            % rule 8
            if (range(8)<= N3 && N3<=range(10))...
                    && (range(8) <= N7 && N7<=range(10))
                img_stru_i(8)=1;
            end
            
            % rule 9
            if (range(6)<= N2 && N2<=range(8))...
                    && (range(9)<= N0 && N0<=range(11))
                img_stru_i(9)=1;
            end
            
            % rule 10
            if (range(6)<= N6 && N6<=range(8))...
                    && (range(3)<= N0 && N0 <=range(5))
                img_stru_i(10)=1;
            end
            
            % rule 11
            if (range(9)<= N4 && N4<=range(11))...
                    && ((range(1)<= N2 && N2<=range(2)) || (range(12)<= N2 && N2<=range(13)))
                img_stru_i(11)=1;
            end
            
            % rule 12
            if ((range(1)< N6 && N6<=range(2)) || (range(12)<= N6 && N6<=range(13)))...
                    && (range(3)<= N4 && N4<=range(5))
                img_stru_i(12)=1;
            end
               
        end
    end
    
    img_stru = [img_stru;img_stru_i];
end
end


