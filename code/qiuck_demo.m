% Quick demo
% Author: X.GAO
% codes are original
% Several results have been saved as .mat

clear;
clc;
addpath(genpath('prtools'));

%% Identification model quick demo
load GSC_dutch_data.mat
load GSC_dutch_label.mat
load GSC_chinese_data.mat
load GSC_chinese_label.mat

X_d = dataset(GSC_dutch_data,GSC_dutch_label);
error_d = crossval(X_d, knnc([], 1), 10);
acc_d = 1-error_d;
fprintf('AUC of dutch dataset is %d\n',acc_d);

X_c = dataset(GSC_chinese_data,GSC_chinese_label);
error_c = crossval(X_c, knnc([], 1), 10);
acc_c = 1-error_c;
fprintf('AUC of chinese dataset is %d\n', acc_c);


%% Verification mode quick demo
load GSC_fake_chinese_data.mat
load GSC_fake_dutch_data.mat
load within_chinese.mat
load within_dutch.mat
load between_chinese.mat
load between_dutch.mat

% chinese
mean_same = mean(results_chinese);
var_same = var(results_chinese);

mean_dif = mean(results_chinese_dif);
var_dif = var(results_chinese_dif);

temp1 = results_chinese>=mean_same - (var_same).^(0.5);
no_same = sum(temp1);

temp2 = results_chinese_dif<mean_same - (var_same).^(0.5);
no_diff = sum(temp2);

acc = (no_same + no_diff)/(length(temp1)+length(temp2));
fprintf('AUC of chinese verification system is %d\n',acc);

% dutch
mean_same = mean(results_dutch);
var_same = var(results_dutch);

mean_dif = mean(results_dutch_dif);
var_dif = var(results_dutch_dif);

temp1 = results_dutch>=mean_same - (var_same).^(0.5);
no_same = sum(temp1);

temp2 = results_dutch_dif<mean_same - (var_same).^(0.5);
no_diff = sum(temp2);

acc = (no_same + no_diff)/(length(temp1)+length(temp2));
fprintf('AUC of dutch verification system is %d\n',acc);

