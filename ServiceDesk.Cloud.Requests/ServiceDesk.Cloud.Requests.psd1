@{
    ModuleVersion        = '0.1.0'
    GUID                 = 'a3f2c1d4-e5b6-4789-a012-b3c4d5e6f789'
    Author               = 'Griffeth Barker (github@griff.systems)'
    Description          = 'PowerShell script module for ManageEngine ServiceDesk Plus Cloud Requests API.'
    PowerShellVersion    = '7.0'
    RootModule           = 'ServiceDesk.Cloud.Requests.psm1'
    HelpInfoURI          = 'https://github.com/griffeth-barker/ServiceDesk.Cloud.Requests'
    FunctionsToExport    = @(
        'Connect-SDPService'
        'Disconnect-SDPService'
        'Get-SDPRequest'
        'New-SDPRequest'
        'Set-SDPRequest'
        'Remove-SDPRequest'
        'Get-SDPRequestNote'
        'New-SDPRequestNote'
        'Set-SDPRequestNote'
        'Remove-SDPRequestNote'
        'Get-SDPRequestTask'
        'New-SDPRequestTask'
        'Set-SDPRequestTask'
        'Remove-SDPRequestTask'
        'Get-SDPRequestWorklog'
        'New-SDPRequestWorklog'
        'Set-SDPRequestWorklog'
        'Remove-SDPRequestWorklog'
        'Get-SDPRequestApprovalLevel'
        'New-SDPRequestApprovalLevel'
        'Remove-SDPRequestApprovalLevel'
        'Get-SDPRequestApproval'
        'New-SDPRequestApproval'
        'Remove-SDPRequestApproval'
        'Get-SDPRequestTaskWorklog'
        'New-SDPRequestTaskWorklog'
        'Set-SDPRequestTaskWorklog'
        'Remove-SDPRequestTaskWorklog'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API')
            ProjectUri = 'https://github.com/griffeth-barker/ServiceDesk.Cloud.Requests'
        }
    }
}
