function Add-Hash {
<#
.SYNOPSIS
Adds a SHA-256 hash to the name of one or more files.

.DESCRIPTION
Generates a SHA-256 hash and renames the file by appending it to the end of the name.
Can operate recursively and supports simulation mode.

.PARAMETER Path
Files to process.

.PARAMETER Deep
Processes subdirectories recursively.

.PARAMETER Force
Adds a hash even if one already exists.

.PARAMETER Replace
Replaces the existing hash with a new one.

.PARAMETER DryRun
Simulates the operation without modifying files.

.EXAMPLE
Add-Hash *.mp4
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path,

        [switch]$Deep,
        [switch]$Force,
        [switch]$Replace,
        [switch]$DryRun
    )

    process {
        $files = if ($Deep) {
            Get-ChildItem -Recurse -File -Path $Path
        } else {
            Get-ChildItem -File -Path $Path
        }

        foreach ($f in $files) {
            $dir  = $f.DirectoryName
            $ext  = $f.Extension
            $base = $f.BaseName

            $existing = Get-HashFromName $base

            if ($existing -and -not $Force -and -not $Replace) {
                Write-Host "⏭️  Skipped (already has hash): $($f.FullName)"
                continue
            }

            if ($existing -and $Replace) {
                $base = $base -replace $Global:HashRegex, ''
            }

            $hash = Get-HashValue $f.FullName
            $newName = Build-NewName $base $hash $ext
            $newPath = Join-Path $dir $newName

            if ($DryRun) {
                Write-Host "🔎 DRY-RUN: $($f.FullName) → $newPath"
                continue
            }

            Rename-Item $f.FullName $newName
            Write-Host "✔️  Renamed: $newPath"
        }
    }
}
