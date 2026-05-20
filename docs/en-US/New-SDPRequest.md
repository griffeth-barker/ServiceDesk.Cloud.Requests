---
external help file: ServiceDesk.Cloud.Requests-help.xml
Module Name: ServiceDesk.Cloud.Requests
online version:
schema: 2.0.0
---

# New-SDPRequest

## SYNOPSIS
Creates a new ServiceDesk Plus Cloud request.

## SYNTAX

```
New-SDPRequest [-Subject] <String> [[-Description] <String>] [[-RequesterName] <String>]
 [[-TechnicianName] <String>] [[-GroupName] <String>] [[-StatusName] <String>] [[-PriorityName] <String>]
 [[-UrgencyName] <String>] [[-ImpactName] <String>] [[-CategoryName] <String>] [[-SubcategoryName] <String>]
 [[-ItemName] <String>] [[-RequestTypeName] <String>] [[-SiteName] <String>] [[-DepartmentName] <String>]
 [[-DueByTime] <DateTime>] [[-AdditionalFields] <Hashtable>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-SDPRequest -Subject 'VPN not connecting' -PriorityName 'High' -RequesterName 'John Smith'
```

### EXAMPLE 2
```
New-SDPRequest -Subject 'New laptop setup' -RequestTypeName 'Service Request' `
               -CategoryName 'Hardware' -TechnicianName 'Jane Doe'
```

## PARAMETERS

### -Subject
The subject line of the request.
Required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The detailed description of the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequesterName
Display name of the requester.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TechnicianName
Display name of the assigned technician.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupName
Display name of the assigned group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusName
Display name of the status (e.g.
'Open').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PriorityName
Display name of the priority (e.g.
'High').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UrgencyName
Display name of the urgency.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpactName
Display name of the impact.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CategoryName
Display name of the category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubcategoryName
Display name of the subcategory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemName
Display name of the item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestTypeName
Display name of the request type (e.g.
'Incident', 'Service Request').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteName
Display name of the site.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DepartmentName
Display name of the department.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DueByTime
Due date and time for the request.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalFields
Hashtable of any additional fields to include in the request body,
including UDF fields.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
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

### SDPRequest
## NOTES

## RELATED LINKS
