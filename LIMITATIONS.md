# Limitations

## Package Availability

### APT (Debian/Ubuntu)

- Not applicable. This cookbook manages Microsoft Windows Management Framework installers on Windows only.

### DNF/YUM (RHEL family)

- Not applicable. This cookbook manages Microsoft Windows Management Framework installers on Windows only.

### Windows

- Windows PowerShell 2.0 is enabled through built-in Windows features on Windows Server 2008 R2 / Windows 7 and Windows Server 2012 / Windows 8.
- Windows Management Framework 3.0 packages are published for Windows 7 SP1 and Windows Server 2008 R2 SP1 only.
- Windows Management Framework 4.0 packages are published for Windows 7 SP1, Windows Server 2008 R2 SP1, and Windows Server 2012.
- Windows Management Framework 5.1 packages are published for Windows 7 SP1 / Windows Server 2008 R2 SP1, Windows Server 2012, and Windows Server 2012 R2 / Windows 8.1.
- Windows Server 2016 and newer ship with Windows PowerShell 5.1, so the cookbook treats WMF 5.1 as built in on those releases.

## Architecture Limitations

- WMF 3.0 and WMF 4.0 provide both `x86` and `x64` packages for Windows 7 SP1 / Windows Server 2008 R2 SP1.
- WMF 4.0 on Windows Server 2012 is `x64` only.
- WMF 5.1 on Windows Server 2012 is `x64` only.
- WMF 5.1 on Windows 8.1 / Windows Server 2012 R2 is available for `x86` and `x64`.

## Source/Compiled Installation

- Not applicable. Microsoft distributes WMF through signed Windows features, `.msu`, and `.zip` archives.
- WMF 3.0 requires .NET Framework 4.0.
- WMF 4.0 and WMF 5.1 require .NET Framework 4.5 or newer.

## Known Issues

- WMF 2.0, 3.0, and 4.0 are tied to operating systems that are beyond mainstream support; keep them for legacy compatibility only.
- Windows Server 2012 and Windows Server 2012 R2 are past extended support and only available under Microsoft ESU.
- The active test surface in this cookbook is limited to Windows Server 2019 because it has a stable local Vagrant box and a matching CI exec target.
