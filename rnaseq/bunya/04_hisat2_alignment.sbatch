#!/bin/bash --login
#SBATCH --job-name=hisat2_array
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --qos=normal
#SBATCH --account=a_qaafi_chs
#SBATCH --array=0-17%2
#SBATCH --output=/scratch/user/uqwtsai/mRNAseq/tomato_SL4.1/hisat2_align/logs/%x_%A_%a.out
#SBATCH --error=/scratch/user/uqwtsai/mRNAseq/tomato_SL4.1/hisat2_align/logs/%x_%A_%a.err

set -euo pipefail
set -x
trap 'echo "FAILED at line $LINENO"; exit 1' ERR

module purge
module load hisat2/2.2.1-gompi-2022a
module load samtools
# python not required for this job; keep it removed to avoid toolchain noise
# module load python/3.10.4-gcccore-11.3.0

WORKDIR=/scratch/user/uqwtsai/mRNAseq/tomato_SL4.1
READDIR=/scratch/user/uqwtsai/mRNAseq/cutadapt_fastp/fastp_reads
IDX=${WORKDIR}/tomato_SL4_ITAG4.1
OUTDIR=${WORKDIR}/hisat2_align
LOGDIR=${OUTDIR}/logs

mkdir -p "${OUTDIR}" "${LOGDIR}"

# sanity check: index exists
ls -lh "${IDX}".*.ht2

# build list of R1 files (sorted so task IDs map consistently)
mapfile -t R1_LIST < <(ls -1 "${READDIR}"/*_fastp_R1.fastq.gz | sort)

NSAMPLES=${#R1_LIST[@]}
echo "Detected ${NSAMPLES} R1 files"

# ensure array range matches number of files
if [[ "${SLURM_ARRAY_TASK_ID}" -ge "${NSAMPLES}" ]]; then
  echo "ERROR: SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} >= NSAMPLES=${NSAMPLES}"
  exit 1
fi

R1="${R1_LIST[${SLURM_ARRAY_TASK_ID}]}"
SAMPLE=$(basename "${R1}" _fastp_R1.fastq.gz)
R2="${READDIR}/${SAMPLE}_fastp_R2.fastq.gz"

echo "Task ${SLURM_ARRAY_TASK_ID} processing sample: ${SAMPLE}"
echo "R1=${R1}"
echo "R2=${R2}"

# check mate exists
if [[ ! -f "${R2}" ]]; then
  echo "ERROR: Missing R2: ${R2}"
  exit 1
fi

BAM="${OUTDIR}/${SAMPLE}.sorted.bam"
BAI="${BAM}.bai"
HISAT_LOG="${OUTDIR}/${SAMPLE}_hisat2.log"
FLAGSTAT="${OUTDIR}/${SAMPLE}.flagstat.txt"

# skip if already done
if [[ -s "${BAM}" && -s "${BAI}" && -s "${FLAGSTAT}" ]]; then
  echo "Already done for ${SAMPLE} (BAM+BAI+flagstat exist). Exiting."
  exit 0
fi

# align -> sorted BAM
hisat2 -p "${SLURM_CPUS_PER_TASK}" --dta --rna-strandness RF -x "${IDX}" \
  -1 "${R1}" -2 "${R2}" \
  2> "${HISAT_LOG}" \
| samtools view -@ "${SLURM_CPUS_PER_TASK}" -bS - \
| samtools sort -@ "${SLURM_CPUS_PER_TASK}" -o "${BAM}"

samtools index "${BAM}"
samtools flagstat "${BAM}" > "${FLAGSTAT}"

echo "Finished sample: ${SAMPLE}"
