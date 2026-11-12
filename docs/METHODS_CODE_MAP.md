# Link between manuscript Methods and code

| Methods section | Source code / platform | Verification |
| --- | --- | --- |
| RCA sequencing read trimming/assembly and geNomad/CheckV | Galaxy Australia and NMDC EDGE (web services) | Excluded from code deposit by author choice; methods include tools, dates, versions. Settings/data availability documented separately. |
| TYLCV read mapping/consensus | Bowtie2, BWA-MEM2, SAMtools, iVar tools | Exact command scripts not provided in this deposit; `viral_genome/TY_Nucleotide_composition.ipynb` covers **plots/derived heterogeneity** only. Do not claim genome mapping is reproducible from this repo alone. |
| TYLCV nucleotide-frequency visualisation | `viral_genome/TY_Nucleotide_composition.ipynb` | **mpileup** branch: ACGT depth >= 100; second-most base >= 30%; 42% annotation label threshold only. **iVar** plotting branch has separate frequency thresholds. |
| RNA-seq merged lanes | `rnaseq/hpc/01_merge_lanes.sbatch` | L005+L006 concatenated FASTQ gzip streams, output read counts. |
| RNA-seq trimming/QC | `rnaseq/hpc/02_cutadapt_fastp_fastqc.sbatch` | Cutadapt -m 20; fastp 0.23.2, FastQC 0.11.9. Check historic Cutadapt version 4.2 reported in Methods vs unpinned module load. |
| HISAT2 SL4.0/ITAG4.1 index and mapping | `rnaseq/hpc/03_build_hisat2_index.sbatch`, `04_hisat2_alignment.sbatch` | HISAT2 2.2.1; `--rna-strandness RF --dta`; SAMtools sort/index. |
| featureCounts | `rnaseq/hpc/05_featureCounts_Rsubread.R` | exon, gene_id, paired-end, reverse stranded, both mates mapped, chimeras excluded, 18 expected BAMs. |
| DESeq2/DEGs/PCA | `rnaseq/deseq2/06_DESeq2_VST_PCA_DEG.R` | `~ Condition`, Mock reference, counts>=10 in 2 samples, padj<0.05, abs(log2FC)>=1, VST PCA top 500 variable genes. Code's clustering loops k=2..3, despite pasted header saying k=2..6. |
| GO enrichment | g:Profiler web server | Web analysis not run by script; exported results and gene lists kept outside lean code deposit. |
| GO/defence visualisation | `rnaseq/jupyter/GO_profiling.ipynb` and `SA_RNAi_defence_heatmap.ipynb` | Takes exported g:Profiler tables and 5 annotated DESeq2 result tables, not produced by the current DESeq2 R code alone. |
| DEG UpSet | `rnaseq/jupyter/upset_overview.ipynb` | Optional, verify manuscript actually contains this analysis; remove if unrelated. |
| PVX-GFP imaging quantification | ilastik v1.4.0 then `pvx_gfp/ilastik.ipynb` | HDF5 labels expected: 1=background, 2=leaf, 3=GFP; %GFP = GFP/(leaf+GFP)*100. No `.ilp` project included. |
| Disease-severity comparisons | `statistics/statistics_disease_scale.ipynb` | SciPy two-sided Mann–Whitney permutation with 10,000 resamples, seed 42; only 3 mock + 3 V1/C3dsR observations per timepoint in code. |
