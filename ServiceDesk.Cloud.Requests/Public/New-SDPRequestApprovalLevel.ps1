function New-SDPRequestApprovalLevel {
    <#
    .SYNOPSIS
        Adds an approval level to a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER AdditionalFields
        Hashtable of fields for the approval level body (e.g. approver names, level number).

    .EXAMPLE
        New-SDPRequestApprovalLevel -RequestId 12345 -AdditionalFields @{ level_number = 1 }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestApprovalLevel')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter()]
        [hashtable]$AdditionalFields = @{}
    )

    process {
        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Add Approval Level')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels" -Method POST -Body @{ approval_level = $AdditionalFields }
            [SDPRequestApprovalLevel]::new($RequestId, $response.approval_level)
        }
    }
}
