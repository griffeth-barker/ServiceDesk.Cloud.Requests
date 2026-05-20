function Remove-SDPRequestTask {
    <#
    .SYNOPSIS
        Deletes a task from a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the task to delete. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestTask -RequestId 12345 -Id 67890
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Task $Id on Request $RequestId", 'Delete Task')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$Id" -Method DELETE
        }
    }
}
