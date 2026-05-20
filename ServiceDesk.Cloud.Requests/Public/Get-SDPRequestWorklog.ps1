function Get-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Retrieves worklogs for a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of a single worklog to retrieve.

    .PARAMETER PageSize
        Number of worklogs to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequestWorklog -RequestId 12345

    .EXAMPLE
        Get-SDPRequest -Id 12345 | Get-SDPRequestWorklog -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestWorklog')]
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
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs/$Id"
            [SDPRequestWorklog]::new($RequestId, $response.worklog)
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
                $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs" -InputData @{ list_info = $listInfo }
                foreach ($w in $response.worklogs) { [SDPRequestWorklog]::new($RequestId, $w) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs" -InputData @{ list_info = $listInfo }
            foreach ($w in $response.worklogs) { [SDPRequestWorklog]::new($RequestId, $w) }
        }
    }
}
