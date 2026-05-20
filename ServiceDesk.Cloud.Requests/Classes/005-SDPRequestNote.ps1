class SDPRequestNote {
    [long]$Id
    [long]$RequestId
    [string]$Description
    [bool]$IsPublic
    [bool]$NotifyTechnician
    [SDPReference]$CreatedBy
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$UpdatedTime
    [pscustomobject]$RawData

    SDPRequestNote([long]$requestId, [object]$data) {
        $this.RequestId        = $requestId
        $this.Id               = $data.id
        $this.Description      = $data.description
        $this.IsPublic         = [bool]$data.show_to_requester
        $this.NotifyTechnician = [bool]$data.notify_technician
        $this.CreatedBy        = [SDPReference]::new($data.created_by)
        $this.CreatedTime      = [SDPUtil]::ParseTime($data.created_time)
        $this.UpdatedTime      = [SDPUtil]::ParseTime($data.updated_time)
        $this.RawData          = $data
    }
}
