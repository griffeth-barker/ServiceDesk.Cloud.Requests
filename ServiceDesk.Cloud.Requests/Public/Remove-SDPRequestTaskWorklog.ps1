function Remove-SDPRequestTaskWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a task on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER TaskId
        The numeric ID of the parent task. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the worklog to delete. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestTaskWorklog -RequestId 12345 -TaskId 67890 -Id 11111
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$TaskId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Task $TaskId / Request $RequestId", 'Delete Task Worklog')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$TaskId/worklogs/$Id" -Method DELETE
        }
    }
}
