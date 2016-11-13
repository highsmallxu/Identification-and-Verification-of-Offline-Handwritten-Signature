% Signature verification
% Author: X.GAO

clear;clc;
addpath(genpath('prtools'));

% similarity measurement - same writer
writer_no = 10;
s_00 = 0;
s_11 = 0;
s_10 = 0;
s_01 = 0;
results = [];
load GSC_dutch_data.mat
load GSC_chinese_data.mat
for i=1:writer_no
    writer_sample = GSC_chinese_data((i-1)*24+1:i*24,:);
    for j=1:size(writer_sample,1)-1
        query_a = writer_sample(j,:);
        for z=j+1:size(writer_sample,1)
            query_b = writer_sample(z,:);            
            for m=1:length(query_a)              
                % s_00
                if query_a(m)==0 && query_b(m)==0
                    s_00 = s_00 + 1;
                end
                
                % s_11
                if query_a(m)==1 && query_b(m)==1
                    s_11 = s_11 + 1;
                end  
                
                % s_01
                if query_a(m)==0 && query_b(m)==1
                    s_01 = s_01 + 1;
                end
                
                % s_10
                if query_a(m)==1 && query_b(m)==0
                    s_10 = s_10 + 1;
                end               
            end            
            % result 
            result = (s_11*s_00-s_10*s_01)/((s_10+s_11)*(s_01+s_00)*(s_11+s_01)*(s_00+s_10))^0.5;
            results = [results;result];
        end
    end
end
mean_same = mean(results);
var_same = var(results);



%% read files
sample_each_class = 4;
path = dir('data/*');
[image_list,writer_no] = read_files_ver(path,sample_each_class);

%% forgeries GSC
% pre-processing 
train_list = image_list;
GSC_ver_data = [];

for id=1:length(train_list)
image = imread(train_list{id});
    
% grayscale + fix size + binary
[img_bin] = pre_binary(image);
% imshow(img_bin);

% rotate invariant
image = img_bin;
[img_rot] = pre_rotate(image);
% imshow(img_rot);

% bounding box
image = img_rot;
[img_crop] = pre_box(image);
% imshow(img_crop);

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
GSC_ver_data = [GSC_ver_data;GSC];

fprintf('the verification system is processing %d image\n',id)
end

%% similarity measurement - different writer
load GSC_dutch_data.mat
load GSC_chinese_data.mat
load GSC_fake_chinese_data.mat
load GSC_fake_dutch_data.mat
s_00 = 0;
s_11 = 0;
s_10 = 0;
s_01 = 0;
results_dif =[];
for i=1:writer_no
    true_sample = GSC_dutch_data((i-1)*24+1,:);
    fake_samples = GSC_fake_dutch_data((i-1)*4+1:i*4,:);
    for j=1:size(fake_samples,1)
        query = fake_samples(j,:);
        for m=1:length(query)              
            % s_00
            if query(m)==0 && true_sample(m)==0
                s_00 = s_00 + 1;
            end
                
             % s_11
             if query(m)==1 && true_sample(m)==1
                 s_11 = s_11 + 1;
             end
             
             % s_01
             if query(m)==0 && true_sample(m)==1
                 s_01 = s_01 + 1;
             end
             
             % s_10
             if query(m)==1 && true_sample(m)==0
                 s_10 = s_10 + 1;
             end
        end
        
        % result
        result = (s_11*s_00-s_10*s_01)/((s_10+s_11)*(s_01+s_00)*(s_11+s_01)*(s_00+s_10))^0.5;
        results_dif = [results_dif;result];
    end
end
mean_dif = mean(results_dif);
var_dif = var(results_dif);

%% test
temp1 = results>=mean_same - (var_same).^(0.5);
no_same = sum(temp1);

temp2 = results_dif<mean_same - (var_same).^(0.5);
no_diff = sum(temp2);

acc = (no_same + no_diff)/(length(temp1)+length(temp2));

