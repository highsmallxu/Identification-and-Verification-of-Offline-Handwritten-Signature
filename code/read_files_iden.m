% Author: X.GAO
function [image_list,writer_no] = read_files_iden(path,sample_each_class)

image_list = cell(0);
for i=1:length(path)
    if path(i).name(1)~='.'
        images = dir(['data/' 'identification/dutch' '/*.PNG']); % 'identification/chinese'
        for j=1:length(images)
            image_list{j} = ['data/' 'identification/dutch' '/' images(j).name]; %'identification/chinese'
        end
    end
end
writer_no =  round(length(image_list)/sample_each_class);

end

