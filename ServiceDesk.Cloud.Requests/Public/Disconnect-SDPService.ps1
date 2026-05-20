function Disconnect-SDPService {
    <#
    .SYNOPSIS
        Clears the active ServiceDesk Plus Cloud session from module scope.

    .EXAMPLE
        Disconnect-SDPService
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($PSCmdlet.ShouldProcess('SDP session', 'Disconnect')) {
        $script:SDPSession = $null
    }
}
