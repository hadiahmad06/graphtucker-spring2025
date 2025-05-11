clear all;clc

dataset = 'CustomData'; % name of data being used
data_path = ['../data/', dataset, '/']; % path to where spatial gene expression data is located
utils_path = '../GT_utils/';
res_path = ['../res/', dataset, '/'];
dst_path = ['../vis/', dataset, '/']; % path to where spatial component visualizations should be saved to
addpath(utils_path) % add path so util files can be found

% set to tested rank and lambda
rank_list = [30 30 20];
lambda = 1;

% load GraphTucker components.
% this script loads an example set of GraphTucker components run on
% MOSTA_9.5 with rank=(64,64,64), lambda=0.1 with 5000 iterations, denoted 
% by EXAMPLE.
% Change the path variables to load a different set of results.
rank_str = [num2str(rank_list(1)), '-', num2str(rank_list(2)), '-', num2str(rank_list(3))];
load([res_path, 'GT_', dataset, '_rank=', rank_str ,'_lambda=', num2str(lambda) ,'.mat']);

% permute core tensor for n-mode multiplication
G = permute(G, [3 2 1]);

% construct spatial component tensor X
% X is of size (n_x, n_y, r_g)
X = ttm(G, {A_set{1}{2} A_set{1}{1}}, [1 2]);

A_x = A_set{1}{2};
A_y = A_set{1}{1};

% need to load list of valid spots to distinguish from background spots
% for better visualization
load(['../processed_data/', dataset, '/', dataset, '_val_subs.mat']);
val_subs = [T_subs(:,1), T_subs(:,2)];
val_subs = unique(val_subs, 'rows');
bg_mat = zeros(size(A_x,1), size(A_y,1));
val_subs = sub2ind(size(bg_mat), val_subs(:,2), val_subs(:,1));
bg_mat(val_subs) = 1;

% loop through all spatial components
for i=1:rank_list(3)
    disp(['spatial component: ', num2str(i)])

    % create distinct folders depending on parameters to avoid clutter
    foldername = [dst_path, 'rank=', rank_str , '/'];
    if ~exist(foldername, 'dir')
       mkdir(foldername)
    end
    lam_foldername = [foldername, 'lambda=', num2str(lambda) , '/'];
    if ~exist(lam_foldername, 'dir')
       mkdir(lam_foldername)
    end
    savefolder = lam_foldername;
    
    % grab i-th spatial component
    X_slice = X.data(:,:,i);
    img_data = X_slice;
    
    figure
    % set background spots to nan for visualization purposes
    img_data(bg_mat == 0) = nan;
    h = imagesc(img_data);
    set(h, 'AlphaData', ~isnan(img_data));

    savepath = [savefolder,'/g_comp=', num2str(i), '.png'];
    axis image off
    saveas(gcf, savepath);
    clf
end
close all

% Define component groups to merge
merged = {[1,16,20], [3,12,18], [2,11,19], [8,14,15], [5,10,17], [6,9,13]}; % Example groups of components to merge

% Create merged component visualizations
for group_idx = 1:length(merged)
    current_group = merged{group_idx};
    
    % Initialize merged image
    merged_img = zeros(size(A_x,1), size(A_y,1));
    
    % Sum the components in the group
    for comp_idx = 1:length(current_group)
        comp_num = current_group(comp_idx);
        X_slice = X.data(:,:,comp_num);
        merged_img = merged_img + X_slice;
    end
    
    % Create visualization
    figure
    img_data = merged_img;
    img_data(bg_mat == 0) = nan;
    h = imagesc(img_data);
    set(h, 'AlphaData', ~isnan(img_data));
    
    % Create filename with component numbers
    comp_str = sprintf('_%d', current_group);
    comp_str = comp_str(2:end); % Remove leading underscore
    savepath = [savefolder, '/merged_components_', comp_str, '.png'];
    
    axis image off
    saveas(gcf, savepath);
    clf
end
close all