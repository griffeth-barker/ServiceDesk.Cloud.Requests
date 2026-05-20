class SDPConnection {
    [string]$ApiBaseUri
    [string]$AccountsDomain
    [string]$ClientId
    [securestring]$ClientSecret
    [string]$AccessToken
    [datetime]$TokenExpiry

    SDPConnection([string]$apiBaseUri, [string]$accountsDomain, [string]$clientId, [securestring]$clientSecret) {
        $this.ApiBaseUri     = $apiBaseUri.TrimEnd('/')
        $this.AccountsDomain = $accountsDomain.TrimEnd('/')
        $this.ClientId       = $clientId
        $this.ClientSecret   = $clientSecret
        $this.TokenExpiry    = [datetime]::MinValue
    }

    [bool] IsTokenExpired() {
        return [datetime]::UtcNow -ge $this.TokenExpiry.AddSeconds(-60)
    }

    hidden [string] GetPlainSecret() {
        return [System.Net.NetworkCredential]::new([string]::Empty, $this.ClientSecret).Password
    }
}
