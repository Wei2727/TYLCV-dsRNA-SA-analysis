#!/bin/bash --login
#SBATCH --job-name=hisat2_index
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --qos=normal
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

set -euo pipefail

WORKDIR="$(pwd)"
mkdir -p logs
cd "$WORKDIR"

FA="S_lycopersicum_chromosomes.4.00.fa"
GTF="ITAG4.1_annotation_gffread.gtf"
INDEX_PREFIX="tomato_SL4_ITAG4.1"

echo "Host: $(hostname)"
echo "Working dir: $WORKDIR"
echo "FA:  $FA"
echo "GTF: $GTF"
echo "Index prefix: $INDEX_PREFIX"
date

[ -s "$FA" ]  || { echo "ERROR: genome FASTA not found/empty: $FA"; exit 1; }
[ -s "$GTF" ] || { echo "ERROR: annotation GTF not found/empty: $GTF"; exit 1; }

module purge
module load python/3.10.4-gcccore-11.3.0
module load hisat2/2.2.1-gompi-2022a

echo "Extracting splice sites and exons..."
# (These are light; srun is optional, but keeping is OK.)
srun hisat2_extract_splice_sites.py "$GTF" > "${INDEX_PREFIX}.splicesites.txt"
srun hisat2_extract_exons.py "$GTF" > "${INDEX_PREFIX}.exons.txt"

[ -s "${INDEX_PREFIX}.splicesites.txt" ] || { echo "ERROR: splicesites file is empty"; exit 1; }
[ -s "${INDEX_PREFIX}.exons.txt" ]      || { echo "ERROR: exons file is empty"; exit 1; }

echo "Splice sites lines: $(wc -l < ${INDEX_PREFIX}.splicesites.txt)"
echo "Exons lines:       $(wc -l < ${INDEX_PREFIX}.exons.txt)"

echo "Building HISAT2 index..."
srun hisat2-build \
  --ss "${INDEX_PREFIX}.splicesites.txt" \
  --exon "${INDEX_PREFIX}.exons.txt" \
  -p "${SLURM_CPUS_PER_TASK}" \
  "$FA" \
  "$INDEX_PREFIX"

echo "Index files created:"
ls -lh ${INDEX_PREFIX}*.ht2

echo "hisat2 version:"
hisat2 --version | head -n 1

date
echo "DONE"
