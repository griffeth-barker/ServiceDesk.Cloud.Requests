function Invoke-SDPRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [hashtable]$InputData
    )

    $session = Get-SDPSession

    if ($session.IsTokenExpired()) {
        Update-SDPAccessToken
    }

    $uri = "$($session.ApiBaseUri)/api/v3/$Endpoint"

    if ($InputData) {
        $encoded = [System.Uri]::EscapeDataString(($InputData | ConvertTo-Json -Depth 10 -Compress))
        $uri = "${uri}?input_data=$encoded"
    }

    $params = @{
        Uri                = $uri
        Method             = $Method
        Headers            = @{ Authorization = "Zoho-oauthtoken $($session.AccessToken)" }
        SkipHttpErrorCheck = $true
        StatusCodeVariable = 'httpStatus'
    }

    # The SDP API requires all write payloads as an input_data form field,
    # consistent with how list/filter parameters are sent on GET requests.
    if ($Body -and $Method -in 'POST', 'PUT', 'PATCH') {
        $params['ContentType'] = 'application/x-www-form-urlencoded'
        $params['Body']        = @{ input_data = ($Body | ConvertTo-Json -Depth 10 -Compress) }
    }

    try {
        $response = Invoke-RestMethod @params
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

    if ($null -ne $response -and $response.PSObject.Properties['response_status']) {
        $status = $response.response_status
        if ($status.status_code -ne 2000) {
            $messages = @($status.messages).Where({ $_ }) | ForEach-Object {
                $parts = @()
                if ($_.message)     { $parts += $_.message }
                if ($_.field)       { $parts += "field=$($_.field)" }
                if ($_.status_code) { $parts += "code=$($_.status_code)" }
                $parts -join ', '
            }
            $msg = if ($messages) { $messages -join '; ' } else { "SDP API error (code $($status.status_code))" }
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    [System.Exception]::new($msg),
                    'SDPApiError',
                    [System.Management.Automation.ErrorCategory]::InvalidResult,
                    $response
                )
            )
        }
    } elseif ($httpStatus -ge 400) {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [System.Exception]::new("HTTP $httpStatus received from SDP API."),
                'SDPHttpError',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $null
            )
        )
    }

    $response
}
