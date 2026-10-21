# Transcribed from supplied manuscript chat paste; original source file not verified.
# Markdown backslashes, nonbreaking spaces, and typographic quotes were normalized.
# ============================================================
# Tomato RNA-seq DESeq2 clean pipeline
# featureCounts table -> DESeq2 -> VST counts -> PCA + clustering
# PCA uses top 500 most variable VST genes, matching DESeq2 plotPCA default
# Clustering tested from k = 2 to k = 6
# No ellipses
# ============================================================
setwd("/scratch/user/uqwtsai/mRNAseq/tomato_SL4.1")
getwd()
# ============================================================
# 1. Load packages
# ============================================================
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
cran_pkgs <- c(
  "data.table",
  "ggplot2",
  "pheatmap",
  "matrixStats",
  "ggrepel",
  "cluster"
)
bio_pkgs <- c("DESeq2")
for (p in cran_pkgs) {
  if (!requireNamespace(p, quietly = TRUE))
    install.packages(p)
}
for (p in bio_pkgs) {
  if (!requireNamespace(p, quietly = TRUE))
    BiocManager::install(p, ask = FALSE, update = FALSE)
}
library(DESeq2)
library(data.table)
library(ggplot2)
library(pheatmap)
library(matrixStats)
library(ggrepel)
library(cluster)
set.seed(123)
dir.create("counts", showWarnings = FALSE)
dir.create("counts/PCA_clusters", showWarnings = FALSE)
# ============================================================
# 2. Read featureCounts count table
# ============================================================
fc_file <- "counts/tomato_ITAG4.1_featureCounts_Rsubread.tsv"
counts_df <- fread(fc_file)
counts_df <- as.data.frame(counts_df)
stopifnot("Geneid" %in% colnames(counts_df))
# Remove featureCounts annotation columns if present
annotation_cols <- intersect(
  c("Chr", "Start", "End", "Strand", "Length"),
  colnames(counts_df)
)
counts_df <- counts_df[, setdiff(colnames(counts_df), annotation_cols), drop = FALSE]
rownames(counts_df) <- counts_df$Geneid
counts_df$Geneid <- NULL
# Clean sample names if they contain paths or .sorted.bam
colnames(counts_df) <- basename(colnames(counts_df))
colnames(counts_df) <- sub("\\.sorted\\.bam$", "", colnames(counts_df))
counts <- as.matrix(counts_df)
mode(counts) <- "integer"
cat("Count matrix dimension:\n")
print(dim(counts))
print(counts[1:3, 1:min(4, ncol(counts))])
# ============================================================
# 3. Read sample metadata
# sample_info.csv must have Sample and Condition columns
# ============================================================
meta2 <- read.csv("counts/sample_info.csv", stringsAsFactors = FALSE)
# Fix lowercase condition column if needed
if ("condition" %in% colnames(meta2) && !"Condition" %in% colnames(meta2)) {
  colnames(meta2)[colnames(meta2) == "condition"] <- "Condition"
}
stopifnot("Sample" %in% colnames(meta2))
stopifnot("Condition" %in% colnames(meta2))
# Recode older condition names if present
meta2$Condition <- as.character(meta2$Condition)
meta2$Condition[meta2$Condition == "Control"] <- "Mock"
meta2$Condition[meta2$Condition == "NSC"] <- "NSCdsR"
meta2$Condition[meta2$Condition == "Spec"] <- "V1C3dsR"
meta2$Condition[meta2$Condition == "NSCSA"] <- "NSCdsR_SA"
meta2$Condition[meta2$Condition == "SpecSA"] <- "V1C3dsR_SA"
cat("Samples in count table:\n")
print(colnames(counts))
cat("Samples in metadata:\n")
print(meta2$Sample)
stopifnot(all(colnames(counts) %in% meta2$Sample))
# Match metadata order to count matrix columns
meta2 <- meta2[match(colnames(counts), meta2$Sample), , drop = FALSE]
rownames(meta2) <- meta2$Sample
meta2$Condition <- factor(
  meta2$Condition,
  levels = c(
    "Mock",
    "SA",
    "NSCdsR",
    "V1C3dsR",
    "NSCdsR_SA",
    "V1C3dsR_SA"
  )
)
stopifnot(identical(colnames(counts), rownames(meta2)))
cat("Final metadata:\n")
print(meta2)
write.csv(meta2, "counts/sample_metadata_used.csv", row.names = FALSE)
# ============================================================
# 4. Build DESeq2 object
# ============================================================
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData   = meta2,
  design    = ~ Condition
)
# Low-count filtering
keep <- rowSums(counts(dds) >= 10) >= 2
dds <- dds[keep, ]
cat("Genes retained after filtering:\n")
print(nrow(dds))
# Save raw library sizes after filtering
libsize <- colSums(counts(dds))
write.csv(
  data.frame(sample = names(libsize), libsize = libsize),
  "counts/library_sizes_raw_after_filtering.csv",
  row.names = FALSE
)
# ============================================================
# 5. Run DESeq2
# ============================================================
dds <- DESeq(dds)
# ============================================================
# 6. Export normalised counts and VST counts
# ============================================================
norm_counts <- counts(dds, normalized = TRUE)
write.csv(
  norm_counts,
  "counts/normalized_counts.csv",
  quote = FALSE
)
log2_norm_counts <- log2(norm_counts + 1)
write.csv(
  log2_norm_counts,
  "counts/log2_normalized_counts.csv",
  quote = FALSE
)
vsd <- vst(dds, blind = FALSE)
vst_counts <- assay(vsd)
write.csv(
  vst_counts,
  "counts/VST_counts.csv",
  quote = FALSE
)
cat("Saved VST counts to counts/VST_counts.csv\n")
# ============================================================
# 7. QC plots not affected by PCA choice
# ============================================================
png("counts/QC_dispersion.png", width = 900, height = 700)
plotDispEsts(dds)
dev.off()
pdf("counts/QC_count_distribution_raw_filtered.pdf", width = 9, height = 5)
boxplot(
  log10(counts(dds) + 1),
  las = 2,
  main = "Count distribution after low-count filtering",
  ylab = "log10(count + 1)"
)
dev.off()
# ============================================================
# 8. Select top 500 most variable VST genes
# This matches DESeq2 plotPCA default ntop = 500
# ============================================================
rv <- matrixStats::rowVars(vst_counts)
ntop <- 500
select_top <- order(rv, decreasing = TRUE)[seq_len(min(ntop, length(rv)))]
vst_top500 <- vst_counts[select_top, ]
write.csv(
  data.frame(
    GeneID = rownames(vst_top500),
    VST_variance = rv[select_top]
  ),
  "counts/top500_variable_genes_used_for_PCA_and_clustering.csv",
  row.names = FALSE
)
# ============================================================
# 9. PCA using top 500 variable genes
# ============================================================
pca_res <- prcomp(t(vst_top500), scale. = FALSE)
percentVar <- round(
  100 * (pca_res$sdev^2 / sum(pca_res$sdev^2))
)
cat("PCA using top 500 variable genes:\n")
cat("PC1 =", percentVar[1], "%\n")
cat("PC2 =", percentVar[2], "%\n")
pca_df <- as.data.frame(pca_res$x[, 1:2])
pca_df$Sample <- rownames(pca_df)
pca_df$Condition <- meta2[pca_df$Sample, "Condition"]
pca_df$Condition <- factor(
  pca_df$Condition,
  levels = c(
    "Mock",
    "SA",
    "NSCdsR",
    "V1C3dsR",
    "NSCdsR_SA",
    "V1C3dsR_SA"
  )
)
write.csv(
  pca_df,
  "counts/PCA_top500_VST_coordinates.csv",
  row.names = FALSE
)
# PCA treatment-only plot, no ellipses
p_pca_treatment <- ggplot(
  pca_df,
  aes(x = PC1, y = PC2, color = Condition)
) +
  geom_point(size = 4, alpha = 0.95) +
  ggrepel::geom_text_repel(
    aes(label = Sample),
    size = 3,
    show.legend = FALSE,
    max.overlaps = 50
  ) +
  xlab(paste0("PC1: ", percentVar[1], "%")) +
  ylab(paste0("PC2: ", percentVar[2], "%")) +
  theme_bw(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold")
  ) +
  ggtitle("PCA of VST counts using top 500 variable genes")
