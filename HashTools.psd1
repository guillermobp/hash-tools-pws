@{
    RootModule        = 'HashTools.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b1c6c3c4-1f4d-4b4c-9f8e-123456789abc'
    Author            = 'Guillermo Barriga Placencia'
    CompanyName       = 'Bitbox'
    Description       = 'Tools to add, verify, repair, and manipulate SHA-256 hashes in file names.'
    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        'Add-Hash',
        'Test-Hash',
        'Repair-Hash',
        'Update-Hash',
        'Remove-Hash',
        'Get-HashValue'
    )
}
