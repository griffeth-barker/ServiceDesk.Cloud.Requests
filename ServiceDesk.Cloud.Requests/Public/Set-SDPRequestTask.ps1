function Set-SDPRequestTask {
    <#
    .SYNOPSIS
        Updates an existing task on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the task to update. Accepts pipeline input by property name.

    .PARAMETER Title
        Updated task title.

    .PARAMETER Description
        Updated task description.

    .PARAMETER StatusName
        Display name of the new task status.

    .PARAMETER OwnerName
        Display name of the new task owner.

    .PARAMETER AssignedToName
        Display name of the new assigned technician.

    .PARAMETER PercentageCompletion
        Updated completion percentage (0-100).

    .PARAMETER ScheduledStartTime
        Updated planned start date and time.

    .PARAMETER ScheduledEndTime
        Updated planned end date and time.

    .PARAMETER ActualStartTime
        Actual start date and time.

    .PARAMETER ActualEndTime
        Actual end date and time.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to update.

    .EXAMPLE
        Set-SDPRequestTask -RequestId 12345 -Id 67890 -PercentageCompletion 75 -StatusName 'In Progress'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id,

        [Parameter()]
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
        [datetime]$ActualStartTime,

        [Parameter()]
        [datetime]$ActualEndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))               { $body['title']                 = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))         { $body['description']           = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))          { $body['status']                = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('OwnerName'))           { $body['owner']                 = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('AssignedToName'))      { $body['assigned_to']           = @{ name = $AssignedToName } }
        if ($PSBoundParameters.ContainsKey('PercentageCompletion')){ $body['percentage_completion'] = $PercentageCompletion }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ActualStartTime')) {
            $body['actual_start_time'] = @{ value = [DateTimeOffset]::new($ActualStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ActualEndTime')) {
            $body['actual_end_time'] = @{ value = [DateTimeOffset]::new($ActualEndTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Task $Id on Request $RequestId", 'Update Task')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$Id" -Method PUT -Body @{ task = $body }
            [SDPRequestTask]::new($RequestId, $response.task)
        }
    }
}
