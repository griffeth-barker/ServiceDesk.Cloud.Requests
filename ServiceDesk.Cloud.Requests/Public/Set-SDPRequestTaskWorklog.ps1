function Set-SDPRequestTaskWorklog {
    <#
    .SYNOPSIS
        Updates an existing worklog entry on a task in a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER TaskId
        The numeric ID of the parent task. Accepts pipeline input by property name.

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
        Set-SDPRequestTaskWorklog -RequestId 12345 -TaskId 67890 -Id 11111 `
                                  -StartTime (Get-Date).AddMinutes(-45) -EndTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestTaskWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$TaskId,

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

        if ($PSCmdlet.ShouldProcess("Worklog $Id on Task $TaskId / Request $RequestId", 'Update Task Worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$TaskId/worklogs/$Id" -Method PUT -Body @{ worklog = $body }
            [SDPRequestTaskWorklog]::new($RequestId, $TaskId, $response.worklog)
        }
    }
}
