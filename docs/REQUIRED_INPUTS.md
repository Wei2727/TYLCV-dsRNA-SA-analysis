# Required analysis inputs (not included)

This repository contains analysis code and documentation only. The listed external data files are required for at least some calculations or figures. For privacy and data-management reasons, these inputs must be obtained and staged **outside this repository**, unless explicit sharing approval and curation are completed.

1. `rnaseq/jupyter/GO_profiling.ipynb`: nine exported g:Profiler intersection CSV files within `GOprofiler/`, plus the gene-list and enrichment settings used in the web analysis.
2. `rnaseq/jupyter/SA_RNAi_defence_heatmap.ipynb` and `rnaseq/jupyter/upset_overview.ipynb`: five annotated differential-expression tables within `python_sorted_result_fromDeseq2/` (SA, NSC, NSC+SA, virus-specific dsRNA and virus-specific dsRNA+SA against Mock). The separately performed gene annotation/join step is not supplied.
3. `viral_genome/TY_Nucleotide_composition.ipynb`: `bamCoverage_BWA215.bedgraph`, `ivar_variant_BWA215.tabular`, `BWA215.pileup` and `NC_004005.gff3` as appropriate to the plotted branch. Mapping/consensus scripts and source inputs are not included.
4. `pvx_gfp/ilastik.ipynb`: ilastik-exported `.h5` segmentations with an `exported_data` dataset and classification IDs 1 background, 2 leaf and 3 GFP (verify against the original ilastik project).
5. `statistics/statistics_disease_scale.ipynb`: the scores are encoded in the notebook. Verify experimental and biological-replicate scope before interpreting or reusing the results.
6. HPC/R scripts: 18 samples of paired FASTQs, SL4.0 genome FASTA, ITAG4.1 GTF, processed BAMs, featureCounts table and `counts/sample_info.csv` with `Sample` and `Condition` columns.

## Working directory convention

**No real filesystem paths are stored in the repository.** For HPC Slurm jobs, set the required environment variables in a private local shell (`WORKDIR`, `IN_DIR`, `OUT_ROOT`, or `PROJECT_ROOT`; see `HPC_CONFIGURATION.md`). For the R scripts, set `PROJECT_DIR`. The notebook paths are relative to the Jupyter working directory. Do not commit a personal directory layout or private exported results.

This repository does not independently guarantee end-to-end computational reproducibility.
