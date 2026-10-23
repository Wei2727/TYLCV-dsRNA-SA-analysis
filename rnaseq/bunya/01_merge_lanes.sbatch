#!/bin/bash
#SBATCH --job-name=merge_lanes
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --output=merge_lanes_%j.out
#SBATCH --error=merge_lanes_%j.err

set -euo pipefail

# Go to your input directory (edit if different)
WORKDIR=/scratch/user/uqwtsai/mRNAseq
cd "$WORKDIR"

mkdir -p mRNAseq_cat

echo -e "Sample\tRead\tL005_lines\tL006_lines\tMerged_lines\tMerged_reads" > merge_counts.tsv

for f in *_L005_R1.fastq.gz; do
  base=${f%_L005_R1.fastq.gz}
  echo "==== Processing $base ===="

  # R1
  f1a=${base}_L005_R1.fastq.gz
  f1b=${base}_L006_R1.fastq.gz
  out1=mRNAseq_cat/${base}_R1.fastq.gz

  cat "$f1a" "$f1b" > "$out1"

  l1a=$(zcat "$f1a" | wc -l)
  l1b=$(zcat "$f1b" | wc -l)
  l1m=$(zcat "$out1" | wc -l)
  r1m=$((l1m/4))
  echo -e "${base}\tR1\t$l1a\t$l1b\t$l1m\t$r1m" | tee -a merge_counts.tsv

  # R2
  f2a=${base}_L005_R2.fastq.gz
  f2b=${base}_L006_R2.fastq.gz
  out2=mRNAseq_cat/${base}_R2.fastq.gz

  cat "$f2a" "$f2b" > "$out2"

  l2a=$(zcat "$f2a" | wc -l)
  l2b=$(zcat "$f2b" | wc -l)
  l2m=$(zcat "$out2" | wc -l)
  r2m=$((l2m/4))
  echo -e "${base}\tR2\t$l2a\t$l2b\t$l2m\t$r2m" | tee -a merge_counts.tsv
done

echo "Done. Outputs:"
ls -lh merge_counts.tsv mRNAseq_cat | head
