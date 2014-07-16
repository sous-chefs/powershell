powershell Cookbook CHANGELOG
=============================
This file is used to list changes made in each version of the powershell cookbook.

v3.0.7 (2014-07-16)
-------------------
- Truly fix broken cookbook upload

v3.0.6 (2014-07-15)
-------------------
- Fixes a broken cookbook upload

v3.0.5 (2014-07-11)
-------------------
- Use attributes for bits_4 rather than hardcoding (@jmauro)
- Update to Powershell 5.0 May 2014 preview

v3.0.4 (2014-05-09)
-------------------
- [COOK-4634] - Implement Powershell 5.0 (preview)
- [COOK-4638] - PowerShell 4.0 install failing on clean Windows 2008 R2 install.

v3.0.2 (2014-04-23)
-------------------
- [COOK-4480] - Fix download URL for Windows6.0-KB968930-x86.msu

v3.0.0 (2014-02-05)
-------------------
* [COOK-4130] - Refactor Powershell cookbook to allow installing PowerShell 3.0 and 4.0
* [COOK-4132] - Warn user if they are still using these LWRPs in Chef 11.6.x

v2.0.0 (2014-01-03)
-------------------
[COOK-4168] Circular dep on powershell - moving powershell libraries into windows. removing dependency on powershell

v1.1.2
------
### Bug
- **[COOK-3000](https://tickets.opscode.com/browse/COOK-3000)** - Fix typo that prevented module loading

v1.1.0
------
### Bug
- [COOK-2974]: powershell cookbook has foodcritic failures

### Improvement
- [COOK-2586]: Create a `powershell_out` mixin to be able to use in LWRPs for calling powershell

v1.0.8
------
- [COOK-1834] - fix broken notifies

v1.0.6
------
- Refactor the powershell resource from a core-Chef monkey-patch into a proper LWRP.
- Take advantage of native Win32 support for `cwd` and `environment` in Chef 0.10.8+.
- [COOK-630] force powershell scripts to terminate immediately and return an error code on failure
- ensure more sane default options are set on PowerShell process

v1.0.4
------
- [COOK-988] - Powershell never exists on the powershell resource

v1.0.2
------
- always reference powershell.exe in a fully qualified way in case PATH
- move download url and checksums to attribute file
- massive refactor of default recipe...leverages windows_package and version helper provided by recent windows cookbook updates

v1.0.1
------
- [COOK-581] force 64-bit powershell process from 32-bit ruby processes

v1.0.0
------
- initial release
