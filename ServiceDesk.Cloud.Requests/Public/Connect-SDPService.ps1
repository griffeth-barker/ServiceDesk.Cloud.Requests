function Connect-SDPService {
    <#
    .SYNOPSIS
        Establishes an authenticated session with the ServiceDesk Plus Cloud API.

    .DESCRIPTION
        Obtains an OAuth2 access token via the client credentials flow and stores the
        session in module scope for use by all other functions.

    .PARAMETER Region
        The Zoho/ManageEngine data center region for your portal. Automatically resolves
        both the API base URI and the Zoho accounts domain.

    .PARAMETER PortalName
        The portal identifier that appears in your SDP Cloud URL
        (e.g. 'itdesk' from sdpondemand.manageengine.com/app/itdesk).

    .PARAMETER ApiBaseUri
        Full base URI including the portal path for custom or vanity domains
        (e.g. 'https://helpdesk.example.com/app/myportal').

    .PARAMETER AccountsDomain
        Zoho accounts domain used for token requests when using a custom URI
        (e.g. 'https://accounts.zoho.com').

    .PARAMETER ClientId
        OAuth2 client ID from the Zoho Developer Console.

    .PARAMETER ClientSecret
        OAuth2 client secret as a SecureString.

    .PARAMETER PassThru
        Returns the SDPConnection object after connecting.

    .EXAMPLE
        Connect-SDPService -Region US -PortalName 'itdesk' -ClientId $id -ClientSecret $secret

    .EXAMPLE
        Connect-SDPService -ApiBaseUri 'https://helpdesk.example.com/app/myportal' `
                           -AccountsDomain 'https://accounts.zoho.com' `
                           -ClientId $id -ClientSecret $secret -PassThru
    #>
    [CmdletBinding(DefaultParameterSetName = 'Region', SupportsShouldProcess)]
    [OutputType('SDPConnection')]
    param(
        [Parameter(ParameterSetName = 'Region', Mandatory)]
        [ValidateSet('US', 'EU', 'AU', 'IN', 'JP', 'CA')]
        [string]$Region,

        [Parameter(ParameterSetName = 'Region', Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PortalName,

        [Parameter(ParameterSetName = 'Custom', Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiBaseUri,

        [Parameter(ParameterSetName = 'Custom', Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AccountsDomain,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ClientId,

        [Parameter(Mandatory)]
        [securestring]$ClientSecret,

        [switch]$PassThru
    )

    $regionMap = @{
        US = @{ Api = 'https://sdpondemand.manageengine.com';    Auth = 'https://accounts.zoho.com' }
        EU = @{ Api = 'https://sdpondemand.manageengine.eu';     Auth = 'https://accounts.zoho.eu' }
        AU = @{ Api = 'https://sdpondemand.manageengine.com.au'; Auth = 'https://accounts.zoho.com.au' }
        IN = @{ Api = 'https://sdpondemand.manageengine.in';     Auth = 'https://accounts.zoho.in' }
        JP = @{ Api = 'https://sdpondemand.manageengine.jp';     Auth = 'https://accounts.zoho.jp' }
        CA = @{ Api = 'https://sdpondemand.manageengine.ca';     Auth = 'https://accounts.zohocloud.ca' }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Region') {
        $map            = $regionMap[$Region]
        $ApiBaseUri     = "$($map.Api)/app/$PortalName"
        $AccountsDomain = $map.Auth
    }

    if (-not $PSCmdlet.ShouldProcess($ApiBaseUri, 'Connect to ServiceDesk Plus')) {
        return
    }

    $session = [SDPConnection]::new($ApiBaseUri, $AccountsDomain, $ClientId, $ClientSecret)
    $script:SDPSession = $session
    Update-SDPAccessToken

    if ($PassThru) {
        $session
    }
}
