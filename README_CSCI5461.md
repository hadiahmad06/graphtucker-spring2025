For this project, we used MATLAB R2024a to run GraphTucker.

The 'Human Colorectal Cancer' spatial and feature_bc_matrix data obtained from the 10x Genomics website will be located under the folder data\CustomData.
To run GraphTucker for this dataset, use GraphTucker_tutorial2.m. The script is already modified to use CustomData as input. Modify rank and iteration values as needed.
This tutorial code will use the PPI network under processed_data\CustomData that was prepared from the latest BioGrid release.

After running GraphTucker, you can use the following analysis scripts:
analysis\spatial_component_clustering_Custom.m : Perform K-Means clustering on GraphTucker core tensor and saves clustering results under vis\CustomData\clustering
analysis\visualize_GraphTucker_spatial_components.m : View individual spatial components and saves individual images for each region under vis\CustomData\rank=30-30-20\lambda=1
analysis/visualize_GraphTucker_merged_spatial_components.m: View spatial components grouped together. Images are saved under vis\CustomData\rank=30-30-20\lambda=1

Please refer to the original README under the GraphTucker project for additional info: https://github.com/kuanglab/GraphTucker/blob/main/README.md
