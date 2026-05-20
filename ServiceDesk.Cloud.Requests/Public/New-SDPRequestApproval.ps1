function New-SDPRequestApproval {
    <#
    .SYNOPSIS
        Adds an approver to an approval level on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER ApprovalLevelId
        The numeric ID of the parent approval level. Accepts pipeline input by property name.

    .PARAMETER ApproverName
        Display name of the approver.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to include in the approval body.

    .EXAMPLE
        New-SDPRequestApproval -RequestId 12345 -ApprovalLevelId 67890 -ApproverName 'John Manager'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestApproval')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$ApprovalLevelId,

        [Parameter()]
        [string]$ApproverName,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('ApproverName')) { $body['approver'] = @{ name = $ApproverName } }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        $base = "requests/$RequestId/approval_levels/$ApprovalLevelId/approvals"

        if ($PSCmdlet.ShouldProcess("Approval Level $ApprovalLevelId on Request $RequestId", 'Add Approval')) {
            $response = Invoke-SDPRestMethod -Endpoint $base -Method POST -Body @{ approval = $body }
            [SDPRequestApproval]::new($RequestId, $ApprovalLevelId, $response.approval)
        }
    }
}
