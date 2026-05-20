function Remove-SDPRequestApproval {
    <#
    .SYNOPSIS
        Removes an approver from an approval level on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER ApprovalLevelId
        The numeric ID of the parent approval level. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the approval to remove. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestApproval -RequestId 12345 -ApprovalLevelId 67890 -Id 11111
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$ApprovalLevelId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Approval $Id on Level $ApprovalLevelId / Request $RequestId", 'Delete Approval')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels/$ApprovalLevelId/approvals/$Id" -Method DELETE
        }
    }
}
