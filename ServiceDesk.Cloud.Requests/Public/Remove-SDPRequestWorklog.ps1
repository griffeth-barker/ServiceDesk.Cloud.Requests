function Remove-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the worklog to delete. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestWorklog -RequestId 12345 -Id 67890
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Request $RequestId", 'Delete Worklog')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs/$Id" -Method DELETE
        }
    }
}
