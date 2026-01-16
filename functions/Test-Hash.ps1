function Test-Hash {
<#
.SYNOPSIS
Checks if the hash in the name matches the actual file hash.

.DESCRIPTION
Compares the actual SHA-256 hash of the file with the hash included in its name.

.PARAMETER Path
Files to verify.

.PARAMETER Deep
Processes subdirectories recursively.

.EXAMPLE
Test-Hash *.mp4
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path,

        [switch]$Deep
    )

    process {
        $files = if ($Deep) {
            Get-ChildItem -Recurse -File -Path $Path
        } else {
            Get-ChildItem -File -Path $Path
        }

        foreach ($f in $files) {
            $base = $f.BaseName
            $expected = Get-HashFromName $base

            if (-not $expected) {
                Write-Host "⚠️  No hash present: $($f.FullName)"
                continue
            }

            $actual = Get-HashValue $f.FullName

            if ($expected.ToLower() -eq $actual.ToLower()) {
                Write-Host "✔️  OK: $($f.FullName)"
            } else {
                Write-Host "❌  HASH MISMATCH:"
                Write-Host "    File:      $($f.FullName)"
                Write-Host "    Expected:  $expected"
                Write-Host "    Actual:    $actual"
            }
        }
    }
}