ggsave(
  "counts/PCA_top500_VST_treatment_no_ellipse.png",
  p_pca_treatment,
  width = 7.2,
  height = 5.5,
  dpi = 600
)
ggsave(
  "counts/PCA_top500_VST_treatment_no_ellipse.pdf",
  p_pca_treatment,
  width = 7.2,
  height = 5.5
)
print(p_pca_treatment)
# ============================================================
# 10. Unsupervised clustering, k = 2 and k = 3, top 500 VST genes
# ============================================================
library(cluster)
sample_dist_top500 <- dist(t(vst_top500))
hc_top500 <- hclust(sample_dist_top500, method = "complete")
png("counts/VST_top500_dendrogram.png", width = 1000, height = 700)
plot(hc_top500, main = "Unsupervised clustering, top 500 variable VST genes",
     xlab = "", sub = "")
dev.off()
membership <- data.frame(
  Sample    = colnames(vst_top500),
  Condition = meta2[colnames(vst_top500), "Condition"]
)
for (k_cluster in 2:3) {
  sample_cluster <- cutree(hc_top500, k = k_cluster)
  membership[[paste0("k", k_cluster)]] <- paste0("Cluster ", sample_cluster)
  sil <- cluster::silhouette(sample_cluster, sample_dist_top500)
  mean_sil <- mean(sil[, "sil_width"])
  pca_cluster_df <- merge(
    pca_df,
    data.frame(Sample = names(sample_cluster),
               Transcriptome_cluster = paste0("Cluster ", sample_cluster)),
    by = "Sample"
  )
  cat("\n--- k =", k_cluster, "| mean silhouette =", round(mean_sil, 3), "---\n")
  print(table(pca_cluster_df$Transcriptome_cluster, pca_cluster_df$Condition))
  hull_df <- do.call(rbind, lapply(
    split(pca_cluster_df, pca_cluster_df$Transcriptome_cluster),
    function(d) if (nrow(d) >= 3) d[chull(d$PC1, d$PC2), ] else NULL
  ))
  p <- ggplot(pca_cluster_df, aes(PC1, PC2))
  if (!is.null(hull_df) && nrow(hull_df) > 0) {
    p <- p + geom_polygon(
      data = hull_df,
      aes(PC1, PC2, group = Transcriptome_cluster, fill = Transcriptome_cluster),
      alpha = 0.12, colour = NA
    )
  }
  p <- p +
    geom_point(aes(color = Condition), size = 4, alpha = 0.95) +
    ggrepel::geom_text_repel(aes(label = Sample), size = 3,
                             show.legend = FALSE, max.overlaps = 50) +
    xlab(paste0("PC1: ", percentVar[1], "%")) +
    ylab(paste0("PC2: ", percentVar[2], "%")) +
    theme_bw(base_size = 12) +
    theme(panel.grid = element_blank(),
          plot.title = element_text(hjust = 0.5, face = "bold")) +
    ggtitle(paste0("Top 500 VST genes, k = ", k_cluster,
                   " | mean silhouette = ", round(mean_sil, 3)))
  ggsave(paste0("counts/PCA_top500_VST_clusters_k", k_cluster, ".png"),
         p, width = 7.5, height = 5.8, dpi = 600)
  ggsave(paste0("counts/PCA_top500_VST_clusters_k", k_cluster, ".pdf"),
         p, width = 7.5, height = 5.8)
  print(p)
}
write.csv(membership, "counts/VST_top500_cluster_membership_k2_k3.csv",
          row.names = FALSE)
