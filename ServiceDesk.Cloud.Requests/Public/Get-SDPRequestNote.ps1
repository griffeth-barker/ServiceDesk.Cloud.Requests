function Get-SDPRequestNote {
    <#
    .SYNOPSIS
        Retrieves notes for a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of a single note to retrieve.

    .PARAMETER PageSize
        Number of notes to return per page. Maximum 100. Default 100.

    .PARAMETER StartIndex
        1-based index of the first record to return. Default 1.

    .PARAMETER All
        Automatically paginate through all results and emit every record.

    .EXAMPLE
        Get-SDPRequestNote -RequestId 12345

    .EXAMPLE
        Get-SDPRequest -Id 12345 | Get-SDPRequestNote -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestNote')]
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
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes/$Id"
            [SDPRequestNote]::new($RequestId, $response.request_note)
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
                $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes" -InputData @{ list_info = $listInfo }
                foreach ($n in $response.notes) { [SDPRequestNote]::new($RequestId, $n) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes" -InputData @{ list_info = $listInfo }
            foreach ($n in $response.notes) { [SDPRequestNote]::new($RequestId, $n) }
        }
    }
}
