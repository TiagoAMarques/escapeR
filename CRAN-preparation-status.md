# escapeR 0.1.0: GitHub and CRAN release checklist

Master checkout: C:/Users/tiago/Documents/GithubDesktop/escapeR.
Prepared 14 September 2026. Changes are ready for review and commit;
no commit, push, remote check upload or CRAN submission has been performed.

## Preparation completed

- Maintainer: Tiago Marques, tiago.marques@st-andrews.ac.uk.
- Version 0.1.0; R >= 4.0.0 declared.
- GPL (>= 3) retained; redundant GPL text and README-only images excluded from
  the CRAN archive while remaining in the GitHub repository.
- Added profile deletion, configurable storage, corrupt-save recovery,
  input validation and protection from player-name collisions.
- Temporary test storage; 466 assertions pass with no failures, warnings or skips.
- Added function examples, NEWS.md with the requested acknowledgement verbatim,
  submission comments and cross-platform CI.
- Removed an unused helper that wrote inside the installed package directory.
- Removed stale generated inst/doc copies: canonical sources are in vignettes,
  and R CMD build creates fresh installed documentation for all three vignettes.
- Generated release/check artifacts are ignored by Git and excluded from builds.
- The full git diff --check passes, including the testing helper. Its existing
  substantive changes were preserved; only trailing whitespace was cleaned.
- Added scripts/check-release.ps1 to reproduce the full local build/check.

## Locally verified archive

release-checks/escapeR_0.1.0.tar.gz: 178270 bytes.
SHA256: 3D05456A7D9491F2B2A761F4722FF8321A86673773D7731A201098C81157ED58

Full Windows 11 x64 / R 4.6.0 check: 0 errors, 0 warnings, 2 notes.
Includes examples, tests, all three rebuilt vignettes, and PDF/HTML manuals.
Suggested dependencies are required, not disabled.

Evidence is in release-checks/windows-R-4.6.0-check.log and
release-checks/windows-R-4.6.0-tests.Rout. These local files are ignored by Git.

The notes are New submission and lastMiKTeXException. The latter appears to be
a Windows TeX-toolchain artifact; both manual checks pass. It is explained in
cran-comments.md with a link to the R-package-devel discussion.

No case-insensitive escapeR name conflict was found in current CRAN (25,029
packages), the CRAN archive listing, or current Bioconductor 3.23 repositories
(2,384 software, 928 annotation, 434 experiment packages). This is not a name
reservation; recheck if submission is delayed.

## Steps to submit

1. **Review and commit in GitHub Desktop.** Open this master checkout and review
   the changes, including generated inst/doc deletions. Use a commit summary
   such as "Prepare escapeR 0.1.0 for CRAN". The testing helper includes your
   existing changes. Release tarballs/logs should not appear in the commit list.
   Commit to your chosen branch and push it. If using a PR, merge only after CI
   is satisfactory. Do not tag this version as CRAN-published yet.

2. **Check GitHub Actions.** In the repository's Actions tab, open R-CMD-check
   for the pushed commit. Enable Actions if GitHub asks. Obtain successful
   Windows release, Linux release, Linux R-devel and macOS release results.
   Inspect each check log, not just the green status: the workflow fails for
   errors/warnings but allows notes. Explain or resolve significant notes.
   These platform results have not run locally. CI rebuilds vignettes but skips
   PDF manuals; the local full check covers the manual.

3. **Distribution rights and attribution: complete.** Tiago confirmed
   distribution rights and attribution for all included material on
   14 September 2026. Keep attribution and permissions intact when adding or
   editing material. Authors@R retains the original OpenAI Codex contributor
   entry, separately from the acknowledgement in NEWS.md; its presentation
   remains an optional metadata review item.

4. **Review the external-data room.** webglm asks students to read an Elsevier
   supplementary CSV. It is not automatically downloaded in package checks;
   verify the URL, reproducibility and any reuse terms. A licensed offline
   fallback would improve resilience, but is not a current check failure.

5. **Record the actual final results.** Update cran-comments.md with the CI
   environments and results, removing its pending-results sentence. Keep brief
   explanations of unavoidable notes. As an additional check, consider uploading
   the final source archive to Winbuilder's R-devel service; results are emailed
   to the maintainer. Such uploads have not been performed by this task.

6. **Build and check the exact submission archive.** After any package-source
   change, run scripts/check-release.ps1 from PowerShell in this checkout. Its
   defaults use this computer's R/Pandoc/TeX Live paths; -RBinary and
   -PandocDirectory allow overrides. Review release-checks/escapeR.Rcheck/00check.log.
   Ensure this exact archive has no errors/warnings or unexplained significant
   notes and that R-devel/platform results still correspond to the source.
   A comments-only change does not alter the package archive, because
   cran-comments.md is excluded from builds.

7. **Submit through the CRAN form.** Read the current CRAN policies and checklist.
   Open https://cran.r-project.org/submit.html and upload the R CMD build source
   archive release-checks/escapeR_0.1.0.tar.gz. Use your maintainer details and
   the concise contents of cran-comments.md in the optional comments. Upload a
   source tarball, not a GitHub ZIP or Windows binary.

8. **Confirm the submission email.** Follow the confirmation link sent to
   tiago.marques@st-andrews.ac.uk. Watch for CRAN review feedback. Do not submit
   another copy while the first is pending. If asked to revise, address each
   item, rebuild/recheck, and explain each response in the resubmission comments.
   Prefer increasing the version for a resubmission to avoid archive confusion.

9. **After acceptance.** Wait until the CRAN package page is live, check its
   results, update README installation instructions to install.packages("escapeR"),
   and create a GitHub tag/release corresponding to the accepted source version.
   Monitor CRAN checks and keep the maintainer email working for future updates.

## Documentation maintenance

The package currently uses manually maintained grouped Rd files. Avoid blindly
regenerating all documentation and NAMESPACE with roxygen2: preserve the existing
exports and grouped help, or migrate them deliberately. No such migration is
required to submit the currently checked package.

## References

- CRAN policy: https://cran.r-project.org/web/packages/policies.html
- CRAN checklist: https://cran.r-project.org/web/packages/submission_checklist.html
- Winbuilder: https://win-builder.r-project.org/
- Windows TeX note: https://stat.ethz.ch/pipermail/r-package-devel/2022q1/007893.html
