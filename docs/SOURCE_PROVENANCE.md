# Provenance and scope of publication copy

This code collection was compiled from saved copies or transcriptions of the analytical scripts and notebook sources associated with the manuscript. The source files were supplied for repository preparation, and several shell/R files were reconstructed from text rather than directly copied from verified executed originals.

- Scientific commands and reported analytical settings were preserved where available. The R formula `design = ~ Condition` was normalised from source-text formatting during original compilation.
- The **privacy review** replaced private directory paths with explicitly configured variables, removed institutional Slurm project/account and queue directives, made scheduler log paths relative, and removed directory-inspection debugging statements from notebooks and scripts. The generic HPC folder name replaced a site-specific directory name.
- Notebook outputs, execution counts, run-history metadata and environment-specific kernel names were cleared. Figures and analyses were not regenerated as part of the privacy review.
- The repository ZIP deliberately **excludes all .git history**, operating-system metadata and hidden system files. Git history in any previously published remote repository is a separate issue; see `PRIVACY_CHECK.md`.
- The original command transcripts, input data, historical execution logs and tool versions were not independently verified. Check the final repository against the manuscript before public release.

This document is not evidence that the published scripts were rerun or executed successfully.
