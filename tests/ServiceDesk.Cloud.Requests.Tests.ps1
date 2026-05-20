BeforeAll {
    Import-Module "$PSScriptRoot/../ServiceDesk.Cloud.Requests/ServiceDesk.Cloud.Requests.psd1" -Force
}

Describe 'Module' {
    It 'Imports without error' {
        { Import-Module "$PSScriptRoot/../ServiceDesk.Cloud.Requests/ServiceDesk.Cloud.Requests.psd1" -Force } |
            Should -Not -Throw
    }

    It 'Exports exactly 28 functions' {
        (Get-Command -Module ServiceDesk.Cloud.Requests).Count | Should -Be 28
    }

    It 'All exported functions use an approved verb' {
        $unapproved = Get-Command -Module ServiceDesk.Cloud.Requests |
            Where-Object { (Get-Verb).Verb -notcontains $_.Verb }
        $unapproved | Should -BeNullOrEmpty
    }

    It 'All exported functions have a Synopsis' {
        $missing = Get-Command -Module ServiceDesk.Cloud.Requests | Where-Object {
            -not (Get-Help $_.Name).Synopsis
        }
        $missing | Should -BeNullOrEmpty
    }
}

Describe 'Connect-SDPService' {
    It 'Has Region parameter set' {
        $cmd = Get-Command Connect-SDPService
        $cmd.ParameterSets.Name | Should -Contain 'Region'
    }

    It 'Has Custom parameter set' {
        $cmd = Get-Command Connect-SDPService
        $cmd.ParameterSets.Name | Should -Contain 'Custom'
    }

    It 'Supports -WhatIf' {
        (Get-Command Connect-SDPService).Parameters.ContainsKey('WhatIf') | Should -BeTrue
    }
}

Describe 'Get-SDPRequest' {
    It 'Has Id parameter set' {
        (Get-Command Get-SDPRequest).ParameterSets.Name | Should -Contain 'Id'
    }

    It 'Has List parameter set as default' {
        (Get-Command Get-SDPRequest).DefaultParameterSet | Should -Be 'List'
    }

    It '-Id accepts pipeline input by property name' {
        $param = (Get-Command Get-SDPRequest).Parameters['Id']
        $param.Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
    }

    It 'Throws when no session is active' {
        $module = Get-Module ServiceDesk.Cloud.Requests
        & $module { $script:SDPSession = $null }
        { Get-SDPRequest -Id 1 } | Should -Throw
    }
}

Describe 'Remove-* functions have ConfirmImpact High' {
    $removeFunctions = Get-Command -Module ServiceDesk.Cloud.Requests -Verb Remove

    It '<Name> has ConfirmImpact High' -ForEach ($removeFunctions | ForEach-Object { @{ Name = $_.Name; Cmd = $_ } }) {
        $attr = $Cmd.ScriptBlock.Attributes | Where-Object { $_ -is [CmdletBinding] }
        # ConfirmImpact is encoded in the CmdletBinding attribute
        $attr.ConfirmImpact | Should -Be ([System.Management.Automation.ConfirmImpact]::High)
    }
}

Describe 'ShouldProcess support' {
    It '<Name> supports -WhatIf' -ForEach (
        Get-Command -Module ServiceDesk.Cloud.Requests |
            Where-Object Verb -in 'New', 'Set', 'Remove' |
            ForEach-Object { @{ Name = $_.Name; Cmd = $_ } }
    ) {
        $Cmd.Parameters.ContainsKey('WhatIf') | Should -BeTrue
    }
}

Describe 'New-SDPRequest' {
    It '-WhatIf does not throw and does not call the API' {
        $module = Get-Module ServiceDesk.Cloud.Requests
        & $module { $script:SDPSession = $null }
        { New-SDPRequest -Subject 'Test' -WhatIf } | Should -Not -Throw
    }
}
