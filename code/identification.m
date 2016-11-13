% Signature identification 
% Author: X.GAO
% codes are original 

clear;clc;
addpath(genpath('prtools'));

%% read files
sample_each_class = 24;
path = dir('data/*');
[image_list,writer_no] = read_files_iden(path,sample_each_class);

%% random choose training sets
sample_no = 24;
random_id = randi([1,sample_each_class],1,sample_no); % randomly choose three training samples from each class
count = 1;
train_list = cell(0);
for w=1:writer_no
    for n=1:sample_no
        train_list{count} = image_list{(w-1)*sample_each_class+random_id(n)};
        count = count + 1;
    end
end

%% pre-processing 

GSC_data = [];
GSC_label = [1*ones(sample_no,1);2*ones(sample_no,1);3*ones(sample_no,1);
             4*ones(sample_no,1);5*ones(sample_no,1);6*ones(sample_no,1);
             7*ones(sample_no,1);8*ones(sample_no,1);9*ones(sample_no,1);
             10*ones(sample_no,1)];
for id=1:length(train_list)
% image = imread(train_list{id});
image = imread(train_list{id});
    
% grayscale + fix size + binary
[img_bin] = pre_binary(image);
% imshow(img_bin); % visualize the binary image 

% rotate invariant
image = img_bin;
[img_rot] = pre_rotate(image);
% imshow(img_rot); % visualize the rotation invariant image 

% bounding box
image = img_rot;
[img_crop] = pre_box(image);
% imshow(img_crop); % visualize the cropped image 

% subdividing 4*4
image = img_crop;
[img_patchs] = pre_subdivid(image);

% preprocessing - visualization
% figure(1);
% for i=1:length(img_patchs)
%     subplot(4,4,i);
%     imshow(img_patchs{i});
% end

%% feature extraction

% gradient map
[img_gra,img_gra_map] = gradient_map(img_patchs);

% structural feature
[img_stru] = structural_map(img_gra_map);

% concavity feature
[img_con] = concavity_map(img_patchs,img_gra_map);

% feature vectors
GSC = [img_gra img_stru img_con];
GSC = reshape(GSC,[1,size(GSC,1)*size(GSC,2)]);

% GSC_data{id} = GSC;
GSC_data = [GSC_data;GSC];

fprintf('the identification system is processing %d image\n',id)
end

%% knn training & test - cross validation
X = dataset(GSC_data,GSC_label);
error = crossval(X, knnc([], 1), 10)







