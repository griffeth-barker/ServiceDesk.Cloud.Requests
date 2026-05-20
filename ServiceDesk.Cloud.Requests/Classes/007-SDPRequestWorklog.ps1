class SDPRequestWorklog {
    [long]$Id
    [long]$RequestId
    [string]$Description
    [SDPReference]$Owner
    [SDPReference]$WorklogType
    [nullable[datetime]]$StartTime
    [nullable[datetime]]$EndTime
    [long]$TimeSpent
    [pscustomobject]$RawData

    SDPRequestWorklog([long]$requestId, [object]$data) {
        $this.RequestId   = $requestId
        $this.Id          = $data.id
        $this.Description = $data.description
        $this.Owner       = [SDPReference]::new($data.owner)
        $this.WorklogType = [SDPReference]::new($data.worklog_type)
        $this.StartTime   = [SDPUtil]::ParseTime($data.start_time)
        $this.EndTime     = [SDPUtil]::ParseTime($data.end_time)
        $this.TimeSpent   = if ($data.time_spent -and $null -ne $data.time_spent.value) { [long][Math]::Round([double]"$($data.time_spent.value)" / 60000) } else { 0 }
        $this.RawData     = $data
    }
}
