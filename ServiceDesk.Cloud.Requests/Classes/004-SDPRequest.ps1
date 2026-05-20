class SDPRequest {
    [long]$Id
    [string]$Subject
    [string]$Description
    [SDPReference]$Status
    [SDPReference]$Priority
    [SDPReference]$Urgency
    [SDPReference]$Impact
    [SDPReference]$RequestType
    [SDPReference]$Mode
    [SDPReference]$Level
    [SDPReference]$Category
    [SDPReference]$Subcategory
    [SDPReference]$Item
    [SDPReference]$Requester
    [SDPReference]$Technician
    [SDPReference]$Group
    [SDPReference]$Site
    [SDPReference]$Department
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$UpdatedTime
    [nullable[datetime]]$DueByTime
    [nullable[datetime]]$ResolvedTime
    [nullable[datetime]]$ClosedTime
    [bool]$IsOverdue
    [bool]$IsEscalated
    [bool]$HasNotes
    [bool]$HasAttachments
    [pscustomobject]$RawData

    SDPRequest([object]$data) {
        $this.Id          = $data.id
        $this.Subject     = $data.subject
        $this.Description = $data.description
        $this.Status      = [SDPReference]::new($data.status)
        $this.Priority    = [SDPReference]::new($data.priority)
        $this.Urgency     = [SDPReference]::new($data.urgency)
        $this.Impact      = [SDPReference]::new($data.impact)
        $this.RequestType = [SDPReference]::new($data.request_type)
        $this.Mode        = [SDPReference]::new($data.mode)
        $this.Level       = [SDPReference]::new($data.level)
        $this.Category    = [SDPReference]::new($data.category)
        $this.Subcategory = [SDPReference]::new($data.subcategory)
        $this.Item        = [SDPReference]::new($data.item)
        $this.Requester   = [SDPReference]::new($data.requester)
        $this.Technician  = [SDPReference]::new($data.technician)
        $this.Group       = [SDPReference]::new($data.group)
        $this.Site        = [SDPReference]::new($data.site)
        $this.Department  = [SDPReference]::new($data.department)
        $this.CreatedTime  = [SDPUtil]::ParseTime($data.created_time)
        $this.UpdatedTime  = [SDPUtil]::ParseTime($data.updated_time)
        $this.DueByTime    = [SDPUtil]::ParseTime($data.due_by_time)
        $this.ResolvedTime = [SDPUtil]::ParseTime($data.resolved_time)
        $this.ClosedTime   = [SDPUtil]::ParseTime($data.closed_time)
        $this.IsOverdue      = [bool]$data.is_overdue
        $this.IsEscalated    = [bool]$data.is_escalated
        $this.HasNotes       = [bool]$data.has_notes
        $this.HasAttachments = [bool]$data.has_attachments
        $this.RawData        = $data
    }
}
