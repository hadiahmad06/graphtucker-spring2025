

scriptDir = fileparts(mfilename('fullpath'));

% Move one level up (parent directory)
parentDir = fileparts(scriptDir);

addpath(fullfile(parentDir, 'GT_utils/'))
processed_data_path = fullfile(parentDir, 'processed_data/');
data_name = 'CustomData';
filepath = [processed_data_path, data_name, '.mat'];
load(filepath)

% convert data to sparse tensor for 
V = sptensor([V.x_aligned_coords V.y_aligned_coords V.variable], V.value, ...
    [double(X) double(Y) double(Z)]);

% this save the sparse tensor
savename = [processed_data_path, data_name, '_tensor.mat'];
save(filepath, 'V');