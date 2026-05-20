function Remove-SDPRequestNote {
    <#
    .SYNOPSIS
        Deletes a note from a ServiceDesk Plus Cloud request.

    .PARAMETER RequestId
        The numeric ID of the parent request. Accepts pipeline input by property name.

    .PARAMETER Id
        The numeric ID of the note to delete. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequestNote -RequestId 12345 -Id 67890
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Note $Id on Request $RequestId", 'Delete Note')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes/$Id" -Method DELETE
        }
    }
}
