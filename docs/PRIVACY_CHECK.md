# Privacy and clean-history publication checklist

This repository copy has had direct filesystem paths, HPC account/queue identifiers, notebook directory-printing commands, hidden .git data and macOS metadata removed. This **does not** guarantee complete anonymity or prevent identification of a repository owner.

## Why merely pushing edited files to an existing repository is not enough

Git keeps prior commit content and associated author metadata. A file that no longer shows a private path on `main` can still expose that path in older commits after making the repository public. An uploaded ZIP that contains `.git` can also carry commit history, remote URLs, names and email addresses.

**Safest approach before a public Zenodo release:**
1. Keep your current GitHub repository private. Retain a backup of the original files privately.
2. Create a **new empty repository with fresh history**. Add the *contents* of this publication package only, never its parent directory or an old `.git` folder. Do not initialise the new repository by copying previous commit history.
3. Configure Git's commit author and email to the identity you intend to publish. GitHub supports a `noreply` email address to avoid publishing an ordinary email address. The GitHub account/organisation name and contributions will nevertheless be visible on a public repository. If disclosing ownership itself is a concern, plan repository ownership with collaborators/institution before publishing.
4. Check GitHub's **History** view, the repository's **Settings**, and each file before switching visibility to Public; verify that the first commit contains only intended content.
5. Delete the previous private repository only after confirming the new repository contains the desired code. Deleting an old public repository does not guarantee that forks, cached copies or third-party downloads disappear.
6. Review any scientific dataset and output separately for identifiable or non-public material. `.gitignore` protects untracked future files only; it does not erase earlier commits.

## Local content checks

- No `.git`, `.DS_Store`, `__MACOSX`, notebook checkpoint folder or old execution output should be in the final source archive.
- Avoid committing real home directories, scratch paths, institutional account names, usernames, personal email addresses, credentials or shell histories.
- Review GitHub profile, organisational ownership, commit author names/emails and release metadata before Zenodo integration; those are separate from the code ZIP.
- Include software citation author names and a licence only after approval. Code archiving with Zenodo makes the released version publicly and persistently accessible.
