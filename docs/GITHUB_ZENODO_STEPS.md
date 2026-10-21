# Publish GitHub code and archive a release in Zenodo

**First review** `REVIEW_BEFORE_RELEASE.md`. Do not publish while it is incomplete.

1. Unzip this repository to Mac Documents. Use [GitHub Desktop](https://desktop.github.com/): File > Add Local Repository > Choose this folder. If it is not yet a Git repository, choose **Create a Repository**. Select the folder as the repository root.
2. Review GitHub Desktop Changes; add a commit message e.g. `Import manuscript analysis scripts` and click **Commit to main**.
3. Click **Publish repository** and leave **Keep this code private** checked initially. You do not need a Zenodo account yet.
4. Fill in `CITATION.cff.example` with approved contributor credits and rename it `CITATION.cff`. Check licensing with authors/institution and add a real `LICENSE` file, if authorised. Commit and push. Do not add a fabricated DOI.
5. Verify code and documentation against manuscript. Ask coauthors for approval. When ready for open release, change the GitHub repository to **Public** via repository Settings > General > Danger Zone > Change repository visibility (review public disclosure implications). This is normally required for the GitHub-Zenodo public archive route.
6. Visit [Zenodo](https://zenodo.org) and sign in or create an account. Profile > Linked accounts > Connect GitHub, if not already linked. Then Profile menu > **GitHub** > **Sync now** > toggle this repository **On**. Do this **before** making the first GitHub release.
7. In GitHub open repository > **Releases** > **Draft a new release** > Choose a tag > **Create new tag** (e.g. `v1.0.0`) > select target branch `main`. Release title e.g. `Manuscript analysis scripts v1.0.0`. Add a short methods/code description and press **Publish release** (not prerelease). No code changes should be needed in the archived snapshot after this point.
8. Go to Zenodo > Profile menu > **GitHub**, select repository and check release status; once archived, click the Zenodo record to obtain its **actual DOI**. If it fails, check Zenodo's Errors entry, revise as directed, and publish a new version.
9. Put the minted version-specific DOI in the manuscript Code Availability Statement, and optionally add a Zenodo badge or citation in the GitHub README in a subsequent commit (subsequent README edit is **not** part of the already-archived release; create a new release if the updated text must be archived).

Code Availability Statement (fill in after DOI exists):

> The custom R, Bash and Python analysis scripts used in this study are available at [GITHUB REPOSITORY URL]. The code version associated with this manuscript is archived in Zenodo at [ACTUAL ZENODO VERSION DOI]. Data needed to execute individual scripts are described in the repository README and relevant data-availability materials.

**Versions**: each archived release has an individual version DOI. Cite the version used in your paper; record a new release to archive later code updates. Zenodo assigns the identifier; do not invent it or put dummy values in a published manuscript.

Official sources:
- https://docs.github.com/en/desktop/overview/creating-your-first-repository-using-github-desktop
- https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
- https://help.zenodo.org/docs/profile/linking-accounts/
- https://help.zenodo.org/docs/github/enable-repository/
- https://help.zenodo.org/docs/github/archive-software/github-upload/
- https://help.zenodo.org/docs/github/describe-software/citation-file/
