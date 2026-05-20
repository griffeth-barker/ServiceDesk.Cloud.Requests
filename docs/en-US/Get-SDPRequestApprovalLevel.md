---
external help file: ServiceDesk.Cloud.Requests-help.xml
Module Name: ServiceDesk.Cloud.Requests
online version:
schema: 2.0.0
---

# Get-SDPRequestApprovalLevel

## SYNOPSIS
Retrieves approval levels for a ServiceDesk Plus Cloud request.

## SYNTAX

### List (Default)
```
Get-SDPRequestApprovalLevel -RequestId <Int64> [-PageSize <Int32>] [-StartIndex <Int32>] [-All]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-SDPRequestApprovalLevel -RequestId <Int64> -Id <Int64> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPRequestApprovalLevel -RequestId 12345
```

### EXAMPLE 2
```
Get-SDPRequest -Id 12345 | Get-SDPRequestApprovalLevel
```

## PARAMETERS

### -RequestId
The numeric ID of the parent request.
Accepts pipeline input by property name.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
The numeric ID of a single approval level to retrieve.

```yaml
Type: Int64
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of approval levels to return per page.
Maximum 100.
Default 100.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartIndex
1-based index of the first record to return.
Default 1.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Automatically paginate through all results and emit every record.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
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

### SDPRequestApprovalLevel
## NOTES

## RELATED LINKS
