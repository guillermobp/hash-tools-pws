function Repair-Hash {
<#
.SYNOPSIS
Corrige hashes incorrectos en nombres de archivo.

.DESCRIPTION
Si el hash del nombre no coincide con el hash real, lo reemplaza.

.PARAMETER Path
Archivos a reparar.

.PARAMETER Deep
Procesa subdirectorios recursivamente.

.PARAMETER DryRun
Simula la operación sin modificar archivos.

.EXAMPLE
Repair-Hash *.mp4
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

            $expected = Get-HashFromName $base

            if (-not $expected) {
                Write-Host "⚠️  No tiene hash: $($f.FullName)"
                continue
            }

            $actual = Get-HashValue $f.FullName

            if ($expected.ToLower() -eq $actual.ToLower()) {
                Write-Host "✔️  OK: $($f.FullName)"
                continue
            }

            $cleanBase = $base -replace $Global:HashRegex, ''
            $newName = Build-NewName $cleanBase $actual $ext
            $newPath = Join-Path $dir $newName

            if ($DryRun) {
                Write-Host "🔎 DRY-RUN FIX: $($f.FullName) → $newPath"
                continue
            }

            Rename-Item $f.FullName $newName
            Write-Host "🔧 FIXED: $newPath"
        }
    }
}
