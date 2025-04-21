# GraphTucker Spatial Analysis in Colorectal Cancer

This project applies [GraphTucker](https://github.com/kuanglab/GraphTucker), a graph-guided tensor decomposition method, to analyze spatial transcriptomics data from human colorectal cancer tissue. The objective is to uncover immune-related spatial gene expression patterns that may indicate tumor-immune interactions, therapy resistance, or early detection markers.

---

## Motivation

Colorectal cancer is one of the most common and deadly cancers worldwide. Understanding its tumor microenvironment is critical to improving treatment outcomes. Spatial transcriptomics enables the measurement of gene expression while preserving spatial context, revealing **what** genes are expressed and **where** they are located in tissue.

However, this data is often:
- High-dimensional
- Noisy
- Containing large gaps (missing values)

Traditional methods (like NMF) struggle to extract meaningful spatial structures.  
**GraphTucker** overcomes this by leveraging:
- **Spatial proximity**
- **Gene-gene relationships** (via protein-protein interaction graphs)

---

## Methodology

We used the Human Colorectal Cancer: Targeted Gene Signature Panel from **10x Genomics**. The pipeline includes:

1. **Data Preprocessing**
   - Remove low UMI count genes
   - Log transform expression values
   - Convert data to 3D tensor: `(x, y, gene)`
   - Adjust Visium layout to square grid by shifting rows
   - Construct composite graph:
     - Chain graphs for spatial `x` and `y`
     - PPI network from BioGRID for gene graph
     - Combined into a higher-order graph

2. **Decomposition with GraphTucker**
   - Run original MATLAB implementation (Kuang Lab)
   - Extract spatial components and gene factors

3. **Comparison with Baseline**
   - Run NMF using MATLAB’s `nnmf()` as baseline

4. **Analysis**
   - Visualize spatial components
   - Identify components enriched in immune-related genes
   - Cross-reference with OMIM, IHC, and literature

---

## Team Members & Roles

- **Naima Ali**  
  *Data pre-processing, Spatial component visualization and selection*

- **Raiza Soares**  
  *Data pre-processing, Spatial component visualization and selection*

- **Hadi Ahmad**  
  *GraphTucker incorporation and execution*

- **Bruce Nyakundi**  
  *Evaluation using Non-negative Matrix Factorization (NMF)*

- **All Members**  
  *Analysis of spatial components*

---

## Project Timeline

- **Iteration 1 (by April 30, 2025):**
  - Complete data cleaning and preprocessing
  - Run GraphTucker
  - Generate and save spatial components

- **Iteration 2 (by May 9, 2025):**
  - Perform biological analysis of components
  - Identify immune-involved regions and genes
  - Explore links to immune checkpoint inhibitor (ICI) response and chemoresistance

---

## Analysis of Spatial Components

After decomposition, we examine the spatial components to:

- **Visualize spatial activity** across the tissue for each component
- **Identify genes driving each component** (from `U3`)
- **Interpret biology** of gene sets: immune activity, inflammation, or known colorectal cancer roles
- **Compare to NMF baseline** for qualitative differences
- **Link components to biological hypotheses**: tumor infiltration, evasion, or prognosis

---

## 🛠 Setup Instructions

```bash
# Clone repo with submodule
git clone --recurse-submodules https://github.com/YOUR_USERNAME/graph-tucker-project.git
cd graph-tucker-project

# Set up Python environment
conda env create -f environment.yml
conda activate graphtucker-env

# Preprocess data
python scripts/preprocess.py

# Run GraphTucker (in MATLAB)
# Open notebooks/02_run_graphtucker.mlx