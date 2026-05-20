function Get-SDPRequestApproval {
    <#
    .SYNOPSIS
        Retrieves approvals within an approval level for a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER ApprovalLevelId
        The numeric ID of the parent approval level. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of a single approval to retrieve.

    .PARAMETER PageSize
        Number of approvals to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequestApproval -RequestId 12345 -ApprovalLevelId 67890

    .EXAMPLE
        Get-SDPRequestApprovalLevel -RequestId 12345 | Get-SDPRequestApproval -RequestId 12345
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestApproval')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$ApprovalLevelId,

        [Parameter(ParameterSetName = 'Id', Mandatory)]
        [long]$Id,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        $base = "requests/$RequestId/approval_levels/$ApprovalLevelId/approvals"

        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "$base/$Id"
            [SDPRequestApproval]::new($RequestId, $ApprovalLevelId, $response.approval)
            return
        }

        $listInfo = @{
            row_count       = $PageSize
            start_index     = $StartIndex
            get_total_count = $true
        }

        if ($All) {
            $index = 1
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint $base -InputData @{ list_info = $listInfo }
                foreach ($a in $response.approvals) { [SDPRequestApproval]::new($RequestId, $ApprovalLevelId, $a) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint $base -InputData @{ list_info = $listInfo }
            foreach ($a in $response.approvals) { [SDPRequestApproval]::new($RequestId, $ApprovalLevelId, $a) }
        }
    }
}
