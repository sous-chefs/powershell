# powershell Cookbook CHANGELOG

This file is used to list changes made in each version of the powershell cookbook.

## Unreleased

- Remove delivery folder

## 6.2.3 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 6.2.2 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 6.2.1 - *2021-03-01*

- update powershell5 recipe to log warning that 5.1 is preinstalled on windows server 2016+

## 6.2.0 - *2021-02-08*

- Sous Chefs Adoption
- Standardise files with files in sous-chefs/repo-management
- Add GitHub Actions testing

## 6.1.3 (2018-09-20)

- Fix installation on Windows 7 x32
- Remove the non-functional powershell_module resource
- Change version to 5.1 in comments in powershell5 recipe

## 6.1.2 (2018-02-07)

- Added guard to not unzip WMF if already installed

## 6.1.1 (2017-09-28)

- Fixed reboot not found in 2008R2 bug
- Fix specs that weren't running

## 6.1.0 (2017-06-13)

- Replaces PowerShell 5 installs with PowerShell 5.1

## 6.0.0 (2017-03-20)

- Add `returns` property to windows_package resource to ensure compatibility with chef's built-in windows_package resource
- Require windows 3.0 cookbook

## 5.2.0 (2017-03-08)

- Test with Local Delivery instead of Rake
- Add integration testing in Appveyer on a Windows 2012R2 node and remove the Travis testing
- Require chef-client 12.6 or later since we're using windows_package

## 5.1.0 (2016-09-02)

- Remove the `windows_reboot` resource which has been removed from the Windows cookbook.

## 5.0.0 (2016-09-02)

- Require Chef 12.1 or later
- Dynamically install rubyzip in the provider. This eliminates the need for the default recipe, which only installed the rubyzip gem. It now just works as expected
- Test Powershell 2-5 and the custom resource in test kitchen on multiple Windows releases
- Remove test deps that are in ChefDK from the Gemfile
- Update the documentation for the powershell recipes to clarify what happens if the platform is not supported

## 4.0.0 (2016-09-02)

- Remove support for Windows XP, 2003, 2003 R2, and 2008
- Remove the powershell provider that was only needed for Chef 10
- Require a modern windows cookbook release
- Consistently check platform_family in recipes
- Use node.normal instead of node.set in specs
- Switch ruby linting to cookstyle and the new rakefile
- Rename the minimal recipe to test
- Avoid deprecation warnings during specs and use doc output
- Fix a long failing spec so we can get the tests green

## [v3.3.2](https://github.com/chef-cookbooks/powershell/tree/v3.3.2) (2016-06-09)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.3.1...v3.3.2)

**Merged pull requests:**

