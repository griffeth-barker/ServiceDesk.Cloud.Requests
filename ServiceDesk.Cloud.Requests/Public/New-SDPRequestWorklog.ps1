function New-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Adds a worklog entry to a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Description
        Description of the work performed. Required.

    .PARAMETER OwnerId
        Numeric ID of the technician who performed the work. Required by the API.

    .PARAMETER WorklogTypeName
        Display name of the worklog type.

    .PARAMETER StartTime
        Start date and time of the work.

    .PARAMETER EndTime
        End date and time of the work.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to include in the worklog body.

    .EXAMPLE
        New-SDPRequestWorklog -RequestId 12345 -Description 'Reimaged workstation.' `
                              -OwnerId 2000000040351 -StartTime (Get-Date).AddHours(-2) -EndTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
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
        $body = @{
            description = $Description
            owner       = @{ id = $OwnerId }
        }

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

        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Add Worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs" -Method POST -Body @{ worklog = $body }
            [SDPRequestWorklog]::new($RequestId, $response.worklog)
        }
    }
}
