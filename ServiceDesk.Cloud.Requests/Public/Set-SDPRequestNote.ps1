function Set-SDPRequestNote {
    <#
    .SYNOPSIS
        Updates an existing note on a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the note to update. Accepts pipeline input by property name.

    .PARAMETER Description
        Updated note content.

    .PARAMETER IsPublic
        Updated public visibility flag.

    .PARAMETER NotifyTechnician
        Updated technician notification flag.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to update.

    .EXAMPLE
        Set-SDPRequestNote -RequestId 12345 -Id 67890 -Description 'Updated: user confirmed issue resolved.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter()]
        [bool]$IsPublic,

        [Parameter()]
        [bool]$NotifyTechnician,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))      { $body['description']       = $Description }
        if ($PSBoundParameters.ContainsKey('IsPublic'))         { $body['show_to_requester'] = $IsPublic }
        if ($PSBoundParameters.ContainsKey('NotifyTechnician')) { $body['notify_technician'] = $NotifyTechnician }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Note $Id on Request $RequestId", 'Update Note')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes/$Id" -Method PUT -Body @{ request_note = $body }
            [SDPRequestNote]::new($RequestId, $response.request_note)
        }
    }
}
