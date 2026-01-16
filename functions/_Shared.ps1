<#
.SYNOPSIS
Internal shared functions for HashTools.
#>

# Regex to detect SHA-256 in the name
$Global:HashRegex = '_([A-Fa-f0-9]{64})$'

function Get-HashFromName {
    <#
    .SYNOPSIS
    Extracts a SHA-256 hash from the base name of a file.
    #>
    param([string]$BaseName)

    if ($BaseName -match $Global:HashRegex) {
        return $Matches[1]
    }

    return $null
}

function Get-HashValue {
    <#
    .SYNOPSIS
    Calculates the SHA-256 hash of a file.
    #>
    param([string]$Path)

    return (Get-FileHash -Algorithm SHA256 $Path).Hash
}

function Build-NewName {
    <#
    .SYNOPSIS
    Builds a file name with hash.
    #>
    param(
        [string]$Base,
        [string]$Hash,
        [string]$Ext
    )

    return "${Base}_${Hash}${Ext}"
}
