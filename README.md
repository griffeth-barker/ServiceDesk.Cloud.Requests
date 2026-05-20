# ServiceDesk.Cloud.Requests

A PowerShell module for the [ManageEngine ServiceDesk Plus Cloud](https://www.manageengine.com/products/service-desk/) REST API — Requests surface.

Provides full CRUD coverage for requests, notes, tasks, worklogs, approval levels, approvals, and task worklogs according to Zoho's API reference collection. Authentication uses the OAuth2 client credentials flow via Zoho Accounts.

> **DISCLAIMER:**  
> This module is not affiliated with nor supported by Zoho/ManageEngine.  
> This code should be considered experimental. You should understand the code that you choose to run on your systems. This code should not be considered production ready as long as this banner is present and/or the module version is < 1.0.0.

## Requirements

- PowerShell 7.0 or later
- A ServiceDesk Plus Cloud portal
- An OAuth2 client application configured in the [Zoho Developer Console](https://api-console.zoho.com/) with `SDPOnDemand.requests.ALL` scope

## Installation

[![PSGallery Version](https://img.shields.io/powershellgallery/v/ServiceDesk.Cloud.Requests.png?style=for-the-badge&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/ServiceDesk.Cloud.Requests/0.1.2/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/ServiceDesk.Cloud.Requests.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/ServiceDesk.Cloud.Requests/0.1.2/)  

```powershell
# Via PowerShell Gallery
Install-PSResource -Name 'ServiceDesk.Cloud.Requests' -Repository PSGallery

# Via Download
# Download the project and expand the archive, then run
Import-Module ./ServiceDesk.Cloud.Requests/ServiceDesk.Cloud.Requests.psd1
```

## Quick Start

You are free to pass your API credentials however you please, but I recommend using the SecretsManagement module:

```powershell
# Connect
$clientId = Get-Secret -Name 'ZohoSdpApiClientId' -AsPlainText
$secret = Get-Secret -Name 'ZohoSdpApiClientSecret' -AsPlainText
Connect-SDPService -Region US -PortalName 'itdesk' -ClientId $clientId -ClientSecret $secret

# Retrieve a single request
Get-SDPRequest -Id 12345

# List all open requests
Get-SDPRequest -All -Filter @(@{ field = 'status.name'; condition = 'is'; value = 'Open' })

# Create a request
New-SDPRequest -Subject 'VPN not connecting' -PriorityName 'High' -RequesterName 'John Smith'

# Update a request
Set-SDPRequest -Id 12345 -StatusName 'Resolved' -TechnicianName 'Jane Doe'

# Pipeline: reassign all of a technician's open requests
Get-SDPRequest -All -Filter @(@{ field = 'technician.name'; condition = 'is'; value = 'Jane Doe' }) |
    Set-SDPRequest -TechnicianName 'John Smith'

# Add a private note
New-SDPRequestNote -RequestId 12345 -Description 'Contacted user, awaiting callback.'

# Disconnect
Disconnect-SDPService
```

## Available Commands

| Noun | Get | New | Set | Remove |
|---|---|---|---|---|
| SDPRequest | ✓ | ✓ | ✓ | ✓ |
| SDPRequestNote | ✓ | ✓ | ✓ | ✓ |
| SDPRequestTask | ✓ | ✓ | ✓ | ✓ |
| SDPRequestWorklog | ✓ | ✓ | ✓ | ✓ |
| SDPRequestApprovalLevel | ✓ | ✓ | — | ✓ |
| SDPRequestApproval | ✓ | ✓ | — | ✓ |
| SDPRequestTaskWorklog | ✓ | ✓ | ✓ | ✓ |

Plus `Connect-SDPService` and `Disconnect-SDPService`.

## Documentation

Full cmdlet reference is in [`docs/en-US/`](docs/en-US/). After importing the module, `Get-Help` works with full parameter and example detail:

```powershell
Get-Help New-SDPRequest -Full
Get-Help Get-SDPRequest -Examples
```

## Related Modules

This module covers the Requests API only. Separate modules are planned for Changes, Problems, Projects, and other SDP domains.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
