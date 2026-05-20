function New-SDPRequestNote {
    <#
    .SYNOPSIS
        Adds a note to a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Description
        The note content. Required.

    .PARAMETER IsPublic
        When true the note is visible to requesters. Default false.

    .PARAMETER NotifyTechnician
        When true an email notification is sent to the assigned technician. Default false.

    .PARAMETER AdditionalFields
        Hashtable of any additional fields to include in the note body.

    .EXAMPLE
        New-SDPRequestNote -RequestId 12345 -Description 'Contacted user, awaiting callback.' -IsPublic $false
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter()]
        [bool]$IsPublic = $false,

        [Parameter()]
        [bool]$NotifyTechnician = $false,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{
            description        = $Description
            show_to_requester  = $IsPublic
            notify_technician  = $NotifyTechnician
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Add Note')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes" -Method POST -Body @{ request_note = $body }
            [SDPRequestNote]::new($RequestId, $response.request_note)
        }
    }
}
