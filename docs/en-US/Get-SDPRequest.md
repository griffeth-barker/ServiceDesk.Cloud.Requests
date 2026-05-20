---
external help file: ServiceDesk.Cloud.Requests-help.xml
Module Name: ServiceDesk.Cloud.Requests
online version:
schema: 2.0.0
---

# Get-SDPRequest

## SYNOPSIS
Retrieves one or more ServiceDesk Plus Cloud requests.

## SYNTAX

### List (Default)
```
Get-SDPRequest [-PageSize <Int32>] [-StartIndex <Int32>] [-SortField <String>] [-SortOrder <String>]
 [-Filter <Hashtable[]>] [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-SDPRequest -Id <Int64> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPRequest -Id 12345
```

### EXAMPLE 2
```
Get-SDPRequest -All -SortOrder asc
```

### EXAMPLE 3
```
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'is'; value = 'Open' })
```

## PARAMETERS

### -Id
The numeric ID of a single request to retrieve.
Accepts pipeline input by property name.

```yaml
Type: Int64
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PageSize
Number of requests to return per page.
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

### -SortField
Field name to sort results by.
Default 'created_time'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: Created_time
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
Sort direction.
Default 'desc'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: Desc
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Array of search criteria hashtables.
Each hashtable should contain 'field',
'condition', and 'value' keys matching the SDP API search_criteria schema.

```yaml
Type: Hashtable[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
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

### SDPRequest
## NOTES

## RELATED LINKS
