function New-SDPRequest {
    <#
    .SYNOPSIS
        Creates a new ServiceDesk Plus Cloud request.

    .PARAMETER Subject
        The subject line of the request. Required.

    .PARAMETER Description
        The detailed description of the request.

    .PARAMETER RequesterName
        Display name of the requester.

    .PARAMETER TechnicianName
        Display name of the assigned technician.

    .PARAMETER GroupName
        Display name of the assigned group.

    .PARAMETER StatusName
        Display name of the status (e.g. 'Open').

    .PARAMETER PriorityName
        Display name of the priority (e.g. 'High').

    .PARAMETER UrgencyName
        Display name of the urgency.

    .PARAMETER ImpactName
        Display name of the impact.

    .PARAMETER CategoryName
        Display name of the category.

    .PARAMETER SubcategoryName
        Display name of the subcategory.

    .PARAMETER ItemName
        Display name of the item.

    .PARAMETER RequestTypeName
        Display name of the request type (e.g. 'Incident', 'Service Request').

    .PARAMETER SiteName
        Display name of the site.

    .PARAMETER DepartmentName
        Display name of the department.

    .PARAMETER DueByTime
        Due date and time for the request.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to include in the request body,
        including UDF fields.

    .EXAMPLE
        New-SDPRequest -Subject 'VPN not connecting' -PriorityName 'High' -RequesterName 'John Smith'

    .EXAMPLE
        New-SDPRequest -Subject 'New laptop setup' -RequestTypeName 'Service Request' `
                       -CategoryName 'Hardware' -TechnicianName 'Jane Doe'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequest')]
    param(
        [Parameter(Mandatory)]
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

    $body = @{ subject = $Subject }

    if ($PSBoundParameters.ContainsKey('Description'))     { $body['description']  = $Description }
    if ($PSBoundParameters.ContainsKey('RequesterName'))   { $body['requester']    = @{ name = $RequesterName } }
    if ($PSBoundParameters.ContainsKey('TechnicianName'))  { $body['technician']   = @{ name = $TechnicianName } }
    if ($PSBoundParameters.ContainsKey('GroupName'))       { $body['group']        = @{ name = $GroupName } }
    if ($PSBoundParameters.ContainsKey('StatusName'))      { $body['status']       = @{ name = $StatusName } }
    if ($PSBoundParameters.ContainsKey('PriorityName'))    { $body['priority']     = @{ name = $PriorityName } }
    if ($PSBoundParameters.ContainsKey('UrgencyName'))     { $body['urgency']      = @{ name = $UrgencyName } }
    if ($PSBoundParameters.ContainsKey('ImpactName'))      { $body['impact']       = @{ name = $ImpactName } }
    if ($PSBoundParameters.ContainsKey('CategoryName'))    { $body['category']     = @{ name = $CategoryName } }
    if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory']  = @{ name = $SubcategoryName } }
    if ($PSBoundParameters.ContainsKey('ItemName'))        { $body['item']         = @{ name = $ItemName } }
    if ($PSBoundParameters.ContainsKey('RequestTypeName')) { $body['request_type'] = @{ name = $RequestTypeName } }
    if ($PSBoundParameters.ContainsKey('SiteName'))        { $body['site']         = @{ name = $SiteName } }
    if ($PSBoundParameters.ContainsKey('DepartmentName'))  { $body['department']   = @{ name = $DepartmentName } }
    if ($PSBoundParameters.ContainsKey('DueByTime')) {
        $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
    }

    if ($AdditionalFields) {
        foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
    }

    if ($PSCmdlet.ShouldProcess($Subject, 'Create SDP Request')) {
        $response = Invoke-SDPRestMethod -Endpoint 'requests' -Method POST -Body @{ request = $body }
        [SDPRequest]::new($response.request)
    }
}
