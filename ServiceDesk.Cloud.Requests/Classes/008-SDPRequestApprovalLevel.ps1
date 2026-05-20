class SDPRequestApprovalLevel {
    [long]$Id
    [long]$RequestId
    [int]$LevelNumber
    [SDPReference]$Status
    [pscustomobject]$RawData

    SDPRequestApprovalLevel([long]$requestId, [object]$data) {
        $this.RequestId   = $requestId
        $this.Id          = $data.id
        $this.LevelNumber = [int]$data.level_number
        $this.Status      = [SDPReference]::new($data.status)
        $this.RawData     = $data
    }
}
