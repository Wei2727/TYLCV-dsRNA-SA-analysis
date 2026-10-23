# Create a new clean GitHub repository and archive an approved version

Read `PRIVACY_CHECK.md` and `REVIEW_BEFORE_RELEASE.md` first. Do **not** publish an older repository containing private paths or identifiers in its commit history merely by committing corrected files.

## Create the repository without old history

1. Keep the original analysis directory and any previous Git repository private as a backup.
2. In GitHub Desktop, choose **File > New Repository**. Enter your preferred repository name, choose a parent location, leave *Initialize with README* unchecked, and create the repository. GitHub Desktop creates its own new `.git` folder.
3. Choose **Repository > Show in Finder**. Open the extracted privacy-reviewed package elsewhere, and copy **its contents** (README, `.gitignore`, `rnaseq`, etc.) into the new GitHub repository folder. Do **not** copy another repository's `.git` folder or re-use its previous history.
4. Return to GitHub Desktop. Check **Changes**. Review the proposed first commit and use the **History** tab to verify that there is no earlier history.
5. Ensure the Git author name/email to be recorded are appropriate for publication; consider a GitHub `noreply` email to avoid publishing a personal email address. If the public account name itself must not be disclosed, decide on an approved organisation/repository owner **before** publishing.
6. Commit to `main`, click **Publish repository**, tick **Keep this code private**, and only then confirm the final publication step.
7. Open the private repository on GitHub.com and inspect every uploaded file. Confirm privacy and check code, metadata, inputs and statements before proceeding.

## Public software release (after approval)

8. Approve author/contributor metadata and licensing. Fill `CITATION.cff.example` with approved credits and rename it `CITATION.cff` when ready; do not invent a DOI.
9. Confirm the repository's first commit has no private paths, credentials, local account details or prior sensitive history. Obtain necessary collaborator/institution clearance. Change the repository visibility to Public only if approved.
10. Log into [Zenodo](https://zenodo.org), connect GitHub under Linked accounts, sync repositories and enable the chosen repository for archiving **before** publishing a GitHub release.
11. In GitHub choose **Releases > Draft a new release**, create a tag such as `v1.0.0` on the approved branch, and publish the release. Verify the Zenodo archive and its real version-specific DOI.
12. Use the minted DOI in the Code Availability statement. Changes made after this archival release require a new release/tag to update the archived snapshot.

The source package intentionally contains no `.git` directory. Installing its contents into an existing repository with old history does **not** cleanse that repository's historical commit objects.

Useful official references:
- https://docs.github.com/en/desktop/overview/creating-your-first-repository-using-github-desktop
- https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
- https://help.zenodo.org/docs/github/enable-repository/
- https://help.zenodo.org/docs/github/archive-software/github-upload/
