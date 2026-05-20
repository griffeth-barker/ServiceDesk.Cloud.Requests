---
external help file: ServiceDesk.Cloud.Requests-help.xml
Module Name: ServiceDesk.Cloud.Requests
online version:
schema: 2.0.0
---

# Connect-SDPService

## SYNOPSIS
Establishes an authenticated session with the ServiceDesk Plus Cloud API.

## SYNTAX

### Region (Default)
```
Connect-SDPService -Region <String> -PortalName <String> -ClientId <String> -ClientSecret <SecureString>
 [-PassThru] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Custom
```
Connect-SDPService -ApiBaseUri <String> -AccountsDomain <String> -ClientId <String>
 -ClientSecret <SecureString> [-PassThru] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Obtains an OAuth2 access token via the client credentials flow and stores the
session in module scope for use by all other functions.

## EXAMPLES

### EXAMPLE 1
```
Connect-SDPService -Region US -PortalName 'itdesk' -ClientId $id -ClientSecret $secret
```

### EXAMPLE 2
```
Connect-SDPService -ApiBaseUri 'https://helpdesk.example.com/app/myportal' `
                   -AccountsDomain 'https://accounts.zoho.com' `
                   -ClientId $id -ClientSecret $secret -PassThru
```

## PARAMETERS

### -Region
The Zoho/ManageEngine data center region for your portal.
Automatically resolves
both the API base URI and the Zoho accounts domain.

```yaml
Type: String
Parameter Sets: Region
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalName
The portal identifier that appears in your SDP Cloud URL
(e.g.
'itdesk' from sdpondemand.manageengine.com/app/itdesk).

```yaml
Type: String
Parameter Sets: Region
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiBaseUri
Full base URI including the portal path for custom or vanity domains
(e.g.
'https://helpdesk.example.com/app/myportal').

```yaml
Type: String
Parameter Sets: Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountsDomain
Zoho accounts domain used for token requests when using a custom URI
(e.g.
'https://accounts.zoho.com').

```yaml
Type: String
Parameter Sets: Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
OAuth2 client ID from the Zoho Developer Console.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
OAuth2 client secret as a SecureString.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the SDPConnection object after connecting.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SDPConnection
## NOTES

## RELATED LINKS
