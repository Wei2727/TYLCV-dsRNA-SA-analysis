# TYLCV dsRNA and salicylic acid — manuscript analysis code

**Status: author-review release candidate, NOT an independently validated end-to-end pipeline.**

This repository collates manuscript-related scripts for topical dsRNA + salicylic acid experiments involving tomato yellow leaf curl virus (TYLCV) and PVX–GFP in *Nicotiana benthamiana*. Code was supplied by the researcher in October 2026.

## Structure

| Location | Content | Execution location |
| --- | --- | --- |
| `rnaseq/bunya/` | Lane concatenation, Cutadapt/fastp/FastQC, HISAT2 indexing + mapping, featureCounts | Bunya HPC and RStudio on Bunya |
| `rnaseq/deseq2/` | DESeq2 differential expression, PCA/VST, QC, DEG tables | RStudio on Bunya |
| `rnaseq/jupyter/` | GO result visualisation, SA/RNAi defence heatmaps, optional DEG UpSet plotting | JupyterLab on author's Mac |
| `viral_genome/` | TYLCV nucleotide-composition plots; iVar and mpileup branches | JupyterLab on author's Mac |
| `pvx_gfp/` | ilastik-exported HDF5 segmentation -> GFP area percent | JupyterLab on author's Mac |
| `statistics/` | Disease severity permutation Mann–Whitney analysis | JupyterLab on author's Mac |
| `docs/` | Methods/code map, required inputs, original-code provenance, checklist and GitHub/Zenodo instructions | Documentation |

## External software workflows

Raw/processed RCA sequencing reads were processed with Galaxy Australia and NMDC EDGE (versions and settings in the manuscript). ilastik 1.4.0 was used for image segmentation. The online g:Profiler server performed the GO enrichment (9 Feb 2026). These external platforms are **not reimplemented or bundled**; the notebooks present custom downstream plotting/quantification. GraphPad Prism and qPCR worksheets are outside the scope of this code repository.

## Important reproducibility limitations

- The Bunya files were transcribed from author-supplied saved script text with formatting normalisation, not copied byte-for-byte from the original Bunya disk. Historical Bunya scratch outputs/logs have been cleaned. Scripts were not rerun during repository compilation.
- For sharing, Jupyter **source and markdown are preserved**, but embedded outputs/execution counts were cleared. No notebook was rerun. A pasted R syntax escape (`design = \~ Condition`) was corrected to `design = ~ Condition` without changing the intended design.
- Input files are **not bundled** in this lean code-only version. Refer to `docs/REQUIRED_INPUTS.md`. Some code uses relative paths tied to the original working directory; adjust input paths locally before reuse.
- Do not claim this repository is completely reproducible without providing or linking the required inputs and metadata. Do not assume outputs or execution logs still exist on Bunya.
- Verify class IDs for PVX–GFP segmentation, disease-score replicate scope and sample uniqueness (see `docs/REVIEW_BEFORE_RELEASE.md`).

## Release / citation

See `docs/GITHUB_ZENODO_STEPS.md`. Populate and rename `CITATION.cff.example` to `CITATION.cff` with approved author(s) **before creating the public release**. Choose an open-source license only after confirming author/institution permissions. Add the actual Zenodo DOI after the record is created; no DOI is assigned to this draft.

## Availability

Repository not yet published. A manuscript Code Availability Statement should be finalised after the GitHub release has been archived in Zenodo (see `docs/GITHUB_ZENODO_STEPS.md`).
