# ![nutanix_powershell_512x512](https://user-images.githubusercontent.com/6964549/39462720-19304898-4d1c-11e8-928b-3fcd0d3e2b9f.png)Nutanix PowerShell Repo

##
### MODULES

### [<ins>Power-NTNX</ins>](https://github.com/rgel/Nutanix/tree/master/Power-NTNX) Nutanix PowerShell Extensions

<ins>Requirements:</ins> [NutanixCmdlets](https://portal.nutanix.com/#/page/docs/details?targetId=API_Ref-Acr_v4_6:man_ps_cmdlets_install_r.html).

To install this module, drop the entire '<b>Power-NTNX</b>' folder into one of your module directories.

The default PowerShell module paths are listed in the `$env:PSModulePath` environment variable.

To make it look better, split the paths in this manner: `$env:PSModulePath -split ';'`

The default per-user module path is: `"$env:HOMEDRIVE$env:HOMEPATH\Documents\WindowsPowerShell\Modules"`.

The default computer-level module path is: `"$env:windir\System32\WindowsPowerShell\v1.0\Modules"`.

To use the module, type following command: `Import-Module Power-NTNX -Force -Verbose`.

To see the commands imported, type `Get-Command -Module Power-NTNX`.

For help on each individual cmdlet or function, run `Get-Help CmdletName -Full [-Online][-Examples]`.

|No|Function|Description|
|----|----|----|
|1|[<b>Wait-NTNXTask</b>](https://ps1code.com)|Wait for Nutanix task with Progress bar|
