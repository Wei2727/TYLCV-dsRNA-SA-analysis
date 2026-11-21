# Validation of revised release candidate

- Bash syntax check passed for all four Slurm scripts.
- Python syntax parsing passed for notebook code cells after excluding IPython magic/shell lines.
- The revised UpSet notebook's two code cells executed successfully in a temporary working directory using the five supplied annotated tables (non-interactive Matplotlib backend). All five up/down counts matched `data/DEG_summary.csv`. The figure was generated but not visually compared with the submitted manuscript figure.
- All eight annotated CSV files contain the same 20,353 unique original gene IDs, with unique annotated GeneIDs and the expected nine columns; no qualifying gene has absolute log2 fold change exactly 1. Original CSV bytes were preserved.
- Sample metadata checks: 18 unique sample IDs, six conditions with three samples each, 72 unique FASTQ filenames as recorded in the supplied NCBI submission exports. Actual FASTQ files were not inspected. The subsequently supplied count columns match the 18 metadata sample IDs exactly.
- No full DESeq2, Slurm, viral, GO, or image analysis was independently rerun.

## Count matrix and assignment summary

- The supplied matrix contains 34,688 unique gene IDs and 18 sample columns; all counts are non-negative integers with no missing values.
- All 18 sample IDs match the metadata; six conditions contain three samples each.
- Assignment summary sample names match the matrix columns after removing `.sorted.bam`; each matrix column sum equals the corresponding `Assigned` count.
- The DESeq2 prefilter `rowSums(counts(dds) >= 10) >= 2` retains 20,353 genes. The retained gene-ID set exactly matches each of the eight archived annotated result tables.
- These checks do not establish the identity of the historic fitted DESeq2 model or reproduce numerical log-fold changes or P values. No model was refitted in this revision.
