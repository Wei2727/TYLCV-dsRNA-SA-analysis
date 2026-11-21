# Run the HPC/R scripts without exposing local paths

The published Slurm script sources use **environment variables** rather than storing home, scratch, group or account paths. Configure the variables in your own private submission environment. Never commit your local shell profile, submission history, cluster account name, or the actual values of these variables.

| Script | Variables to set | Intended inputs |
| --- | --- | --- |
| `01_merge_lanes.sbatch` | `WORKDIR` | Directory containing lane-specific FASTQ files |
| `02_cutadapt_fastp_fastqc.sbatch` | `IN_DIR`, `OUT_ROOT` | Merged FASTQ folder; processed-read output folder |
| `03_build_hisat2_index.sbatch` | Optional `WORKDIR`; otherwise current directory | SL4.0 FASTA and ITAG4.1 GTF in working directory |
| `04_hisat2_alignment.sbatch` | `PROJECT_ROOT`; optional `WORKDIR`, `READDIR` overrides | Genome index directory and fastp output directory |
| `05_featureCounts_Rsubread.R` | `PROJECT_DIR` | Sorted BAM directory, GTF and counts outputs |
| `06_DESeq2_VST_PCA_DEG.R` | `PROJECT_DIR` | Counts table and metadata CSV |

On a Slurm cluster, use `sbatch` with your site's required account, partition and quality-of-service flags (if needed). Those settings were intentionally omitted from the publication copy, since they are **local scheduling metadata rather than analysis parameters**.

**Example command shape (replace bracketed values locally, do not paste actual paths into GitHub):**

```bash
# Submit from your private input working directory on a login node.
# Only run the computational tasks on allocated Slurm compute nodes.
export WORKDIR="<PRIVATE_FASTQ_DIRECTORY>"
sbatch --account="<YOUR_PROJECT_ACCOUNT>" --partition="<YOUR_PARTITION>"   --export=ALL rnaseq/bunya/01_merge_lanes.sbatch
```

For RStudio, set `PROJECT_DIR` privately in the R session or shell before sourcing the script:

```r
Sys.setenv(PROJECT_DIR = "<PRIVATE_ANALYSIS_DIRECTORY>")
source("rnaseq/bunya/05_featureCounts_Rsubread.R")
```

**Important:** The example above is not an executed/tested command. Site-dependent options, accessible paths, module versions, pre-existing directories, limits, and sample-list preparation must be checked. The array sample-list construction was revised to avoid dependence on task 1; this is a prospective robustness fix and was not run on Bunya. Keep the input directory unchanged during the array run. Do not run computationally heavy commands on an HPC login node.
