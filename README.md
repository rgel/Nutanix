# ![power-ntnx-256](https://user-images.githubusercontent.com/6964549/49570432-4aeb7180-f93f-11e8-8db6-2bbfb16fef1f.png)Nutanix PowerShell Repo

### MODULES

### [<ins>Power-NTNX</ins>](https://github.com/rgel/Nutanix/tree/master/Power-NTNX) NUTANIX PowerShell Extensions

<ins>Requirements:</ins> [NutanixCmdlets](https://portal.nutanix.com/#/page/docs/details?targetId=API_Ref-Acr_v4_6:man_ps_cmdlets_install_r.html).

To install this module, drop the entire '<b>Power-NTNX</b>' folder into one of your module directories.

The default PowerShell module paths are listed in the `$env:PSModulePath` environment variable.

To make it look better, split the paths in this manner: `$env:PSModulePath -split ';'`

The default per-user module path is: `"$env:HOMEDRIVE$env:HOMEPATH\Documents\WindowsPowerShell\Modules"`.

The default computer-level module path is: `"$env:windir\System32\WindowsPowerShell\v1.0\Modules"`.

To use the module, type following command: `Import-Module Power-NTNX -Force -Verbose`.

To see the commands imported, type `Get-Command -Module Power-NTNX`.

For help on each individual cmdlet or function, run `Get-Help CmdletName -Full [-Online][-Examples]`.

To start using the functions, connect to your Cluster by `Connect-NTNXCluster` cmdlet.

|No|Cmdlet|Description|
|----|----|----|
|1|[<b>Wait-NTNXTask</b>](https://ps1code.com/2018/05/08/monitor-nutanix-task-powershell)|Wait for any Nutanix task and its subtasks with Progress bar|
