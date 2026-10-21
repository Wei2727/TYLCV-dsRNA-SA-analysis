# Required external inputs, not included

The main GitHub candidate ZIP contains code, not the experimental data files. To reproduce figures, download or obtain the following inputs and work in the correct directory. The optional input pack supplied alongside this candidate provides **only** the first two groups, and can be kept local rather than published.

1. For `rnaseq/jupyter/GO_profiling.ipynb`, all nine g:Profiler `GOprofiler/*/gProfiler_09022026_intersections_*.csv` exports (from 9 February 2026) and the annotated DEG CSVs below, plus metadata for g:Profiler input lists/background/correction.
2. For `rnaseq/jupyter/SA_RNAi_defence_heatmap.ipynb` and the UpSet notebook, five annotated tables in `python_sorted_result_fromDeseq2/`: `SA_vs_Mock_DE_annotated.csv`, `NSC_vs_Mock_DE_annotated.csv`, `NSCSA_vs_Mock_DE_annotated.csv`, `Spec_vs_Mock_DE_annotated.csv`, `SpecSA_vs_Mock_DE_annotated.csv`. The annotated tables were prepared separately; their ID-to-annotation join step is **not** supplied.
3. For `viral_genome/TY_Nucleotide_composition.ipynb`, `bamCoverage_BWA215.bedgraph`, `ivar_variant_BWA215.tabular`, `BWA215.pileup`, `NC_004005.gff3` and source mapping reference/command provenance. The notebook's branches may not need every file in one run; see code.
4. For `pvx_gfp/ilastik.ipynb`, the exported `.h5` ilastik segmentation files with `exported_data` dataset and class assignments 1 background/2 leaf/3 GFP (to verify against `.ilp`).
5. For `statistics/statistics_disease_scale.ipynb`, manually entered ordinal disease-scores are hard-coded; verify replicate identity and manuscript figure before release.
6. For Bunya/RStudio scripts, raw 18-sample paired FASTQ files, SL4.0 FASTA, ITAG4.1 GTF, alignment outputs, featureCounts table and `counts/sample_info.csv` are necessary for a full rerun. Original Bunya scratch outputs were cleaned. The saved script texts support documentation, not independent verification of prior execution.

Note: Most notebooks use `Path('.')` or relative `./GOprofiler/` and `./python_sorted_result_fromDeseq2/` paths. To rerun, either launch Jupyter at a working directory containing those sibling folders or update the notebook paths intentionally. This lean repository doesn't make such path changes to historic code.
