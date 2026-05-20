class SDPRequestApproval {
    [long]$Id
    [long]$RequestId
    [long]$ApprovalLevelId
    [SDPReference]$Approver
    [SDPReference]$Status
    [string]$Comments
    [nullable[datetime]]$ApprovedTime
    [pscustomobject]$RawData

    SDPRequestApproval([long]$requestId, [long]$approvalLevelId, [object]$data) {
        $this.RequestId       = $requestId
        $this.ApprovalLevelId = $approvalLevelId
        $this.Id              = $data.id
        $this.Approver        = [SDPReference]::new($data.approver)
        $this.Status          = [SDPReference]::new($data.status)
        $this.Comments        = $data.comments
        $this.ApprovedTime    = [SDPUtil]::ParseTime($data.approved_time)
        $this.RawData         = $data
    }
}