- remove deprecation warning [#89](https://github.com/chef-cookbooks/powershell/pull/89) ([mhorbul](https://github.com/mhorbul))

## [v3.3.1](https://github.com/chef-cookbooks/powershell/tree/v3.3.1) (2016-05-27)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.3.0...v3.3.1)

**Merged pull requests:**

- added success code 2359302 [#88](https://github.com/chef-cookbooks/powershell/pull/88) ([jdgoins](https://github.com/jdgoins))

## [v3.3.0](https://github.com/chef-cookbooks/powershell/tree/v3.3.0) (2016-05-17)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.2.3...v3.3.0)

**Merged pull requests:**

- Update WMF 5 binaries to the latest release [#86](https://github.com/chef-cookbooks/powershell/pull/86) ([carljohnston1](https://github.com/carljohnston1))
- MSU exit code 2359302 [#83](https://github.com/chef-cookbooks/powershell/pull/83) ([andreamaruccia](https://github.com/andreamaruccia))
- Fix new rubocop errors [#81](https://github.com/chef-cookbooks/powershell/pull/81) ([smurawski](https://github.com/smurawski))
- Semantic Version Helper [#77](https://github.com/chef-cookbooks/powershell/pull/77) ([smurawski](https://github.com/smurawski))
- Get the build green! [#76](https://github.com/chef-cookbooks/powershell/pull/76) ([smurawski](https://github.com/smurawski))
- initial appveyor.yml [#75](https://github.com/chef-cookbooks/powershell/pull/75) ([smurawski](https://github.com/smurawski))
- Add ps5 timeout [#72](https://github.com/chef-cookbooks/powershell/pull/72) ([trevorghess](https://github.com/trevorghess))

## [v3.2.3](https://github.com/chef-cookbooks/powershell/tree/v3.2.3) (2015-12-24)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.2.2...v3.2.3)

**Merged pull requests:**

- Revert to WMF 5 Production Preview [#71](https://github.com/chef-cookbooks/powershell/pull/71) ([smurawski](https://github.com/smurawski))

## [v3.2.2](https://github.com/chef-cookbooks/powershell/tree/v3.2.2) (2015-12-18)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.2.1...v3.2.2)

**Merged pull requests:**

- WMF 5 RTM Now Supports Client Builds [#67](https://github.com/chef-cookbooks/powershell/pull/67) ([smurawski](https://github.com/smurawski))

## [v3.2.1](https://github.com/chef-cookbooks/powershell/tree/v3.2.1) (2015-12-17)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.2.0...v3.2.1)

**Merged pull requests:**

- WMF 5 RTM [#66](https://github.com/chef-cookbooks/powershell/pull/66) ([smurawski](https://github.com/smurawski))
- The WMF 5.0 - info about compatibility with OS'es in the README.md file [#65](https://github.com/chef-cookbooks/powershell/pull/65) ([it-praktyk](https://github.com/it-praktyk))

## [v3.2.0](https://github.com/chef-cookbooks/powershell/tree/v3.2.0) (2015-12-14)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.7...v3.2.0)

**Merged pull requests:**

- Smurawski/powershell v5 [#64](https://github.com/chef-cookbooks/powershell/pull/64) ([smurawski](https://github.com/smurawski))
- Merging PRs - #57, #60, #61 [#63](https://github.com/chef-cookbooks/powershell/pull/63) ([smurawski](https://github.com/smurawski))
- Use all-in-one ms_dotnet cookbook [#61](https://github.com/chef-cookbooks/powershell/pull/61) ([Annih](https://github.com/Annih))
- added version attribute to allow for newer ps builds [#49](https://github.com/chef-cookbooks/powershell/pull/49) ([burnzy](https://github.com/burnzy))
- Update poweshell5 recipe to check for latest revision [#46](https://github.com/chef-cookbooks/powershell/pull/46) ([dpiessens](https://github.com/dpiessens))
- Bump version [#44](https://github.com/chef-cookbooks/powershell/pull/44) ([jaym](https://github.com/jaym))
- Added a kitchen.yml [#43](https://github.com/chef-cookbooks/powershell/pull/43) ([jaym](https://github.com/jaym))
- Powershell 5 Feb preview [#42](https://github.com/chef-cookbooks/powershell/pull/42) ([jaym](https://github.com/jaym))
- Added missing success codes in powershell 2 recipe [#41](https://github.com/chef-cookbooks/powershell/pull/41) ([NimishaS](https://github.com/NimishaS))
- Nim/powershell reboot [#38](https://github.com/chef-cookbooks/powershell/pull/38) ([NimishaS](https://github.com/NimishaS))
- Powershell reboot fixes [#37](https://github.com/chef-cookbooks/powershell/pull/37) ([tjnicholas](https://github.com/tjnicholas))
- replace powershell by powershell_script resource [#35](https://github.com/chef-cookbooks/powershell/pull/35) ([NimishaS](https://github.com/NimishaS))
- Don't reboot windows if powershell 4 is already installed [#31](https://github.com/chef-cookbooks/powershell/pull/31) ([NimishaS](https://github.com/NimishaS))
- Fix deprecated chefspec runner config [#30](https://github.com/chef-cookbooks/powershell/pull/30) ([webframp](https://github.com/webframp))
- Fix slightly dangerous rm fr. [#29](https://github.com/chef-cookbooks/powershell/pull/29) ([webframp](https://github.com/webframp))
- DSC cookbook should enable winrm with https transport [#27](https://github.com/chef-cookbooks/powershell/pull/27) ([NimishaS](https://github.com/NimishaS))
- Rspec for powershell module resource and provider [#26](https://github.com/chef-cookbooks/powershell/pull/26) ([prabhu-das](https://github.com/prabhu-das))
- Updated to PowerShell 5 September 2014 preview. [#24](https://github.com/chef-cookbooks/powershell/pull/24) ([juliandunn](https://github.com/juliandunn))
- Missed '?' on query for Windows 8.1 [#23](https://github.com/chef-cookbooks/powershell/pull/23) ([juliandunn](https://github.com/juliandunn))
- Pd/chefspec [#22](https://github.com/chef-cookbooks/powershell/pull/22) ([prabhu-das](https://github.com/prabhu-das))
- Initial draft for ps module resource [#16](https://github.com/chef-cookbooks/powershell/pull/16) ([muktaa](https://github.com/muktaa))
- Bugfix: Using attributes for bits_4 for windows_server_2008 [#13](https://github.com/chef-cookbooks/powershell/pull/13) ([jmauro](https://github.com/jmauro))

## [v3.0.7](https://github.com/chef-cookbooks/powershell/tree/v3.0.7) (2014-07-16)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.6...v3.0.7)

## [v3.0.6](https://github.com/chef-cookbooks/powershell/tree/v3.0.6) (2014-07-15)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.5...v3.0.6)

## [v3.0.5](https://github.com/chef-cookbooks/powershell/tree/v3.0.5) (2014-07-12)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.4...v3.0.5)

## [v3.0.4](https://github.com/chef-cookbooks/powershell/tree/v3.0.4) (2014-05-10)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.2...v3.0.4)

## [v3.0.2](https://github.com/chef-cookbooks/powershell/tree/v3.0.2) (2014-04-24)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v3.0.0...v3.0.2)

## [v3.0.0](https://github.com/chef-cookbooks/powershell/tree/v3.0.0) (2014-02-05)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v2.0.0...v3.0.0)

## [v2.0.0](https://github.com/chef-cookbooks/powershell/tree/v2.0.0) (2014-01-03)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/v1.1.2...v2.0.0)

**Merged pull requests:**

- [COOK-3330] Only adds the helper on windows (fixes crashes on *nix) [#5](https://github.com/chef-cookbooks/powershell/pull/5) ([skoczen](https://github.com/skoczen))

## [v1.1.2](https://github.com/chef-cookbooks/powershell/tree/v1.1.2) (2013-08-28)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/1.1.0...v1.1.2)

**Merged pull requests:**

- COOK-3000 [#4](https://github.com/chef-cookbooks/powershell/pull/4) ([stensonb](https://github.com/stensonb))

## [1.1.0](https://github.com/chef-cookbooks/powershell/tree/1.1.0) (2013-06-15)

[Full Changelog](https://github.com/chef-cookbooks/powershell/compare/1.0.8...1.1.0)

**Merged pull requests:**

- fixing foodcritic alerts [#3](https://github.com/chef-cookbooks/powershell/pull/3) ([ranjib](https://github.com/ranjib))
- Add powershell_out mixin for use in LWRPs at compile [#2](https://github.com/chef-cookbooks/powershell/pull/2) ([moserke](https://github.com/moserke))

## [1.0.8](https://github.com/chef-cookbooks/powershell/tree/1.0.8) (2012-11-26)

**Merged pull requests:**

- Added updated_by_last_action to :run action [#1](https://github.com/chef-cookbooks/powershell/pull/1) ([paulmooring](https://github.com/paulmooring))

- _This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)_
