# HashTools

HashTools is a lightweight PowerShell module for managing SHA‑256 hashes embedded in filenames.  
It helps you ensure file integrity, detect corruption, and maintain consistent naming conventions across large collections of files (videos, datasets, media libraries, backups, etc.).

## ✨ Features

- Add a SHA‑256 hash to filenames  
- Verify that the hash in the filename matches the file contents  
- Repair incorrect hashes  
- Replace existing hashes with new ones  
- Remove hashes from filenames  
- Recursive processing (`-Deep`)  
- Dry‑run mode (`-DryRun`)  
- Fully compliant with PowerShell Approved Verbs  
- Clean modular architecture

## 📦 Installation

Clone or download this repository, then copy the module folder to:

`~/Documents/PowerShell/Modules/HashTools`


Or import directly from the project directory:

```powershell
Import-Module ./HashTools
```
