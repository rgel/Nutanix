
#Requires -PSSnapin NutanixCmdletsPSSnapin

Class PowerNTNX { } #EndClass PowerNTNX

Class NutanixTask: PowerNTNX
{
	[ValidateNotNullOrEmpty()][string]$Task
	[ValidateNotNullOrEmpty()][string]$Type
	[ValidateNotNullOrEmpty()][string]$Id
	[datetime]$Invoked
	[datetime]$Started
	[datetime]$Finished
	[ValidateNotNullOrEmpty()][string]$Status
	[string]$Info
} #EndClass NutanixTask

Function Wait-NTNXTask
{
	
<#
.SYNOPSIS
	Wait for Nutanix task with Progress bar.
.DESCRIPTION
	This function waits for any Nutanix task
	optionally including its multiple subtasks with Progress bar.
.PARAMETER Task
	Specifies task object, returned by Get-NTNXTask or any other cmdlet that returns a task.
.PARAMETER WaitSubTask
	If specified, all subtasks are monitored also.
.EXAMPLE
	PS C:\> Start-NTNXMaintenanceMode -Hostid (Write-Menu -Menu (Get-NTNXHost | sort name)).uuid -EvacuationOption LIVE_MIGRATE -NonMigratableVmOption ACPI_SHUTDOWN_AND_POWER_OFF | Wait-NTNXTask -Verbose
	Enter an AHV host into Maintenance Mode and wait until the task will be completed.
.EXAMPLE
	PS C:\> Get-NTNXTask -Taskid $taskUuid | Wait-NTNXTask -ErrorAction Stop -WaitSubTask
	Wait for any running task including all its subtasks.
.NOTES
	Author      :: Roman Gelman @rgelman75
	Shell       :: Tested on PowerShell 5.0 & NutanixCmdlets 2.5
	Platform    :: Tested on AOS 5.5
	Requirement :: No
	Dependency  :: NutanixCmdlets
	Version 1.0 :: 01-May-2018 :: [Release] :: Publicly available
.LINK
	https://ps1code.com/2018/05/08/monitor-nutanix-task-powershell
#>
	
	[CmdletBinding()]
	[Alias("Wait-NutanixTask")]
	[OutputType([NutanixTask])]
	Param (
		[Parameter(Mandatory, ValueFromPipeline)]
		$Task
		 ,
		[Parameter(Mandatory = $false)]
		[switch]$WaitSubTask
	)
	
	Begin
	{
		$WarningPreference = 'SilentlyContinue'
		$FunctionName = '{0}' -f $MyInvocation.MyCommand
		Write-Verbose "$FunctionName :: Started at [$(Get-Date)]"
	}
	Process
	{
		switch ($Task)
		{
			{ $_ -is [Nutanix.Prism.DTO.Acropolis.TaskIdDTO] -or $_ -is [Nutanix.Prism.DTO.Acropolis.Tasks.TaskDTO] }
			{
				do
				{
					$TaskDTO = Get-NTNXTask -Taskid $Task.taskUuid -ErrorAction SilentlyContinue
					if ($TaskDTO.percentageComplete)
					{
						Write-Progress -Activity "Waiting for Nutanix Task [$($TaskDTO.uuid)] to complete" `
									   -CurrentOperation "Task: $($TaskDTO.operationType)" `
									   -Status "Status: $($TaskDTO.progressStatus) ..." `
									   -PercentComplete $TaskDTO.percentageComplete `
									   -ErrorAction SilentlyContinue -Id 0
						
						if ($TaskDTO.subtaskUuidList)
						{
							for ($i = 0; $i -lt $TaskDTO.subtaskUuidList.Count; $i++)
							{
								$SubTaskDTO = Get-NTNXTask -Taskid $TaskDTO.subtaskUuidList[$i] -ErrorAction SilentlyContinue
								if ($SubTaskDTO.percentageComplete)
								{
									if ($WaitSubTask)
									{	
										Write-Progress -Activity "Waiting for Nutanix SubTask [$($SubTaskDTO.uuid)] to complete" `
													   -CurrentOperation "SubTask: $($SubTaskDTO.operationType)" `
													   -Status "Status: $($SubTaskDTO.progressStatus) ..." `
													   -PercentComplete $SubTaskDTO.percentageComplete `
													   -ErrorAction SilentlyContinue -Id ($i+1)
									}
									[NutanixTask] @{
										Task = $SubTaskDTO.operationType
										Type = "SubTask_$($TaskDTO.operationType)"
										Id = $SubTaskDTO.uuid
										Invoked = (Get-Date $SubTaskDTO.createTime).ToLocalTime()
										Started = (Get-Date $SubTaskDTO.startTime).ToLocalTime()
										Finished = (Get-Date $SubTaskDTO.completeTime).ToLocalTime()
										Status = $SubTaskDTO.progressStatus
										Info = $SubTaskDTO.message
									}
								}
							}
						}
						
						Start-Sleep 1
					}
				}
				while ($TaskDTO.percentageComplete -ne 100)
				
				[NutanixTask] @{
					Task = $TaskDTO.operationType
					Type = 'Task'
					Id = $TaskDTO.uuid
					Invoked = (Get-Date $TaskDTO.createTime).ToLocalTime()
					Started = (Get-Date $TaskDTO.startTime).ToLocalTime()
					Finished = (Get-Date $TaskDTO.completeTime).ToLocalTime()
					Status = $TaskDTO.progressStatus
					Info = $TaskDTO.message
				}
			}
			default { throw "The [$Task] is NOT Nutanix task" }
		}
	}
	End { Write-Verbose "$FunctionName :: Finished at [$(Get-Date)]" }
	
} #EndFunction Wait-NTNXTask
