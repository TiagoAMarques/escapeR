param(
  [string]$RBinary = 'C:\Program Files\R\R-4.6.0\bin\R.exe',
  [string]$PandocDirectory = 'C:\Program Files\Positron\resources\app\quarto\bin\tools'
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$output = Join-Path $repo 'release-checks'
if (!(Test-Path -LiteralPath $RBinary)) { throw "R executable not found: $RBinary. Supply -RBinary." }
New-Item -ItemType Directory -Path $output -Force | Out-Null
$names = @('LANG','LC_ALL','RSTUDIO_PANDOC','PATH','R_TEXI2DVICMD','_R_CHECK_FORCE_SUGGESTS_')
$old = @{}
foreach ($name in $names) { $old[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
Push-Location $output
try {
  $env:LANG = 'C'
  $env:LC_ALL = 'C'
  $env:_R_CHECK_FORCE_SUGGESTS_ = 'true'
  $env:R_TEXI2DVICMD = 'emulation'
  if (Test-Path -LiteralPath $PandocDirectory) {
    $env:RSTUDIO_PANDOC = $PandocDirectory
    $env:PATH = $PandocDirectory + ';' + $env:PATH
  }
  if (Test-Path -LiteralPath 'C:\texlive\2025\bin\windows') {
    $env:PATH = 'C:\texlive\2025\bin\windows;' + $env:PATH
  }
  $versionLine = Get-Content -LiteralPath (Join-Path $repo 'DESCRIPTION') | Where-Object { $_ -match '^Version:' }
  $version = ($versionLine -replace '^Version:\s*', '').Trim()
  $archive = "escapeR_$version.tar.gz"
  & $RBinary CMD build $repo
  if ($LASTEXITCODE -ne 0) { throw 'R CMD build failed.' }
  & $RBinary CMD check --as-cran $archive
  if ($LASTEXITCODE -ne 0) { throw 'R CMD check failed; inspect escapeR.Rcheck/00check.log.' }
  Copy-Item -LiteralPath 'escapeR.Rcheck/00check.log' -Destination 'windows-R-4.6.0-check.log' -Force
  Copy-Item -LiteralPath 'escapeR.Rcheck/tests/testthat.Rout' -Destination 'windows-R-4.6.0-tests.Rout' -Force
  Get-FileHash -LiteralPath $archive -Algorithm SHA256
  Write-Output 'Read the check log and explain all notes before submission.'
} finally {
  Pop-Location
  foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name, $old[$name], 'Process') }
}
