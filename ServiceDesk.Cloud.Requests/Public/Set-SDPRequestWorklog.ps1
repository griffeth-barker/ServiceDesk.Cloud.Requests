function Set-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Updates an existing worklog entry on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the worklog to update. Accepts pipeline input by property name.

    .PARAMETER Description
        Updated description.

    .PARAMETER OwnerId
        Numeric ID of the new owner technician.

    .PARAMETER WorklogTypeName
        Display name of the new worklog type.

    .PARAMETER StartTime
        Updated start date and time.

    .PARAMETER EndTime
        Updated end date and time.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to update.

    .EXAMPLE
        Set-SDPRequestWorklog -RequestId 12345 -Id 67890 -Description 'Full disk replacement.' `
                              -StartTime (Get-Date).AddHours(-2) -EndTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter()]
        [string]$OwnerId,

        [Parameter()]
        [string]$WorklogTypeName,

        [Parameter()]
        [datetime]$StartTime,

        [Parameter()]
        [datetime]$EndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))     { $body['description']  = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerId'))         { $body['owner']        = @{ id = $OwnerId } }
        if ($PSBoundParameters.ContainsKey('WorklogTypeName')) { $body['worklog_type'] = @{ name = $WorklogTypeName } }
        if ($PSBoundParameters.ContainsKey('StartTime')) {
            $body['start_time'] = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('EndTime')) {
            $body['end_time'] = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Worklog $Id on Request $RequestId", 'Update Worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs/$Id" -Method PUT -Body @{ worklog = $body }
            [SDPRequestWorklog]::new($RequestId, $response.worklog)
        }
    }
}
