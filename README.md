# TYLCV dsRNA and salicylic acid — manuscript analysis code

Analysis scripts, workflows and supporting datasets for the manuscript. The supplied workflow has not been independently reproduced end to end.

Custom analysis code for topical dsRNA and salicylic acid treatments in tomato (TYLCV) and *Nicotiana benthamiana* (PVX–GFP). Raw sequencing data are associated with [NCBI BioProject PRJNA1550481](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1550481); access is subject to the records' release status.

## Repository structure

| Location | Contents |
|---|---|
| `rnaseq/bunya/` | Lane merging, trimming and QC, HISAT2 indexing/alignment and featureCounts |
| `rnaseq/deseq2/` | DESeq2, QC, VST/PCA and five treatment-versus-Mock comparisons |
| `rnaseq/jupyter/` | GO and defence-gene visualisation, UpSet analysis |
| `python_sorted_result_fromDeseq2/` | Five original all-gene annotated DESeq2 CSV files, used by the notebooks |
| `GOprofiler/` | Nine original exported g:Profiler tables used by the notebooks |
| `counts/` | Original 18-sample featureCounts gene count matrix, assignment summary and DESeq2 sample metadata |
| `data/metadata/` | Sample-to-treatment and sequencing-file mapping reconstructed from the submitted NCBI tables; sample IDs checked against count columns |
| `data/additional_contrasts/` | Three other annotated DESeq2 comparisons; include in manuscript supplements if reported |
| `data/DEG_summary.csv` | DEG totals recomputed from supplied tables (not a rerun of DESeq2) |
| `viral_genome/`, `pvx_gfp/`, `statistics/` | Viral nucleotide plots, GFP quantification and disease-score analysis |
| `docs/` | Workflow, inputs, software versions, provenance and validation |

## Run the code

Run the RNA-seq plotting notebooks from the repository root so the relative paths resolve. Python dependencies are listed in `requirements.txt` (versions not reconstructed). R/HPC instructions: `docs/HPC_CONFIGURATION.md`, with historical reported versions and unresolved versions in `docs/SOFTWARE_VERSIONS.md`. The DESeq2 script reads `counts/tomato_ITAG4.1_featureCounts_Rsubread.tsv` and `counts/sample_info.csv`, both included. To run from the repository root in a suitable R environment:

```bash
PROJECT_DIR="$PWD" Rscript rnaseq/deseq2/06_DESeq2_VST_PCA_DEG.R
```

The script writes outputs under `counts/`; run it on a separate working copy if preserving the archive. The assignment summary is supplied for QC, not as model input. The count matrix contains 34,688 unique gene IDs; the code's filter (count >= 10 in at least two samples) retains exactly the 20,353 gene IDs found in all eight annotated result tables. Assigned count totals match the matrix column sums for all 18 samples. These are input-consistency checks, not a rerun of DESeq2.

 The original annotation-join code is unavailable. Additional contrast CSVs are retained as supplied, and their exact generating commands have not been recovered.

RCA read processing/assembly used Galaxy Australia and NMDC EDGE. Exact viral mapping and consensus command scripts are not included. The viral notebook includes alternative plotting branches; confirm the branch used for the final figure. The PVX notebook requires ilastik HDF5 segmentation exports. The manuscript's Prism analyses and source qPCR data are not included. See `docs/REQUIRED_INPUTS.md` for outstanding inputs.

## Statistical settings and data

DEGs are classified using adjusted P < 0.05 and absolute log2 fold change >= 1. The UpSet notebook was aligned to the DESeq2 script's inclusive threshold; no qualifying gene lies exactly at either boundary in the eight supplied annotated tables. The tables' numerical contents are unchanged. RNA-seq sampling is 6 h after the second foliar treatment, before TYLCV inoculation; do not confuse this experiment with PVX timing.

## Release and citation

Software creator metadata and reuse licensing must be confirmed by the rights holders before public release. No software license or DOI has been assigned in this package. Cite the approved version-specific Zenodo record once available. A GitHub repository link is provided for navigation: https://github.com/Wei2727/TYLCV-dsRNA-SA-analysis.

The scripts were compiled from saved text and notebooks; the original scientific workflow and manuscript figures have not been independently reproduced. See the change log and validation documentation for the scope of the checks.

See `docs/VALIDATION.md` for the limited checks completed, including a successful run of both UpSet code cells.
