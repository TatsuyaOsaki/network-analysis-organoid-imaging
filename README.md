# Network-analysis-organoid-imaging
# Matlab and R code for Osaki et al. Nature Communication (2025)

Repository for the code that was used to process and analyze data collected for 
"Early differential impact of MeCP2 mutations on functional networks in Rett syndrome patient-derived human cortical organoids", Osaki et al. Nature Communications (2026)

---

#### Calcium imaging signal processing and network analysis, 

*   **Image Analysis Preprocessing**
     *   **Calcium Imaging Data Processing**: Although "Suite2p" (a Python package) was used for initial processing of Ca2+ imaging data to identify neurons and regions of interest (ROIs), the subsequent calculation of **correlation matrices** using Pearson's pairwise correlation was performed in MATLAB. This MATLAB code could also be part of the GitHub repository.
     *   Pairwise correlation coefficient
To determine the functional connectivity between two individual neurons x and y, Pearson's pairwise correlation coefficients r_xy were calculated after shifting to zero mean based on the following formula:

*   **Small worled propensity**
     *   To quantify the extent to which a network displays small-world structure, we defined the small-world propensity.
#### bulkRNAseq
* 50M paired-end configuration and read-data were mapped to human reference genome GRCh37/hg19 or exosome sequenced genome of its cells. Mapped reads were quantified using featureCount. Differential expression was calculated by edgeR package in R, and used to determine significantly altered genes (adjusted p-value < 0.01).
* Single sample GSEAs were performed with escape R package (1.12.0) with Hallmark gene sets from MSigDB (https://www.gsea-msigdb.org/gsea/msigdb/). Pseudo-bulk RNAseq was performed by FindMarkers with sub-cluster and statistical significance was calculated by edgeR package (4.0.14) with Wilcoxon rank-sum test and visualized as a volcano plot. FDR was adjusted using the Benjamini-Hochberg method. Pseudo-trajectory was performed with the Monocle 3 package (1. 3. 4). To further characterize these clusters, bulk hallmark pathway analysis was carried out using the ClusterProfiler R package (4.10.1) and enricher with Hallmark gene sets and gene ontology gene sets from MSigDB.
  
#### scRNAseq
 ## Seurat
*   Raw sequencing reads were processed using the 10x Genomics CellRanger bioinformatics pipeline v7.2. Cell ranger count matrices of four conditions (isogenic control/ MeCP2[R306C] organoid and isogenic control/ MeCP2[V247X] organoid) were integrated as Seurat objects in Seurat 5 (5.0.1) and Seurat wrapper (0.3.4) in R (4.3.2). Low-quality cells and doublets were removed from the following downstream analysis according to the number of genes (less than 500 and more than 7000) and mitochondria percentage (less than 20%). Combined count matrices were normalized and scaled and integrated with CCA algorithm and centered gene-wise, and then underwent dimensionality reduction using principal component analysis (PCA). After visual inspection of the PCA elbow plot, the top 12 PCs were chosen for further analysis. Clustering was performed on the PCs using the shared nearest neighbor algorithm in Seurat to obtain a UMAP plot. Clusters were identified by Louvain algorithm with multilevel refinement performed in Seurat. Unique cluster genes were identified using FindAllMarkers using the Wilcoxon rank-sum test without thresholds. 
 ## CellChatDB
 * Ligand-receptor interaction analysis at the single cell level was performed using the CellChat R package (2.1.2) 
 ## NeuronChatDB
  * NeuronChat R package. MicroRNA target predictions were performed based on miRPathDB (https://mpd.bioinf.uni-sb.de/). 
 
#### EEG data analysis

*   **DEG**:
    

---


```
Tatsuya Osaki1, 2*, Chloe Delepine1, Yuma Osako1, Devorah Kranz3, 4, April Levin3, Charles Nelson3, 4, 5, Michela Fagiolini3, 6, 7, Mriganka Sur1, 8*
Affiliations
1. Picower Institute for Learning and Memory, Massachusetts Institute of Technology, Cambridge, MA 02139, USA
2. Whitehead Institute for Biomedical Research, Massachusetts Institute of Technology, Cambridge, MA 02139, USA 
3. Division of Developmental Medicine, Boston Children's Hospital, Boston, MA 02445, USA
4. Department of Pediatrics, Harvard Medical School, Cambridge, MA 02139, USA
5. Graduate School of Education, Harvard University, Boston, MA 02138
6. Department of Neurology, Harvard Medical School, Boston, MA 02115, USA
7. F.M. Kirby Neurobiology Center, Boston Children's Hospital, Boston, MA 02445, USA
8. Department of Brain and Cognitive Sciences, Massachusetts Institute of Technology, Cambridge, MA 02139, USA

Corresponding authors: * Tatsuya Osaki osaki@mit.edu, Mriganka Sur msur@mit.edu
```
