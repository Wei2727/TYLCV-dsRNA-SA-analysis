# Tomato RNA-seq: exon-level gene counts with Rsubread featureCounts
# Transcribed from user-provided R code (2026-10-21).
# Quotation mark and pasted Markdown escaping have been normalised.
# The original Bunya .R file, successful execution, and package version
# have NOT been independently verified. Compare with the saved original.

setwd("/scratch/user/uqwtsai/mRNAseq/tomato_SL4.1")
getwd()
list.files()

# ---- install if missing ----
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

cran_pkgs <- c("data.table", "ggplot2", "pheatmap")
bio_pkgs  <- c("Rsubread", "DESeq2")

for (p in cran_pkgs) {
  if (!requireNamespace(p, quietly = TRUE))
    install.packages(p)
}
for (p in bio_pkgs) {
  if (!requireNamespace(p, quietly = TRUE))
    BiocManager::install(p, ask = FALSE, update = FALSE)
}

# ---- load packages (every session) ----
library(Rsubread)
library(DESeq2)
library(data.table)
library(ggplot2)
library(pheatmap)

# featureCounts; user-reported Rsubread version: 2.22.1 (verify)
bam_dir <- "hisat2_align"
gtf <- "ITAG4.1_annotation_gffread.gtf"

bam_files <- sort(list.files(bam_dir, pattern = "\\.sorted\\.bam$", full.names = TRUE))
length(bam_files)
bam_files[1:3]
stopifnot(file.exists(gtf))
stopifnot(length(bam_files) == 18)

fc <- featureCounts(
  files = bam_files,
  annot.ext = gtf,
  isGTFAnnotationFile = TRUE,
  GTF.featureType = "exon",
  GTF.attrType = "gene_id",
  isPairedEnd = TRUE,
  requireBothEndsMapped = TRUE,
  countChimericFragments = FALSE,
  strandSpecific = 2,
  nthreads = 6
)

counts <- fc$counts
colnames(counts) <- sub("\\.sorted\\.bam$", "", basename(colnames(counts)))
dim(counts)

dir.create("counts", showWarnings = FALSE)
fwrite(as.data.table(counts, keep.rownames = "Geneid"),
       file = "counts/tomato_ITAG4.1_featureCounts_Rsubread.tsv", sep = "\t")

write.csv(fc$stat,
          "counts/featureCounts_assignment_summary.csv",
          row.names = FALSE)
