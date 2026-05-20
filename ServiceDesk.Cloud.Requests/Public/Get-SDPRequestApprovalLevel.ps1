function Get-SDPRequestApprovalLevel {
    <#
    .SYNOPSIS
        Retrieves approval levels for a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of a single approval level to retrieve.

    .PARAMETER PageSize
        Number of approval levels to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequestApprovalLevel -RequestId 12345

    .EXAMPLE
        Get-SDPRequest -Id 12345 | Get-SDPRequestApprovalLevel
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestApprovalLevel')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

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
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels/$Id"
            [SDPRequestApprovalLevel]::new($RequestId, $response.approval_level)
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
                $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels" -InputData @{ list_info = $listInfo }
                foreach ($al in $response.approval_levels) { [SDPRequestApprovalLevel]::new($RequestId, $al) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/approval_levels" -InputData @{ list_info = $listInfo }
            foreach ($al in $response.approval_levels) { [SDPRequestApprovalLevel]::new($RequestId, $al) }
        }
    }
}
