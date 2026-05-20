function Set-SDPRequest {
    <#
    .SYNOPSIS
        Updates an existing ServiceDesk Plus Cloud request.

    .PARAMETER Id
        The numeric ID of the request to update. Accepts pipeline input by property name.

    .PARAMETER Subject
        Updated subject line.

    .PARAMETER Description
        Updated description.

    .PARAMETER RequesterName
        Display name of the new requester.

    .PARAMETER TechnicianName
        Display name of the new assigned technician.

    .PARAMETER GroupName
        Display name of the new assigned group.

    .PARAMETER StatusName
        Display name of the new status.

    .PARAMETER PriorityName
        Display name of the new priority.

    .PARAMETER UrgencyName
        Display name of the new urgency.

    .PARAMETER ImpactName
        Display name of the new impact.

    .PARAMETER CategoryName
        Display name of the new category.

    .PARAMETER SubcategoryName
        Display name of the new subcategory.

    .PARAMETER ItemName
        Display name of the new item.

    .PARAMETER RequestTypeName
        Display name of the new request type.

    .PARAMETER SiteName
        Display name of the new site.

    .PARAMETER DepartmentName
        Display name of the new department.

    .PARAMETER DueByTime
        Updated due date and time.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to update, including UDF fields.

    .EXAMPLE
        Set-SDPRequest -Id 12345 -StatusName 'Resolved' -TechnicianName 'Jane Doe'

    .EXAMPLE
        Get-SDPRequest -Id 12345 | Set-SDPRequest -PriorityName 'Critical'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequest')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Subject,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$RequesterName,

        [Parameter()]
        [string]$TechnicianName,

        [Parameter()]
        [string]$GroupName,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$UrgencyName,

        [Parameter()]
        [string]$ImpactName,

        [Parameter()]
        [string]$CategoryName,

        [Parameter()]
        [string]$SubcategoryName,

        [Parameter()]
        [string]$ItemName,

        [Parameter()]
        [string]$RequestTypeName,

        [Parameter()]
        [string]$SiteName,

        [Parameter()]
        [string]$DepartmentName,

        [Parameter()]
        [datetime]$DueByTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Subject'))        { $body['subject']      = $Subject }
        if ($PSBoundParameters.ContainsKey('Description'))    { $body['description']  = $Description }
        if ($PSBoundParameters.ContainsKey('RequesterName'))  { $body['requester']    = @{ name = $RequesterName } }
        if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician']   = @{ name = $TechnicianName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))      { $body['group']        = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('StatusName'))     { $body['status']       = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))   { $body['priority']     = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('UrgencyName'))    { $body['urgency']      = @{ name = $UrgencyName } }
        if ($PSBoundParameters.ContainsKey('ImpactName'))     { $body['impact']       = @{ name = $ImpactName } }
        if ($PSBoundParameters.ContainsKey('CategoryName'))   { $body['category']     = @{ name = $CategoryName } }
        if ($PSBoundParameters.ContainsKey('SubcategoryName')){ $body['subcategory']  = @{ name = $SubcategoryName } }
        if ($PSBoundParameters.ContainsKey('ItemName'))       { $body['item']         = @{ name = $ItemName } }
        if ($PSBoundParameters.ContainsKey('RequestTypeName')){ $body['request_type'] = @{ name = $RequestTypeName } }
        if ($PSBoundParameters.ContainsKey('SiteName'))       { $body['site']         = @{ name = $SiteName } }
        if ($PSBoundParameters.ContainsKey('DepartmentName')) { $body['department']   = @{ name = $DepartmentName } }
        if ($PSBoundParameters.ContainsKey('DueByTime')) {
            $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Request $Id", 'Update SDP Request')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$Id" -Method PUT -Body @{ request = $body }
            [SDPRequest]::new($response.request)
        }
    }
}
