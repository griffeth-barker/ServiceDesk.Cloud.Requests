function New-SDPRequestTask {
    <#
    .SYNOPSIS
        Creates a new task on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Title
        The title of the task. Required.

    .PARAMETER Description
        The detailed description of the task.

    .PARAMETER StatusName
        Display name of the task status.

    .PARAMETER OwnerName
        Display name of the task owner.

    .PARAMETER AssignedToName
        Display name of the technician the task is assigned to.

    .PARAMETER PercentageCompletion
        Completion percentage (0-100).

    .PARAMETER ScheduledStartTime
        Planned start date and time.

    .PARAMETER ScheduledEndTime
        Planned end date and time.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to include in the task body.

    .EXAMPLE
        New-SDPRequestTask -RequestId 12345 -Title 'Replace hard drive' -AssignedToName 'Jane Doe'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [string]$AssignedToName,

        [Parameter()]
        [ValidateRange(0, 100)]
        [int]$PercentageCompletion,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{ title = $Title }

        if ($PSBoundParameters.ContainsKey('Description'))          { $body['description']           = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))           { $body['status']                = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('OwnerName'))            { $body['owner']                 = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('AssignedToName'))       { $body['assigned_to']           = @{ name = $AssignedToName } }
        if ($PSBoundParameters.ContainsKey('PercentageCompletion')) { $body['percentage_completion'] = $PercentageCompletion }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Request $RequestId", "Create Task '$Title'")) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks" -Method POST -Body @{ task = $body }
            [SDPRequestTask]::new($RequestId, $response.task)
        }
    }
}
