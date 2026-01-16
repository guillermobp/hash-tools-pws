function Remove-Hash {
<#
.SYNOPSIS
Removes the hash from the file name.

.DESCRIPTION
Removes the SHA-256 hash from the file name if it exists.

.PARAMETER Path
Files to process.

.PARAMETER Deep
Processes subdirectories recursively.

.PARAMETER DryRun
Simulates the operation without modifying files.

.EXAMPLE
Remove-Hash *.mp4
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path,

        [switch]$Deep,
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

            if (-not $existing) {
                Write-Host "⏭️  No hash present: $($f.FullName)"
                continue
            }

            $cleanBase = $base -replace $Global:HashRegex, ''
            $newName = "${cleanBase}${ext}"
            $newPath = Join-Path $dir $newName

            if ($DryRun) {
                Write-Host "🔎 DRY-RUN REMOVE: $($f.FullName) → $newPath"
                continue
            }

            Rename-Item $f.FullName $newName
            Write-Host "🧹 HASH REMOVED: $newPath"
        }
    }
}
