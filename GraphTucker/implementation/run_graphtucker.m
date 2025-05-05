clear all; clc;

% Add necessary paths
addpath('../GT_utils');
addpath('..');  % Add path to GraphTucker.m

% Set dataset name
dataset_name = 'BRCA1';  % Change this to use different datasets

% Set paths
processed_data_path = ['../processed_data/', dataset_name, '/'];
res_path = ['../res/', dataset_name, '/'];

% Create results directory if it doesn't exist
if ~exist(res_path, 'dir')
    mkdir(res_path);
end

% Load processed data
try
    load([processed_data_path, dataset_name, '_tensor.mat']);  % Loads V
    load([processed_data_path, 'HSA_PPI.mat']);  % Loads HSA_BIOGRID and HSA_UNIQ_BIOGRID_GENE
catch e
    error('Error loading data files: %s', e.message);
end

% Verify tensor format
if ~exist('V', 'var')
    error('Tensor V not found in %s_tensor.mat', dataset_name);
end

% Set GraphTucker parameters
opts.stopcrit = 10^-4;  % stopping criteria for convergence
opts.maxiters = 1000;   % maximum iterations
opts.mode = 1;          % non-sparse tensor mode
opts.loss_iters = 50;   % calculate loss every 50 iterations

% Set decomposition ranks for CustomData
tucker_rank = [20, 20, 15];  % [x_rank, y_rank, gene_rank]
opts.rank_g = tucker_rank(3);
opts.rank_set = tucker_rank(1:2);
rank_str = [num2str(opts.rank_set(1)), '-', num2str(opts.rank_set(2)), '-', num2str(opts.rank_g)];

% Set graph regularization parameter
lambda = 0.5;  % adjusted for CustomData
opts.lambda = lambda;

% Display tensor information
disp(['Spatial gene expression tensor size: ', num2str(size(V))]);
disp(['Density: ', num2str(length(V.vals) / prod(size(V)))]);

% Create mask tensor (all ones for no cross-validation)
M = tenones(size(V));

% Permute tensors for GraphTucker input
T = permute(V, [3 1 2]);
T_set = {T};

% Build spatial graphs
n = [size(V,1), size(V,2), size(V,3)];
W = cell(3,1);
for netid = 1:2 
    W{netid} = diag(ones(n(netid)-1,1),-1) + diag(ones(n(netid)-1,1),1);
end
W_set = {{W{1}, W{2}}};

% Build PPI network
if ~exist('HSA_BIOGRID', 'var')
    error('HSA_BIOGRID not found in HSA_PPI.mat');
end
W{3} = HSA_BIOGRID;
W_g = W{3};

% Permute mask tensor to match T
M = permute(M, [3 1 2]);
M_set = {M};

% Store original tensor for loss calculation
T_perm = permute(T, [3 1 2]);

% Run GraphTucker
try
    tic;
    [A_set, A_g, G, train_loss] = GraphTucker(T_set, M_set, W_set, W_g, T_perm, opts);
    runtime = toc;
catch e
    error('Error in GraphTucker: %s', e.message);
end

% Display results
disp(['Time taken: ', num2str(runtime), ' seconds']);
disp(['Final training loss: ', num2str(train_loss(end))]);

% Save results
save_name = [res_path, 'GT_', dataset_name, '_rank=', rank_str, '_lambda=', num2str(lambda), '.mat'];
save(save_name, 'A_set', 'A_g', 'G', 'lambda', 'train_loss', '-v7.3');

disp(['Results saved to: ', save_name]); 