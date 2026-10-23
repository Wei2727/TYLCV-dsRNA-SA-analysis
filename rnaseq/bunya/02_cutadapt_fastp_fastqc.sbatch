#!/bin/bash
#SBATCH --job-name=ca_fp_fqc
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=12G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err
#SBATCH --array=1-18%3

set -euo pipefail

# IN_DIR: concatenated FASTQ directory. OUT_ROOT: destination for processed reads.
# Supply both as environment variables at submission, not in the repository.
IN_DIR="${IN_DIR:?Set IN_DIR to the directory containing merged paired FASTQ files}"
OUT_ROOT="${OUT_ROOT:?Set OUT_ROOT to the desired output directory}"
FASTP_READS=${OUT_ROOT}/fastp_reads
FASTP_REPORTS=${OUT_ROOT}/fastp_reports
FASTQC_DIR=${OUT_ROOT}/fastqc
CA_REPORTS=${OUT_ROOT}/cutadapt_reports
LIST_DIR=${OUT_ROOT}/lists
TMP_BASE=${OUT_ROOT}/tmp

mkdir -p logs "$FASTP_READS" "$FASTP_REPORTS" "$FASTQC_DIR" "$CA_REPORTS" "$LIST_DIR" "$TMP_BASE"

# ---------- build sample list ----------
SAMPLE_LIST=${LIST_DIR}/samples_long.txt
if [ "${SLURM_ARRAY_TASK_ID}" -eq 1 ] && [ ! -s "$SAMPLE_LIST" ]; then
  ls "${IN_DIR}"/*_R1.fastq.gz | sed 's|.*/||; s|_R1.fastq.gz||' > "$SAMPLE_LIST"
fi
sleep 2

SAMPLE_LONG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST" || true)
[ -z "$SAMPLE_LONG" ] && exit 0

SAMPLE_SHORT=${SAMPLE_LONG%%_*}

R1_IN="${IN_DIR}/${SAMPLE_LONG}_R1.fastq.gz"
R2_IN="${IN_DIR}/${SAMPLE_LONG}_R2.fastq.gz"

echo "Sample: $SAMPLE_LONG → $SAMPLE_SHORT"

# ---------- temp workspace ----------
WORK="${SLURM_TMPDIR:-${TMP_BASE}/${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}}"
mkdir -p "$WORK"
cd "$WORK"

cp "$R1_IN" R1.fastq.gz
cp "$R2_IN" R2.fastq.gz

# ---------- adapters ----------
A1="ACTGTCTCTTATACACATCT"
A2="CTGTCTCTTATACACATCT"

module purge
module load cutadapt 2>/dev/null || true
module load fastp/0.23.2
module load fastqc/0.11.9

# ---------- cutadapt (temp reads + saved report) ----------
CA_R1="${WORK}/ca_R1.fastq.gz"
CA_R2="${WORK}/ca_R2.fastq.gz"
CA_REP="${CA_REPORTS}/${SAMPLE_SHORT}.cutadapt.txt"

cutadapt \
  -a "$A1" -a "$A2" \
  -A "$A1" -A "$A2" \
  -m 20 \
  -j ${SLURM_CPUS_PER_TASK} \
  -o "$CA_R1" -p "$CA_R2" \
  R1.fastq.gz R2.fastq.gz \
  > "$CA_REP" 2>&1

gzip -t "$CA_R1"
gzip -t "$CA_R2"

# ---------- fastp (final reads kept) ----------
FP_R1="${FASTP_READS}/${SAMPLE_SHORT}_fastp_R1.fastq.gz"
FP_R2="${FASTP_READS}/${SAMPLE_SHORT}_fastp_R2.fastq.gz"

fastp \
  -i "$CA_R1" \
  -I "$CA_R2" \
  -o "$FP_R1" \
  -O "$FP_R2" \
  --disable_adapter_trimming \
  --overrepresentation_analysis \
  --thread ${SLURM_CPUS_PER_TASK} \
  --html "${FASTP_REPORTS}/${SAMPLE_SHORT}.fastp.html" \
  --json "${FASTP_REPORTS}/${SAMPLE_SHORT}.fastp.json"

gzip -t "$FP_R1"
gzip -t "$FP_R2"

# ---------- fastqc ----------
fastqc -t ${SLURM_CPUS_PER_TASK} \
  -o "$FASTQC_DIR" \
  "$FP_R1" "$FP_R2"

# ---------- cleanup temp ----------
rm -f "$CA_R1" "$CA_R2" R1.fastq.gz R2.fastq.gz

echo "Done $SAMPLE_SHORT"
