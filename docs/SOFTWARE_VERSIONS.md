# Software versions to verify

The following versions are reported in saved code or the manuscript draft, not recovered from historical execution records. Do not substitute a new environment's versions for the original ones.

| Tool | Reported version / evidence |
|---|---|
| HISAT2 | 2.2.1 (module in code) |
| fastp (RNA-seq) | 0.23.2 (module) |
| FastQC (RNA-seq) | 0.11.9 (module) |
| Cutadapt | 4.2 reported in manuscript; historical module unpinned |
| Rsubread | 2.22.1 reported in manuscript/code comment |
| DESeq2 | 1.48.2 reported in manuscript |
| g:Profiler | web analysis, 9 Feb 2026; full settings must be verified |
| ilastik | 1.4.0 per manuscript documentation |
| Python, R and other packages | exact historical versions not recovered |

Save `sessionInfo()` from the actual original R environment if retained; save Python `pip freeze` or conda environment export from the original analysis environment. These are not generated or guessed here. RCA/QC tool versions are separate from RNA-seq.
