function Get-SDPRequestTaskWorklog {
    <#
    .SYNOPSIS
        Retrieves worklogs for a task on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER TaskId
        The numeric ID of the parent task. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of a single worklog to retrieve.

    .PARAMETER PageSize
        Number of worklogs to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequestTaskWorklog -RequestId 12345 -TaskId 67890

    .EXAMPLE
        Get-SDPRequestTask -RequestId 12345 | Get-SDPRequestTaskWorklog -RequestId 12345
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestTaskWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$TaskId,

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
        $base = "requests/$RequestId/tasks/$TaskId/worklogs"

        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "$base/$Id"
            [SDPRequestTaskWorklog]::new($RequestId, $TaskId, $response.worklog)
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
                foreach ($w in $response.worklogs) { [SDPRequestTaskWorklog]::new($RequestId, $TaskId, $w) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint $base -InputData @{ list_info = $listInfo }
            foreach ($w in $response.worklogs) { [SDPRequestTaskWorklog]::new($RequestId, $TaskId, $w) }
        }
    }
}