# ============================================================
# 11. Sample distance and correlation heatmaps
# Use all filtered VST genes for general QC
# ============================================================
annotation_df <- data.frame(
  Condition = meta2$Condition
)
rownames(annotation_df) <- rownames(meta2)
sample_dist_all <- dist(t(vst_counts))
sampleDistMatrix_all <- as.matrix(sample_dist_all)
pheatmap(
  sampleDistMatrix_all,
  annotation_col = annotation_df,
  annotation_row = annotation_df,
  filename = "counts/heatmap_sample_sample_distance_all_VST_genes.png"
)
cor_mat_all <- cor(vst_counts)
pheatmap(
  cor_mat_all,
  annotation_col = annotation_df,
  annotation_row = annotation_df,
  filename = "counts/heatmap_sample_correlation_all_VST_genes.png"
)
# ============================================================
# 12. Top variable gene heatmaps
# Same top 500 genes used for PCA/clustering
# ============================================================
pheatmap(
  vst_top500,
  annotation_col = annotation_df,
  show_rownames = FALSE,
  filename = "counts/heatmap_VST_top500_variable_genes.png"
)
mat_z_top500 <- t(scale(t(vst_top500)))
pheatmap(
  mat_z_top500,
  annotation_col = annotation_df,
  show_rownames = FALSE,
  filename = "counts/heatmap_Zscore_VST_top500_variable_genes.png"
)
# ============================================================
# 13. DESeq2 contrasts vs Mock
# padj < 0.05 and |log2FC| >= 1 used for DEG classification
# ============================================================
volcano_plot <- function(res, title, outfile, padj_cut = 0.05, lfc_cut = 1) {
  df <- as.data.frame(res)
  df$gene <- rownames(df)
  df$neglog10padj <- -log10(df$padj)
  df$neglog10padj[!is.finite(df$neglog10padj)] <- NA
  df$signif <- "NS"
  df$signif[
    !is.na(df$padj) &
      df$padj < padj_cut &
      df$log2FoldChange >= lfc_cut
  ] <- "Up"
  df$signif[
    !is.na(df$padj) &
      df$padj < padj_cut &
      df$log2FoldChange <= -lfc_cut
  ] <- "Down"
  p <- ggplot(
    df,
    aes(
      x = log2FoldChange,
      y = neglog10padj,
      color = signif
    )
  ) +
    geom_point(size = 1.2, alpha = 0.7, na.rm = TRUE) +
    geom_vline(xintercept = c(-lfc_cut, lfc_cut), linetype = "dashed") +
    geom_hline(yintercept = -log10(padj_cut), linetype = "dashed") +
    theme_bw(base_size = 12) +
    theme(panel.grid = element_blank()) +
    labs(
      title = title,
      x = "log2 fold change",
      y = "-log10 adjusted p-value"
    )
  ggsave(outfile, p, width = 6.5, height = 5, dpi = 300)
}
groups <- setdiff(levels(meta2$Condition), "Mock")
for (g in groups) {
  message("Running contrast: ", g, " vs Mock")
  res <- results(dds, contrast = c("Condition", g, "Mock"))
  res <- res[order(res$padj), ]
  res_df <- as.data.frame(res)
  res_df$gene <- rownames(res_df)
  # Full DESeq2 result table
  write.csv(
    res_df,
    paste0("counts/DE_", g, "_vs_Mock_all_genes.csv"),
    row.names = FALSE,
    quote = FALSE
  )
  # Filtered DEGs
  deg_df <- res_df[
    !is.na(res_df$padj) &
      res_df$padj < 0.05 &
      abs(res_df$log2FoldChange) >= 1,
  ]
  deg_up <- deg_df[deg_df$log2FoldChange >= 1, ]
  deg_down <- deg_df[deg_df$log2FoldChange <= -1, ]
  write.csv(
    deg_df,
    paste0("counts/DEG_", g, "_vs_Mock_padj0.05_log2FC1.csv"),
    row.names = FALSE,
    quote = FALSE
  )
  write.csv(
    deg_up,
    paste0("counts/DEG_UP_", g, "_vs_Mock_padj0.05_log2FC1.csv"),
    row.names = FALSE,
    quote = FALSE
  )
  write.csv(
    deg_down,
    paste0("counts/DEG_DOWN_", g, "_vs_Mock_padj0.05_log2FC1.csv"),
    row.names = FALSE,
    quote = FALSE
  )
  # MA plot
  png(
    paste0("counts/MA_", g, "_vs_Mock.png"),
    width = 900,
    height = 700
  )
  plotMA(res, main = paste0(g, " vs Mock"), ylim = c(-6, 6))
  dev.off()
  # Volcano
  volcano_plot(
    res,
    title = paste0(g, " vs Mock"),
    outfile = paste0("counts/Volcano_", g, "_vs_Mock.png"),
    padj_cut = 0.05,
    lfc_cut = 1
  )
}
message("Finished. Outputs written to counts/")
