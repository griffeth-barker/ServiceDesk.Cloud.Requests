function Remove-SDPRequestApprovalLevel {
    <#
    .SYNOPSIS
        Removes an approval level from a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the approval level to remove. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestApprovalLevel -RequestId 12345 -Id 67890
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Approval Level $Id on Request $RequestId", 'Delete Approval Level')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels/$Id" -Method DELETE
        }
    }
}
