function Remove-SDPRequest {
    <#
    .SYNOPSIS
        Permanently deletes a ServiceDesk Plus Cloud request.

    .PARAMETER Id
        The numeric ID of the request to delete. Accepts pipeline input by property name.

    .EXAMPLE
        Remove-SDPRequest -Id 12345

    .EXAMPLE
        Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'is'; value = 'Closed' }) | Remove-SDPRequest
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [long]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Request $Id", 'Delete SDP Request')) {
            Invoke-SDPRestMethod -Endpoint "requests/$Id" -Method DELETE
        }
    }
}
