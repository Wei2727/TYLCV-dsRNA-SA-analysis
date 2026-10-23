# Review before publishing or archiving code

These are review tasks, not claims that the data or code were verified.

- [ ] Confirm the repository has a **clean Git history** without previously committed private paths or identities; see `PRIVACY_CHECK.md`.
- [ ] Verify no identifying information is present in source, notebook metadata, outputs, commit author/email, account settings, or linked files.
- [ ] Compare the scientific commands and data-processing workflow with the actual historical scripts; no computational work was rerun when making the publication copy.
- [ ] Confirm all 18 sample prefixes are unique when using `SAMPLE_SHORT=${SAMPLE_LONG%%_*}`; otherwise files may be overwritten.
- [ ] Check the Slurm array sample-list creation for race conditions when many tasks launch at once; do not assume it was race-free historically.
- [ ] Verify the Cutadapt version reported in Methods (v4.2) against historical module configuration; original module load was unpinned. Check Rsubread/DESeq2/SAMtools versions where records are available.
- [ ] Confirm locations or accession numbers for all RNA-seq and virus-genome data, and whether data-sharing approval is needed.
- [ ] Document provenance of annotated DEG CSV tables, and any annotation joining/mapping step used before GO and heatmap plotting.
- [ ] Record g:Profiler settings, input gene lists, background, and correction method where available; the notebook consumes exported tables rather than running the web analysis.
- [ ] Verify which TYLCV notebook branch produced the published figure; the mpileup ≥30% heterogeneity threshold is distinct from the 42% figure-labelling threshold and iVar plotting.
- [ ] Confirm ilastik exported class IDs: 1 background, 2 leaf, 3 GFP and HDF5 dataset `exported_data`.
- [ ] Confirm whether disease score data (three plants per treatment at each recorded day) represent one trial or a pooled dataset. Align with figure legend and Methods.
- [ ] Confirm whether the UpSet notebook's plots are included in the submitted paper/supplements.
- [ ] Confirm the notebook inputs listed in `REQUIRED_INPUTS.md` are available, and confirm intermediate processing requirements.
- [ ] Select approved authorship, release metadata and licence; keep `CITATION.cff.example` as an example until approved.
- [ ] Obtain coauthor or institution approval before publishing and archiving a DOI version.

No analyses were rerun or independently validated in preparing this version.
