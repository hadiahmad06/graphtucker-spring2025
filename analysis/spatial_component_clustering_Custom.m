clear all
addpath('../GT_utils/')
rng('default')

vis_path = '../vis/CustomData'; % path to where images will be saved to

% check these variables to see if results will be loaded correctly
dataset = 'CustomData';
num_regions = 20;
rank_list = [30 30 num_regions];
rank_str = [num2str(rank_list(1)), '-', num2str(rank_list(2)), '-', num2str(rank_list(3))];
lambda = 1;

% load data
load(['../res/', dataset, '/GT_', dataset, '_rank=', rank_str ,'_lambda=', num2str(lambda) ,'.mat']);
G = permute(G, [3 2 1]); % permute core tensor for visualization
A_x = A_set{1}{2};
A_y = A_set{1}{1};
n = [size(A_x, 1), size(A_y, 1)];

% coloring for 20 regions
cmap = ["#1f77b4", "#aec7e8", "#ff7f0e", "#ffbb78", "#2ca02c", "#98df8a", "#d62728", ...
    "#ff9896", "#9467bd", "#c5b0d5", "#8c564b", "#c49c94", "#e377c2", "#f7b6d2", ...
    "#7f7f7f", "#c7c7c7", "#bcbd22", "#dbdb8d", "#17becf", "#9edae5"];
cmap = hex2rgb(cmap);

% construct spatial component tensor
X = ttm(G, {A_set{1}{2} A_set{1}{1}}, [1 2]); 

G_xy_mat = tenmat(X, 3, [1 2]); % compute spatial component tensor
G_xy = G_xy_mat.data;
G_xy = G_xy';

% Use indices from val_subs
load(['../processed_data/', dataset, '/', dataset, '_val_subs.mat']);
val_subs = [T_subs(:,1), T_subs(:,2)];
val_subs = unique(val_subs, 'rows');
bg_mat = zeros(size(A_x,1), size(A_y,1));
val_subs = sub2ind(size(bg_mat), val_subs(:,2), val_subs(:,1));
bg_mat(val_subs) = 1;

% load subs file which contains indices for valid spots
load(['../processed_data/', dataset, '/', dataset, '_val_indices.mat'])

% select non-background spots from spatial component tensor
val_idx = val_subs;
G_xy = G_xy(val_idx,:);
G_xy = normr(G_xy); % normalize

% run k-means with k=num_regions, 5 replicates
idx = kmeans(G_xy, num_regions, 'Replicates', 5);

vis = zeros([size(A_x, 1), size(A_y, 1)]);
vis(val_idx) = idx;

% adjust background of clusterings for better visualization
img_data = bg_mat;
img_data(val_subs) = idx; 
img_data(img_data == 0) = nan;

figure
colormap(cmap) 
h = imagesc(img_data);
set(h, 'AlphaData', ~isnan(img_data));
set(gcf, 'Position', [100, 100, 300, 300]);
axis image off

% save clustering results
savepath = ['../vis/', dataset, '/clustering/clustered_spatial_components.png'];
saveas(gcf, savepath);       

close all