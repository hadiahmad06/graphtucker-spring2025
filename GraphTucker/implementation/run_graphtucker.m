clear all; clc;

% Add necessary paths
addpath('../GT_utils');
addpath('../processing');

% Set paths
data_path = '../data/';
processed_data_path = '../processed_data/';
res_path = '../res/';

% Create results directory if it doesn't exist
if ~exist(res_path, 'dir')
    mkdir(res_path);
end

% Set GraphTucker parameters
opts.stopcrit = 10^-4;  % stopping criteria for convergence
opts.maxiters = 1000;   % maximum iterations
opts.mode = 1;          % non-sparse tensor mode
opts.loss_iters = 50;   % calculate loss every 50 iterations

% Set decomposition ranks for CustomData
% Adjust these ranks based on your data dimensions
tucker_rank = [20, 20, 15];  % [x_rank, y_rank, gene_rank]
opts.rank_g = tucker_rank(3);
opts.rank_set = tucker_rank(1:2);
rank_str = [num2str(opts.rank_set(1)), '-', num2str(opts.rank_set(2)), '-', num2str(opts.rank_g)];

% Set graph regularization parameter
lambda = 0.5;  % adjusted for CustomData
opts.lambda = lambda;

% Load and prepare data
[T, W] = data_prep_alt('CustomData', data_path);

% Display tensor information
disp(['Spatial gene expression tensor size: ', num2str(size(T))]);
disp(['Density: ', num2str(length(T.vals) / prod(size(T)))]);

% Create mask tensor (all ones for no cross-validation)
M = tenones(size(T));

% Permute tensors for GraphTucker input
T = permute(T, [3 1 2]);
T_set = {T};
W_set = {{W{1}, W{2}}};
W_g = W{3};

% Permute mask tensor to match T
M = permute(M, [3 1 2]);
M_set = {M};

% Store original tensor for loss calculation
T_perm = permute(T, [3 1 2]);

% Run GraphTucker
tic;
[A_set, A_g, G, train_loss] = GraphTucker(T_set, M_set, W_set, W_g, T_perm, opts);
runtime = toc;

% Display results
disp(['Time taken: ', num2str(runtime), ' seconds']);
disp(['Final training loss: ', num2str(train_loss(end))]);

% Save results
save_name = [res_path, 'GT_CustomData_rank=', rank_str, '_lambda=', num2str(lambda), '.mat'];
save(save_name, 'A_set', 'A_g', 'G', 'lambda', 'train_loss', '-v7.3');

disp(['Results saved to: ', save_name]); 