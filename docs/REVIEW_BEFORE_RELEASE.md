# Author review — do this BEFORE the first public release

Mark these off locally; they are NOT claims of validation.

- [ ] Approve the manuscript/code scope: omit `upset_overview.ipynb` if its DEG UpSet figures are not part of manuscript/supplement.
- [ ] Review files for usernames, UQ HPC project/account identifiers, personal paths, private research material and API keys. Bunya scripts contain path/account metadata but no credentials were observed; confirm permission to share.
- [ ] Check supplied scripts against saved originals on the Mac if possible; Bunya scratch was cleaned. Pasted Markdown was normalized, and R design escaped tilde was corrected to `~ Condition`.
- [ ] Check mapping of `M1_...` -> `M1` for uniqueness of **all** 18 samples. `SAMPLE_SHORT=${SAMPLE_LONG%%_*}` may overwrite results if short prefixes collide.
- [ ] Confirm historic software versions: Cutadapt is an unpinned `module load cutadapt`, although Methods claim v4.2. Confirm Rsubread v2.22.1, DESeq2 v1.48.2, samtools, Python dependencies and raw reference files where possible. Don't guess values for lost logs.
- [ ] Verify the source of `*_DE_annotated.csv` — annotation/merging code is not provided. Decide whether to share derived CSVs in a separate data archive or provide an access location; notebooks are not executable without them.
- [ ] Record actual g:Profiler gene lists, organism, annotation/database background, FDR adjustment and run settings if available (9 Feb 2026); CSV exports alone may not capture all settings.
- [ ] Check the TYLCV notebook iVar 5–90% frequency branch versus manuscript mpileup >=30% heterogeneity cutoff. Ensure captions refer to the correct branch, and note that alignment/consensus commands are not included.
- [ ] Confirm ilastik HDF5 label IDs (1=background, 2=leaf, 3=GFP) and dataset key `exported_data`; image segmentation project is not supplied.
- [ ] Confirm whether the disease notebook's 3 vs 3 observations per time point are from one experiment or pooled from independent replicates. Reconcile with Methods and figure legends without changing code to force a match.
- [ ] Confirm the optional UpSet plot notebook belongs to the submitted manuscript.
- [ ] Approve software authorship/credits and choose a license; rename/edit `CITATION.cff.example` to `CITATION.cff` with real author details before any Zenodo release.
- [ ] Decide where source FASTQs or other supporting datasets are archived, and add a Data Availability Statement separately.
- [ ] Run a code/metadata review with your coauthors and institutional policy before changing repository from private to public.

No analysis was rerun or independently reconciled against final figure tables for this release candidate.
