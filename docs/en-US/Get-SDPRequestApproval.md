---
external help file: ServiceDesk.Cloud.Requests-help.xml
Module Name: ServiceDesk.Cloud.Requests
online version:
schema: 2.0.0
---

# Get-SDPRequestApproval

## SYNOPSIS
Retrieves approvals within an approval level for a ServiceDesk Plus Cloud request.

## SYNTAX

### List (Default)
```
Get-SDPRequestApproval -RequestId <Int64> -ApprovalLevelId <Int64> [-PageSize <Int32>] [-StartIndex <Int32>]
 [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-SDPRequestApproval -RequestId <Int64> -ApprovalLevelId <Int64> -Id <Int64>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPRequestApproval -RequestId 12345 -ApprovalLevelId 67890
```

### EXAMPLE 2
```
Get-SDPRequestApprovalLevel -RequestId 12345 | Get-SDPRequestApproval -RequestId 12345
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

### -ApprovalLevelId
The numeric ID of the parent approval level.
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
The numeric ID of a single approval to retrieve.

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
Number of approvals to return per page.
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

### SDPRequestApproval
## NOTES

## RELATED LINKS
