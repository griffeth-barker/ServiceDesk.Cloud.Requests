class SDPReference {
    [string]$Id
    [string]$Name

    SDPReference() {}

    SDPReference([object]$data) {
        if ($null -eq $data) { return }
        $this.Id   = $data.id
        $this.Name = $data.name
    }

    [string] ToString() {
        return $this.Name ?? [string]::Empty
    }
}
