function Update-Hash {
<#
.SYNOPSIS
Always replaces the hash in the name with a new one.

.DESCRIPTION
Generates a new SHA-256 hash and replaces it in the file name.

.PARAMETER Path
Files to update.

.PARAMETER Deep
Processes subdirectories recursively.

.PARAMETER DryRun
Simulates the operation without modifying files.

.EXAMPLE
Update-Hash *.mp4
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path,

        [switch]$Deep,
        [switch]$DryRun
    )

    process {
        Add-Hash -Path $Path -Deep:$Deep -Replace -DryRun:$DryRun
    }
}
