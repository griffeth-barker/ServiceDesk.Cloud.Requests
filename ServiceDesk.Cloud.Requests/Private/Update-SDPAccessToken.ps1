function Update-SDPAccessToken {
    [CmdletBinding()]
    param()

    $session = $script:SDPSession

    $tokenUri = "$($session.AccountsDomain)/oauth/v2/token" +
                "?client_id=$($session.ClientId)" +
                "&client_secret=$([System.Uri]::EscapeDataString($session.GetPlainSecret()))" +
                '&grant_type=client_credentials' +
                '&scope=SDPOnDemand.requests.ALL'

    try {
        $response = Invoke-RestMethod -Uri $tokenUri -Method Post
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

    $session.AccessToken = $response.access_token
    $session.TokenExpiry = [datetime]::UtcNow.AddSeconds($response.expires_in)
}
