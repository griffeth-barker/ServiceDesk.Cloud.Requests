function Get-SDPRequest {
    <#
    .SYNOPSIS
        Retrieves one or more ServiceDesk Plus Cloud requests.

    .PARAMETER Id
        The numeric ID of a single request to retrieve. Accepts pipeline input by property name.

    .PARAMETER PageSize
        Number of requests to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER SortField
        Field name to sort results by. Default 'created_time'.

    .PARAMETER SortOrder
        Sort direction. Default 'desc'.

    .PARAMETER Filter
        Array of search criteria hashtables. Each hashtable should contain 'field',
        'condition', and 'value' keys matching the SDP API search_criteria schema.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequest -Id 12345

    .EXAMPLE
        Get-SDPRequest -All -SortOrder asc

    .EXAMPLE
        Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'is'; value = 'Open' })
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequest')]
    param(
        [Parameter(ParameterSetName = 'Id', Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [string]$SortField = 'created_time',

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('asc', 'desc')]
        [string]$SortOrder = 'desc',

        [Parameter(ParameterSetName = 'List')]
        [hashtable[]]$Filter,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$Id"
            [SDPRequest]::new($response.request)
            return
        }

        $listInfo = @{
            row_count       = $PageSize
            start_index     = $StartIndex
            sort_field      = $SortField
            sort_order      = $SortOrder
            get_total_count = $true
        }

        if ($Filter) {
            $listInfo['search_criteria'] = $Filter
        }

        if ($All) {
            $index = 1
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'requests' -InputData @{ list_info = $listInfo }
                foreach ($r in $response.requests) { [SDPRequest]::new($r) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint 'requests' -InputData @{ list_info = $listInfo }
            foreach ($r in $response.requests) { [SDPRequest]::new($r) }
        }
    }
}
