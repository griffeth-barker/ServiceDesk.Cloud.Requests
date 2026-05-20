class SDPRequestTask {
    [long]$Id
    [long]$RequestId
    [string]$Title
    [string]$Description
    [SDPReference]$Status
    [SDPReference]$Owner
    [SDPReference]$AssignedTo
    [int]$PercentageCompletion
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$ScheduledStartTime
    [nullable[datetime]]$ScheduledEndTime
    [nullable[datetime]]$ActualStartTime
    [nullable[datetime]]$ActualEndTime
    [pscustomobject]$RawData

    SDPRequestTask([long]$requestId, [object]$data) {
        $this.RequestId            = $requestId
        $this.Id                   = $data.id
        $this.Title                = $data.title
        $this.Description          = $data.description
        $this.Status               = [SDPReference]::new($data.status)
        $this.Owner                = [SDPReference]::new($data.owner)
        $this.AssignedTo           = [SDPReference]::new($data.assigned_to)
        $this.PercentageCompletion = [int]$data.percentage_completion
        $this.CreatedTime          = [SDPUtil]::ParseTime($data.created_time)
        $this.ScheduledStartTime   = [SDPUtil]::ParseTime($data.scheduled_start_time)
        $this.ScheduledEndTime     = [SDPUtil]::ParseTime($data.scheduled_end_time)
        $this.ActualStartTime      = [SDPUtil]::ParseTime($data.actual_start_time)
        $this.ActualEndTime        = [SDPUtil]::ParseTime($data.actual_end_time)
        $this.RawData              = $data
    }
}
